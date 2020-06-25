# Install

Place 60-usb-libvirt.rules in /etc/udev/rules.d

Place libvirt-usb.sh in /etc/libvirt/

# Usage

You can add  additional DEVICE array members with the string format

    DEVICE[ID]="ID_VENDOR_ID:ID_MODEL_ID:VIRT_HOST_NAME"

Device ID numbers can be gotten using lsusb and VIRT_HOST_NAME is simple the name of the host in virsh list :

    [user@host]$ lsusb 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 002: ID 1050:0407 Yubico.com Yubikey 4 OTP+U2F+CCID
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

If the host we were adding to were called 'arch' the string would be as follows for the above USB device:

    DEVICE[1]="1050:0407:arch"
