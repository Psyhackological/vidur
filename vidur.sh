#!/bin/bash

shopt -s nullglob
path=$1

if [[ $# -ne 1 ]]
then
    path='.';
fi

printf "\033[37;7m$(ls $path/*.{mp4,webm,mkv,ts} -1 | wc -l)  files found!\033[0m\n";

for video_file in $path/*.{mp4,webm,mkv,ts}
do
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -sexagesimal "$video_file"
done | awk -F: ' { hours+=$1; minutes+=$2; seconds+=$3; }
    END {
        s = seconds % 60
        m = minutes + int(seconds / 60)
        h += hours + int(m / 60)
        m %= 60
        ms = s - int(s)
        ms = int(ms * 1000000)
        printf "%s\n", "\033[0;31mH\033[0m:\033[0;32mMM\033[0m:\033[0;33mSS\033[0m.\033[0;34mMICSEC\033[0m"
        printf "\033[0;31m%d\033[0m:\033[0;32m%02d\033[0m:\033[0;33m%02.f\033[0m.\033[0;34m%06d\033[0m\n", h, m, s, ms
        } 
    '
