#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/data/themes"
DEST_DIR="/opt/rgbpi/ui/themes"
LOG_FILE="$THEMES_DIR/extract_errors.log"

mkdir -p "$DEST_DIR"
> "$LOG_FILE"

TOTAL_FILES=$(find "$THEMES_DIR" -type f \( -iname "*.7z" -o -iname "*.zip" -o -iname "*.rar" \) | wc -l)
if [ "$TOTAL_FILES" -eq 0 ]; then
    echo "No archives found in $THEMES_DIR"
    exit 0
fi

# Export variables for Python
export THEMES_DIR="$THEMES_DIR"
export DEST_DIR="$DEST_DIR"
export LOG_FILE="$LOG_FILE"
export TOTAL_FILES="$TOTAL_FILES"

cat << 'EOF' > "$SCRIPT_DIR/theme_install_ui.py"
import os
import sys
import time
import pygame
import subprocess

themes_dir = os.getenv("THEMES_DIR")
dest_dir = os.getenv("DEST_DIR")
log_file = os.getenv("LOG_FILE")
total_files = int(os.getenv("TOTAL_FILES"))

pygame.init()
screen = pygame.display.set_mode((320, 240))
pygame.display.set_caption("Installing Themes")
pygame.mouse.set_visible(False)

font = pygame.font.SysFont(None, 24)
white = (255, 255, 255)
black = (0, 0, 0)
green = (0, 255, 0)

def display_progress(percent, message):
    screen.fill(black)
    text_surface = font.render(message, True, white)
    text_rect = text_surface.get_rect(center=(160, 100))
    pygame.draw.rect(screen, green, (60, 180, int(200 * (percent / 100)), 10))
    screen.blit(text_surface, text_rect)
    pygame.display.update()

archives = []
for root, _, files in os.walk(themes_dir):
    for f in files:
        if f.lower().endswith((".7z", ".zip", ".rar")):
            archives.append(os.path.join(root, f))

processed = 0
for archive in archives:
    try:
        result = subprocess.run(["7z", "l", archive], capture_output=True, text=True)
        lines = result.stdout.splitlines()
        try:
            split_index = lines.index(next(l for l in lines if l.startswith("----")))
            first_file = next((l[53:].strip() for l in lines[split_index+1:] if l.strip()), None)
        except Exception:
            first_file = None

        if not first_file:
            processed += 1
            continue

        folder_name = first_file.strip("/").split("/")[0]
        target_folder = os.path.join(dest_dir, folder_name)

        # Get timestamp from first file in archive
        try:
            for l in lines[split_index+1:]:
                if l.strip():
                    parts = l[:53].split()
                    date_str = " ".join(parts[:2])
                    archive_timestamp = time.mktime(time.strptime(date_str, "%Y-%m-%d %H:%M:%S"))
                    break
        except Exception:
            archive_timestamp = None

        # Compare timestamps
        if archive_timestamp and os.path.exists(target_folder):
            try:
                dest_timestamp = os.path.getmtime(target_folder)
                if dest_timestamp >= archive_timestamp:
                    processed += 1
                    continue
            except Exception:
                pass

        display_progress(int((processed / total_files) * 100), f"Installing {folder_name}...")

        with open(log_file, "a") as log:
            subprocess.run(["7z", "x", "-y", archive, f"-o{dest_dir}"], stdout=log, stderr=log)

    except Exception as e:
        with open(log_file, "a") as log:
            log.write(f"Error processing {archive}: {e}\n")

    processed += 1

display_progress(100, "Install complete.")
time.sleep(2)
pygame.quit()
EOF

python3 "$SCRIPT_DIR/theme_install_ui.py"
rm -f "$SCRIPT_DIR/theme_install_ui.py"
