#!/bin/bash
timedatectl set-timezone UTC
timedatectl set-ntp true

set -e

REPO_URL="https://github.com/forkymcforkface/OS4-Themes.git"

# Get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
touch "$SCRIPT_DIR/---------------.sh"

# Export for Python
export SCRIPT_DIR="$SCRIPT_DIR"
export REPO_URL="$REPO_URL"
export THEME_UPDATE_TEXT="Theme Update"

cat << 'EOF' > "$SCRIPT_DIR/theme_update_ui.py"
import os
import sys
import time
import pygame
import subprocess
import re

repo_url = os.getenv("REPO_URL")
script_dir = os.getenv("SCRIPT_DIR")
theme_update_text = os.getenv("THEME_UPDATE_TEXT")

pygame.init()
screen = pygame.display.set_mode((320, 240))
pygame.display.set_caption(theme_update_text)
pygame.mouse.set_visible(False)

font = pygame.font.SysFont(None, 24)
white = (255, 255, 255)
black = (0, 0, 0)
green = (0, 255, 0)

def display_progress(percent, base_message):
    bar_x, bar_y, bar_w, bar_h = 60, 180, 200, 10
    fill_target = int(bar_w * (percent / 100))
    screen.fill(black)
    message = f"{base_message} {percent}%"
    text_surface = font.render(message, True, white)
    text_rect = text_surface.get_rect(center=(160, 100))
    pygame.draw.rect(screen, green, (bar_x, bar_y, fill_target, bar_h))
    screen.blit(text_surface, text_rect)
    pygame.display.update()

def parse_git_percent(line):
    match = re.search(r'(\d+)%', line)
    if match:
        return int(match.group(1))
    return None

def run_command_with_progress(cmd, message):
    process = subprocess.Popen(
        cmd,
        cwd=script_dir,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1
    )
    current_percent = 0
    for line in process.stdout:
        line = line.strip()
        print("[PY] OUT:", line)
        percent = parse_git_percent(line)
        if percent is not None and percent != current_percent:
            current_percent = percent
            display_progress(current_percent, message)
    process.wait()
    if process.returncode != 0:
        raise subprocess.CalledProcessError(process.returncode, cmd)

def run_update():
    git_dir = os.path.join(script_dir, ".git")
    if not os.path.isdir(git_dir):
        steps = [
            ("Initializing repo", ["git", "init", "--initial-branch=main"]),
            ("Adding repo", ["git", "remote", "add", "origin", repo_url]),
        ]
        for idx, (message, cmd) in enumerate(steps):
            display_progress(5 + idx * 5, message)
            subprocess.run(cmd, cwd=script_dir, check=True)

    run_command_with_progress(["git", "fetch", "--progress", "--depth", "1", "origin"], "Downloading Updates")
    run_command_with_progress(["git", "reset", "--hard", "origin/main"], "Applying Updates")
    display_progress(100, "Wait for Reboot")
    time.sleep(5)

# Retry logic
max_retries = 2
attempt = 0

while attempt <= max_retries:
    try:
        display_progress(10, "Connecting")
        run_update()
        break
    except subprocess.CalledProcessError as e:
        print(f"[PY] Error: {e}")
        attempt += 1
        if attempt > max_retries:
            display_progress(100, "Network error. Update failed")
            time.sleep(3)
            pygame.quit()
            sys.exit(1)
        else:
            display_progress(100, f"Retrying ({attempt}/{max_retries})")
            time.sleep(2)

pygame.quit()
EOF

python3 "$SCRIPT_DIR/theme_update_ui.py"
rm -f "$SCRIPT_DIR/theme_update_ui.py"
chmod -R 777 /opt/rgbpi/ui/themes && \
chmod -R 777 "$SCRIPT_DIR"
sync

# Copy Scraper Images
cp -ru "$SCRIPT_DIR/data/images/"* /opt/rgbpi/ui/data/scraper/images 2>/dev/null && \
chmod -R 777 /opt/rgbpi/ui/data/scraper/images && \
chmod -R 777 /opt/rgbpi/ui/themes && \

mkdir -p /root/logs
touch /root/logs/rtk.log

CONFIG_FILE="/opt/rgbpi/ui/config.ini"
DATA_SOURCE=$(grep '^data_source' "$CONFIG_FILE" | cut -d= -f2 | xargs)
MOUNT_POINT="/media/$DATA_SOURCE"
GAMES_DAT="$MOUNT_POINT/dats/games.dat"
BACKUP_FILE="${GAMES_DAT}.backup"
cp "$MOUNT_POINT/dats/favorites.dat" "$MOUNT_POINT/dats/favorites.dat.backup"

# scan for games (USA)
cd /opt/rgbpi/ui

python3 -c "
import sys
sys.path.append('/opt/rgbpi/ui')
import cglobals, rtk, utils
cglobals.mount_point = '$MOUNT_POINT'
rtk.cfg_scrap_region = 'usa'
rtk.path_rgbpi_scraper = '/opt/rgbpi/ui/data/scraper'
utils.load_scraper_db()
utils.scan_games(do_scrap=True)
" >> /root/logs/rtk.log 2>&1

sleep 1
sync
cp "$MOUNT_POINT/dats/favorites.dat.backup" "$MOUNT_POINT/dats/favorites.dat"

# Normalize games.dat (fill empty Id fields with Name)
if [[ ! -f "$GAMES_DAT" ]]; then
    echo "File not found: $GAMES_DAT"
    exit 1
fi

cp "$GAMES_DAT" "$BACKUP_FILE"

python3 - <<EOF
import csv

input_file = "$BACKUP_FILE"
output_file = "$GAMES_DAT"

with open(input_file, newline='', encoding='utf-8') as f:
    reader = list(csv.reader(f, quotechar='"'))
    header = reader[0]
    data = reader[1:]

    id_index = header.index("Id") if "Id" in header else -1
    name_index = header.index("Name") if "Name" in header else -1

    if id_index != -1 and name_index != -1:
        for row in data:
            if row[id_index].strip() == "":
                row[id_index] = row[name_index]

with open(output_file, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f, quoting=csv.QUOTE_ALL)
    writer.writerow(header)
    writer.writerows(data)
EOF

sync

# Add SD card permissions fix
grep -q 'chmod 777' /opt/rgbpi/autostart.sh || sed -i '1a find /media/sd ! -perm 0777 -exec chmod 777 {} + 2>/dev/null &' /opt/rgbpi/autostart.sh

# Reload OS4 UI without reboot
pkill -f rgbpiui.pyc
setterm --clear --cursor off --foreground black --blank 0 > /dev/tty0
/opt/rgbpi/autostart.sh > /dev/null 2>&1 &

exit 0
