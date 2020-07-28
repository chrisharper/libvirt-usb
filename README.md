# About

This will allow plugging USB devices into virt/kvm hosts dynamically using UDEV rules.

The rule will pass all USB devices to the handler script where the device can be attached or ignored.


# Install

Place 60-usb-libvirt.rules in /etc/udev/rules.d

Place libvirt-usb.sh in /etc/libvirt/

Place libvirt-usb.config in /etc/libvirt/

# Usage

The config file lists devices by udev PRODUCT and the virt guest it should be attached too.

Devices will be bound to the guest on the FIRST match only and ignored if no matches or wildcard.

Edit the libvirt-usb.config file with the format

    PRODUCT:VIRT_HOST_NAME
    
For example the following defines two USB devices being added to seperate guests with a third entry adding all other devices to a third guest.

    1050/407/512:media
    1344/237/232:print_server
    *:desktop
    
the * wildcard will match all USB devices plugged into the host and bind them to the given guest.

PRODUCT can be gotten using udevadm and plugging or removing the device and VIRT_HOST_NAME is the name of the guest in virsh list :

    [user@host]$ udevadm monitor --subsystem-match=usb --property --udev | grep PRODUCT

    PRODUCT=1050/407/512
    

If the guest we are adding to were called 'desktop' the line would be as follows for the above device:

    1050/470/512:desktop
