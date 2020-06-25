# About

This will allow plugging USB devices into virt/kvm hosts dynamically using UDEV rules.

The rule will pass all USB devices to the handler script where the device can be attached or ignored.


# Install

Place 60-usb-libvirt.rules in /etc/udev/rules.d

Place libvirt-usb.sh in /etc/libvirt/

# Usage

Edit the PRODUCTS array members in the libvirt-usb.sh file with the string format

    PRODUCTS[ID]="PRODUCT_ID:VIRT_HOST_NAME"
    
    PRODUCTS[0]=1050/407/512:arch
    PRODUCTS[1]=4012/0235/323:debian
    PRODUCTS[2]=3674/724/3:windows-10

PRODUCT_ID can be gotten using udevadm and plugging or removing the device and VIRT_HOST_NAME is the name of the guest in virsh list :

    [user@host]$ udevadm monitor --subsystem-match=usb --property --udev


    UDEV  [32052.397122] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-12/1-12.4 (usb)
    ACTION=remove
    DEVPATH=/devices/pci0000:00/0000:00:14.0/usb1/1-12/1-12.4
    SUBSYSTEM=usb
    DEVNAME=/dev/bus/usb/001/027
    DEVTYPE=usb_device
    PRODUCT=1050/407/512
    TYPE=0/0/0
    BUSNUM=001
    DEVNUM=027
    SEQNUM=13996
    USEC_INITIALIZED=31805089372
    ID_PATH=pci-0000:00:14.0-usb-0:12.4
    ID_PATH_TAG=pci-0000_00_14_0-usb-0_12_4
    MAJOR=189
    MINOR=26

If the guest we are adding to were called 'arch' the string would be as follows for the above device:

    PRODUCTS[1]="1050/470/512:arch"
