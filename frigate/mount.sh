#!/usr/bin/env bash

mapfile -t usb_devices < <(lsblk -J -o SUBSYSTEMS,PATH | jq -r '.blockdevices[] | select(.subsystems=="block:scsi:usb:platform") | .path')

# automount USB device partitions at /media/{UUID}
for uuid in $(blkid -sUUID -ovalue "${usb_devices[@]}")
do
    mkdir -pv "/media/${uuid}"
    mount -v UUID="${uuid}" "/media/${uuid}" || continue
    usb_storage="/media/${uuid}"
    break
done

media_path="/media/data/frigate"

if [ -n "${usb_storage:-}" ]
then
    # use usb storage for media
    media_path="${usb_storage}/frigate"
fi

if [ -d /media/frigate ]
then
    # backup the old media directory if it exists for some reason
    mv /media/frigate /media/frigate.old
fi

mkdir -p "${media_path}"

ln -sf "${media_path}" /media/frigate

exec /init "${@}"
