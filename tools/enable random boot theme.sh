#!/bin/bash

f="/opt/rgbpi/autostart.sh"
marker="# -- RANDOM THEME START --"

if ! grep -Fq "$marker" "$f"; then
    tmp="$(mktemp)"
    echo '#!/bin/bash' > "$tmp"
    cat << 'EOF' >> "$tmp"
# -- RANDOM THEME START --
d="/opt/rgbpi/ui/themes"
c="/opt/rgbpi/ui/config.ini"
f="Mega Tech"
t=$(find "$d" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | shuf -n 1)
[ -z "$t" ] && t="$f"
sed -i "s/^theme = .*/theme = $t/" "$c"
# -- RANDOM THEME END --
EOF
    tail -n +2 "$f" >> "$tmp"
    mv "$tmp" "$f"
    chmod +x "$f"
fi
