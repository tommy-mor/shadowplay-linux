#! /bin/bash

set -eu

HOME=$HOME
INSTALL="/usr/bin/ffmpeg"


function gloom {
    ${INSTALL} -ac 3   -f pulse -itsoffset -0.1 -i 'alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1.monitor' -f pulse -i 'alsa_input.usb-C-Media_Electronics_Inc._Microsoft_LifeChat_LX-3000-00.multichannel-input'  -f x11grab -r 60 -s 3440x1440 -i :1 -c:v hevc_nvenc -preset fast -b:v 20M  -acodec aac -map 2:v -map 1:a -map 0:a  /tmp/out.mkv &&
    #${INSTALL} -ac 3  -f pulse -itsoffset -0.1 -i 'alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1.monitor' -f pulse -i 'alsa_input.usb-C-Media_Electronics_Inc._Microsoft_LifeChat_LX-3000-00.multichannel-input' -filter_complex amerge=inputs=2 -f x11grab -r 60 -s 3440x1440 -i :1 -c:v hevc_nvenc -preset fast -b:v 20M -map 0 -map 1 -map 2 -acodec aac -ac 2 /tmp/out.mp4 &&

    DATE=$(date +%Y-%d-%m-%H:%M:%S)
    FILE="${HOME}/Videos/gloom-${DATE}.mkv"

    ffmpeg -sseof -00:03:00 -i /tmp/out.mkv -map 0 -vcodec copy -acodec copy "$FILE" -loglevel quiet &&

    echo -e "\nSaved file ${FILE} successfully!\n"
}

function clean {
    rm /tmp/out.mp4
#   echo -e "Couldn't clean /tmp/out.mp4\n"
}

function leave {
    read -n1 -p "Keep recording? (y/n)" close

    case $close in
        y|Y) echo -e "Sure thing!\n" ;;
        n|N) exit ;;
        *) echo -e "Sure thing!\n" ;;
    esac
}

while true; do
    gloom &&
    clean &&
    leave
done

# TODO
# make it go to separate audio streams in one video file,
# make it more perfectly synced
