## script to start omxplayer
controls="$3"
doublespeed="$2"
videoToPlay="$1"

# check if player is already running
ps cax | grep -q "omxplayer"
if [ $? -eq 0 ]; then
    sudo killall omxplayer && sudo killall omxplayer.bin
fi

# delete mkfifo file if exist
if [ -e "$controls" ]
then
    rm "$controls"
fi

mkfifo "$controls"

dir="$(dirname "$controls")"

#echo "$videoToPlay" | grep -q "youtube"
if [ $? -eq 0 ]; then
videoToPlay="$(youtube-dl -g "$videoToPlay")"


fi

omxplayer -I -o local -b "$videoToPlay" < "$controls" 2>"${dir}/vidinfo" &


echo -n "." > "$controls" &

# fix for double play speed at start
if [ "$doublespeed" = "1" ]; then
    echo -n "1" > "$controls" &
fi
