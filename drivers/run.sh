#!/bin/sh

set -eux

hostos_drivers="
    /lib/modules/$(uname -r)/kernel/drivers/staging/gasket/gasket.ko
    /lib/modules/$(uname -r)/kernel/drivers/staging/gasket/apex.ko
"

packaged_drivers="
    /usr/src/app/gasket/$(uname -m)/$(uname -r)/gasket.ko
    /usr/src/app/gasket/$(uname -m)/$(uname -r)/apex.ko
"

if ! insmod ${hostos_drivers}
then
    insmod ${packaged_drivers}
fi
