#!/bin/bash
set -e 

DEVICE[0]=1050:0407:arch



if [[ -z "${SUBSYSTEM}" ]] || [[ "${SUBSYSTEM}" != "usb" ]]; then
  echo "Missing or incorrect udev SUBSYSTEM" 
  exit 1
fi
if [[ -z "${ID_VENDOR_ID}" ]] || [[ -z "${ID_MODEL_ID}"  ]]; then
  echo "Missing ID_VENDOR_ID or ID_MODEL_ID" 
  exit 1
fi



for i in "${DEVICE[@]}"
do
	if [[ "${ID_VENDOR_ID}:${ID_MODEL_ID}" == ${i%:*} ]] ; then 
		virt_host="${i##*:}"	
	fi
done

if [[ -z ${virt_host} ]]; then
  exit 1
else
	echo "attaching"
	
  virsh attach-device ${virt_host} /dev/stdin << EOF
    <hostdev mode='subsystem' type='usb' managed='yes'>
      <source>
        <vendor id='0x${ID_VENDOR_ID}'/>
        <product id='0x${ID_MODEL_ID}'/>
      </source>
    </hostdev>
EOF
fi
