#!/bin/bash
set -e

#CHANGE THE FILENAME HERE WITH YOUR THEME FILENAME
ARCHIVE_FILENAME="ALFa OS4 - Theme by RicHARD.7z"

####DONT TOUCH ANYTHING BELOW HERE
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$(dirname "$SCRIPT_DIR")/data/themes"
ARCHIVE_PATH="$THEMES_DIR/$ARCHIVE_FILENAME"
DEST_DIR="/opt/rgbpi/ui/themes"
LOG_FILE="$THEMES_DIR/extract_errors.log"

export ARCHIVE_PATH="$ARCHIVE_PATH"
export DEST_DIR="$DEST_DIR"
export LOG_FILE="$LOG_FILE"

cat << 'PYEOF' > theme_single_install_ui.py
import os
import sys
import time
import pygame
import subprocess

archive = os.getenv("ARCHIVE_PATH")
dest_dir = os.getenv("DEST_DIR")
log_file = os.getenv("LOG_FILE")

pygame.init()
screen = pygame.display.set_mode((320, 240))
pygame.display.set_caption("Installing Theme")
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

try:
    result = subprocess.run(["7z", "l", archive], capture_output=True, text=True)
    lines = result.stdout.splitlines()
    split_index = lines.index(next(l for l in lines if l.startswith("----")))
    first_file = next((l[53:].strip() for l in lines[split_index+1:] if l.strip()), None)
except Exception:
    first_file = None

if not first_file:
    display_progress(100, "Missing, Run Update")
    time.sleep(2)
    pygame.quit()
    sys.exit(0)

folder_name = first_file.strip("/").split("/")[0]
target_folder = os.path.join(dest_dir, folder_name)

# Get timestamp from archive
try:
    for l in lines[split_index+1:]:
        if l.strip():
            parts = l[:53].split()
            date_str = " ".join(parts[:2])
            archive_timestamp = time.mktime(time.strptime(date_str, "%Y-%m-%d %H:%M:%S"))
            break
except Exception:
    archive_timestamp = None

# Check if already installed and up to date
if archive_timestamp and os.path.exists(target_folder):
    try:
        dest_timestamp = os.path.getmtime(target_folder)
        if dest_timestamp >= archive_timestamp:
            display_progress(100, "Already up to date.")
            time.sleep(2)
            pygame.quit()
            sys.exit(0)
    except Exception:
        pass

display_progress(50, f"Installing {folder_name}...")

with open(log_file, "a") as log:
    subprocess.run(["7z", "x", "-y", archive, f"-o{dest_dir}"], stdout=log, stderr=log)

display_progress(100, "Install complete.")
time.sleep(2)
pygame.quit()
PYEOF

python3 theme_single_install_ui.py
rm -f theme_single_install_ui.py
