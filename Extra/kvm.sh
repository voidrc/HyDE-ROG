#!/usr/bin/env bash

set -e

echo "==> Checking virtualization support..."
if [[ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -lt 1 ]]; then
  echo "❌ Your CPU does not support virtualization."
  exit 1
fi

echo "✅ CPU supports virtualization."

echo "==> Updating package list..."
sudo pacman -Sy --noconfirm

echo "==> Installing required packages..."
sudo pacman -S --needed --noconfirm qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libvirt spice-gtk

echo "✅ Packages installed."

echo "==> Starting libvirtd service..."
sudo systemctl start libvirtd

echo "✅ libvirtd is running."

echo "==> Adding $USER to libvirt group..."
sudo usermod -aG libvirt "$USER"

echo "✅ You may need to log out and log back in for group membership."

echo "==> Loading KVM kernel modules..."
if grep -q vmx /proc/cpuinfo; then
  sudo modprobe kvm_intel
elif grep -q svm /proc/cpuinfo; then
  sudo modprobe kvm_amd
else
  echo "❌ Could not detect Intel or AMD virtualization extension."
  exit 1
fi

echo "✅ KVM modules loaded."

echo "==> Checking libvirt status..."
sudo virsh list --all

VM_NAME="hyprland-test"
DISK_PATH="$HOME/VirtualBox\ VMs/${VM_NAME}.qcow2"

echo "==> Creating disk image: $DISK_PATH ..."
mkdir -p "$HOME/virt-images"
qemu-img create -f qcow2 "$DISK_PATH" 50G

echo "✅ Disk image created."

echo
echo "==============================================="
echo "✅ SETUP COMPLETE!"
echo
echo "To create your Hyprland VM with 6GB RAM, 4 CPUs, 50GB disk, run:"
echo
echo "virt-install \\"
echo "  --name $VM_NAME \\"
echo "  --ram 6144 \\"
echo "  --vcpus 4 \\"
echo "  --disk path=$DISK_PATH,format=qcow2 \\"
echo "  --os-type linux \\"
echo "  --cdrom /path/to/your/iso \\"
echo "  --network network=default \\"
echo "  --graphics spice \\"
echo "  --virt-type kvm"
echo
echo "📌 Replace /path/to/your/iso with your Hyprland/Arch ISO."
echo
echo "Enjoy!"
echo "==============================================="
