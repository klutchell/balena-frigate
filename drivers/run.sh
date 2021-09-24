#!/usr/bin/env bash

set -euo pipefail

do_insmod() {

	local mod_name
	local mod_path

	mod_name="${1}"
	mod_path="${2}"

    modprobe "${mod_name}" >/dev/null 2>&1 || true

	if lsmod | grep "${mod_name}" >/dev/null 2>&1
	then
		return 0
	fi

    if [ ! -f "${mod_path}" ]
    then
        return 1
    fi

    modinfo "${mod_path}"

	if ! insmod "${mod_path}"
	then
		dmesg | grep "${mod_name}"
		return 1
	else
		dmesg | grep "${mod_name}"
		return 0
	fi
}

if ! do_insmod "gasket" /usr/src/app/gasket/gasket.ko || ! do_insmod "apex" /usr/src/app/gasket/apex.ko
then
	echo "Building gasket framework and apex driver..."
    /usr/src/app/buildmod.sh /usr/src/app/gasket
    do_insmod "gasket" /usr/src/app/gasket/gasket.ko
	do_insmod "apex" /usr/src/app/gasket/apex.ko
else
	echo "Required Edge TPU drivers are loaded..."
	lsmod | grep gasket
fi
