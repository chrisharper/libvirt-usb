#!/bin/bash

set -e
PRODUCTS[0]="1050/407/512:arch"

if [[ -z "${SUBSYSTEM}" ]] || [[ "${SUBSYSTEM}" != "usb" ]]; then
	echo "Missing or incorrect udev SUBSYSTEM" | systemd-cat -t libvirt-usb
	exit 1
fi

if [[ -z "${PRODUCT}" ]] ; then
	echo "Missing PRODUCT"
	exit 1
fi

for i in "${PRODUCTS[@]}"
do

        if [[ "${PRODUCT}" == ${i%:*} ]] ; then
                VIRT_HOST="${i##*:}"
		PRODUCT="${i%:*}"
		tmp="${i%:*}"
		tmp2="${tmp%/*}"
		VENDOR_ID=$(printf %04d ${tmp2%/*})
		MODEL_ID=$(printf %04d ${tmp2#*/})
		if [[ "${ACTION}" == "bind" ]]; then 	
			COMMAND="attach-device"

		elif [[ "${ACTION}" == unbind ]]; then 
			COMMAND="detach-device"
		fi
        fi
done

if [[ -z ${VIRT_HOST} ]]; then
  exit 1
else
echo "Running ${COMMAND} on ${PRODUCT}" | systemd-cat -t libvirt-usb
  virsh ${COMMAND} ${VIRT_HOST} /dev/stdin << EOF
    <hostdev mode='subsystem' type='usb' managed='yes'>
      <source>
        <vendor id='0x${VENDOR_ID}'/>
        <product id='0x${MODEL_ID}'/>
      </source>
    </hostdev>
EOF
fi
