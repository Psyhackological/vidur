#!/bin/bash

# do not show any errors while $path/*.{mp4,webm,mkv,ts,mov}
shopt -s nullglob

single_call() {
video_files_count=$(find $1 -maxdepth 1 -type f -name '*.mp4' -o -name '*.webm' -o -name '*.mkv' -o -name '*.mov' -o -name '*.ts' | wc -l);

printf "\033[37;7m${1}\033[0m\n";
printf "\033[37;7m$video_files_count files found!\033[0m\n";

for video_file in $1/*.{mp4,webm,mkv,ts,mov}
do
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -sexagesimal "$video_file"
done | awk -F: ' { hours+=$1; minutes+=$2; seconds+=$3; }
    END {
        s = seconds % 60
        m = minutes + int(seconds / 60)
        h += hours + int(m / 60)
        m %= 60
        printf "%s\n", "\033[0;31mH\033[0m:\033[0;32mMM\033[0m:\033[0;33mSS.MICSEC\033[0m"
        printf "\033[0;31m%d\033[0m:\033[0;32m%02d\033[0m:\033[0;33m%06.6f\033[0m\n", h, m, s
        } 
    '
}

x_calls() {
  for path in $*; do
    single_call $path;
  done
}

# $# = number of arguments
# -gt = greater than
if [[ $# -lt 1 ]]
then
    # that means no arguments 
    path='.';
    single_call $path
elif [[ $1 -eq "-r" ]]; then
  x_calls $(find . -type d)
else
    x_calls $*
fi
