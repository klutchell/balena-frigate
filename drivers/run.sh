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

mod_src="/usr/src/app/staging/gasket"

if ! do_insmod "gasket" "${mod_src}/gasket.ko" || ! do_insmod "apex" "${mod_src}/apex.ko"
then
	echo "Building gasket framework and apex driver..."
    /usr/src/app/build.sh "${mod_src}"
fi

if ! do_insmod "gasket" "${mod_src}/gasket.ko" || ! do_insmod "apex" "${mod_src}/apex.ko"
then
	echo "Failed to load TPU drivers, only CPU detection will be available..."
else
	echo "Required Edge TPU drivers are loaded..."
	lsmod | grep apex
fi
