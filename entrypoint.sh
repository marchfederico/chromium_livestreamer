#!/bin/bash

echo "Starting Pulseaudio"
pulseaudio &
sleep 1

echo "Starting Xvfb"
Xvfb :1 -screen 0 1280x720x24 &
sleep 1

echo "Capturing with FFmpeg"
ffmpeg -y -f x11grab -draw_mouse 0 -s 1280x720 -r 25 -i :1.0+0,0 -f pulse -ac 2 -i default -c:v libx264 -preset veryfast -threads 3 -crf 24 -maxrate 4000k -bufsize 4000k -c:a aac -b:a 128k -f flv ${2} &

echo "Launching Chromium"
DISPLAY=:1 DISPLAY=:1.0 chromium-browser --no-sandbox --incognito --disable-gpu --user-data-dir=/tmp/test  --window-position=0,0 --window-size=1280,720 "--app=${1}"
sleep 1
