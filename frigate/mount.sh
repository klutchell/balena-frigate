#!/usr/bin/env bash

usb_devices=()
mapfile -O ${#usb_devices[@]} -t usb_devices < <(lsblk -J -o SUBSYSTEMS,PATH | jq -r '.blockdevices[] | select(.subsystems=="block:scsi:usb:platform") | .path')
mapfile -O ${#usb_devices[@]} -t usb_devices < <(lsblk -J -o SUBSYSTEMS,PATH | jq -r '.blockdevices[] | select(.subsystems=="block:scsi:usb:pci:platform") | .path')

# automount USB device partitions at /media/{UUID}
if [ ${#usb_devices[@]} -gt 0 ]
then
    for uuid in $(blkid -sUUID -ovalue "${usb_devices[@]}")
    do
        mkdir -pv "/media/${uuid}"
        mount -v UUID="${uuid}" "/media/${uuid}" || continue

        # bind mount on top of existing volume
        mkdir -p "/media/${uuid}/frigate" /media/frigate
        mount -v -o bind "/media/${uuid}/frigate" /media/frigate

        break
    done
fi

exec /init python3 -u -m frigate
