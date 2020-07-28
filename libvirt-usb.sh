#!/bin/bash

set -e
CONFIG=()
line_count=0

if [[ -z "${SUBSYSTEM}" ]] || [[ "${SUBSYSTEM}" != "usb" ]]; then
  echo "Missing or incorrect udev SUBSYSTEM" | systemd-cat -t libvirt-usb
  exit 1
fi

if [[ -z "${PRODUCT}" ]] ; then
  echo "Missing PRODUCT" | systemd-cat -t libvirt-usb
  exit 1
fi

while IFS= read -r line
do
  echo "Read '$line' from config " | systemd-cat -t libvirt-usb 
  CONFIG[line_count]=$line
  ((line_count+=1))
done < /etc/libvirt/libvirt-usb.config

for i in "${CONFIG[@]}"
do
  if [[ ${i%:*} == "${PRODUCT}" ||  ${i%:*} == "*" ]] ; then
    #virt gust name from config
    VIRT_HOST="${i##*:}"
    
    #PRODUCT ENV split into needed variables
    tmp="${PRODUCT%/*}"
    VENDOR_ID=${tmp%/*}
    MODEL_ID=${tmp#*/}

    if [[ "${ACTION}" == "bind" ]]; then 	
      COMMAND="attach-device"
    elif [[ "${ACTION}" == unbind ]]; then 
      COMMAND="detach-device"
    fi
    break;
  fi
done

# VIRT_HOST only gets set if there is some valid string in config
if [[ -z ${VIRT_HOST} ]]; then
  echo "No match for $PRODUCT" | systemd-cat -t libvirt-usb
  exit 1
else
  echo "Running ${COMMAND} on ${PRODUCT} against ${VIRT_HOST}" | systemd-cat -t libvirt-usb
  virsh ${COMMAND} ${VIRT_HOST} /dev/stdin << EOF
    <hostdev mode='subsystem' type='usb' managed='yes'>
      <source>
        <vendor id='0x${VENDOR_ID}'/>
        <product id='0x${MODEL_ID}'/>
      </source>
    </hostdev>
EOF
fi
