#!/usr/bin/env bash

set -e

insmod /lib/modules/*/kernel/drivers/staging/gasket/gasket.ko
insmod /lib/modules/*/kernel/drivers/staging/gasket/apex.ko
