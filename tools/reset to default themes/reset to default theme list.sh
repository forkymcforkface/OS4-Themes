#!/bin/bash

d="/opt/rgbpi/ui/themes"
c="/opt/rgbpi/ui/config.ini"
keep=("1942" "Classic Purple" "Classic Terra" "Doom" "Galaga" "Galaxian" "Ghosts'N Goblins" "Kung Fu Master" "Mario" "Mega Tech" "Micro Machines" "Neon City" "Out Run" "Sonic")

if [ -d "$d/Mega Tech" ]; then
    selected="Mega Tech"
else
    for theme in "${keep[@]}"; do
        [ -d "$d/$theme" ] && available+=("$theme")
    done
    [ ${#available[@]} -eq 0 ] && exit 1
    selected=$(shuf -e "${available[@]}" -n 1)
fi

sed -i "s/^theme = .*/theme = $selected/" "$c"

for folder in "$d"/*; do
    name=$(basename "$folder")
    if [[ ! " ${keep[*]} " =~ " $name " ]]; then
        rm -rf "$folder"
    fi
done

setterm --clear --cursor off --foreground black --blank 0 > /dev/tty0
sync
pkill -f rgbpiui.pyc
/opt/rgbpi/autostart.sh > /dev/null 2>&1 &