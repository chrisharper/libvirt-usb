# About

This will allow plugging USB devices into virt/kvm hosts dynamically using UDEV rules.

The rule will pass all USB devices to the handler script where the device can be attached or ignored.


# Install

Place 60-usb-libvirt.rules in /etc/udev/rules.d

Place libvirt-usb.sh in /etc/libvirt/

Place libvirt-usb.config in /etc/libvirt/

# Usage

Edit the libvirt-usb.config file with the format

    PRODUCT:VIRT_HOST_NAME
    
For example the following defines two USB devices being added to seperate guests

    1050/407/512:desktop
    1344/237/232:ubuntu_server

PRODUCT can be gotten using udevadm and plugging or removing the device and VIRT_HOST_NAME is the name of the guest in virsh list :

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

If the guest we are adding to were called 'desktop' the line would be as follows for the above device:

    1050/470/512:desktop
