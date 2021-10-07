#!/usr/bin/env sh

# automount storage disks at /media/{UUID}
for uuid in $(blkid -sUUID -ovalue /dev/sd??)
do
    mkdir -pv "/media/${uuid}"
    mount -v UUID="${uuid}" "/media/${uuid}" || continue
    usb_storage="/media/${uuid}"
    break
done

media_path="/media/data/frigate"

if [ -n "${usb_storage:-}" ]
then
    media_path="${usb_storage}/frigate"
fi

mkdir -p "${media_path}"

if [ -d /media/frigate ]
then
    cp -a /media/frigate/ "${media_path}"/
    mv /media/frigate /media/frigate.old
fi

ln -sf "${media_path}" /media/frigate

exec /init "${@}"
