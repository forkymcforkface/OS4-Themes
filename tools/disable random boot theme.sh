#!/bin/bash
f="/opt/rgbpi/autostart.sh"
sed -i '/# -- RANDOM THEME START --/,/# -- RANDOM THEME END --/d' "$f"
