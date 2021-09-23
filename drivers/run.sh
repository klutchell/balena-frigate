#!/usr/bin/env bash

set -euo pipefail

do_insmod() {

    modprobe gasket >/dev/null 2>&1 || true
    modprobe apex >/dev/null 2>&1 || true

	if lsmod | grep gasket >/dev/null 2>&1
	then
		return 0
	fi

    if [ ! -f "${1}" ]
    then
        return 1
    fi

    modinfo "${1}"

	if ! insmod "${1}"
	then
		dmesg | grep wireguard
		return 1
	else
		dmesg | grep wireguard
		return 0
	fi
}

if ! do_insmod /usr/src/app/gasket/gasket.ko
then
	echo "Building gasket framework and apex driver..."
    /usr/src/app/buildmod.sh /usr/src/app/gasket
    do_insmod
else
fi
