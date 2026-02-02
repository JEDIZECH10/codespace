#!/bin/bash
# Ensure KVM is accessible
sudo chmod 666 /dev/kvm

# Download ISO only if it's missing
if [ ! -f ubuntu-desktop.iso ]; then
    wget -O ubuntu-desktop.iso https://releases.ubuntu.com
fi

# Create disk only if it's missing
if [ ! -f ubuntu_disk.qcow2 ]; then
    qemu-img create -f qcow2 ubuntu_disk.qcow2 25G
fi

# Start QEMU in the background
qemu-system-x86_64 -m 4G -smp 2 -enable-kvm -cpu host -drive file=ubuntu_disk.qcow2,format=qcow2 -cdrom ubuntu-desktop.iso -vnc :0 -vga virtio -display none &

# Start noVNC
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080
