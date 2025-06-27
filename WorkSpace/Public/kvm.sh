#!/usr/bin/env bash

# CONFIG
VM_NAME="hyprland-test"
DISK_DIR="$HOME/virt-images"
DISK_PATH="$DISK_DIR/${VM_NAME}.qcow2"
DISK_SIZE="50G"
RAM_MB=6144
VCPUS=4
NETWORK="default"

set -e

# COLORS
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

usage() {
    echo "Usage: $0 [install|create-disk|virt-install|start|stop|status]"
    echo
    echo "  install       - Install packages, enable libvirtd, add user to libvirt group"
    echo "  create-disk   - Create qcow2 disk image (${DISK_SIZE})"
    echo "  virt-install  - Run virt-install (needs ISO path)"
    echo "  start         - Start the VM"
    echo "  stop          - Stop the VM"
    echo "  status        - Show VM status"
    exit 1
}

check_virtualization() {
    info "Checking CPU virtualization support..."
    if [[ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -lt 1 ]]; then
        error "Your CPU does not support virtualization!"
        exit 1
    fi
    info "✅ CPU virtualization is supported."
}

install_packages() {
    info "Updating packages..."
    sudo pacman -Sy --noconfirm

    info "Installing QEMU/KVM/libvirt stack..."
    sudo pacman -S --needed --noconfirm qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libvirt spice-gtk

    info "Enabling and starting libvirtd..."
    sudo systemctl enable --now libvirtd
    sudo systemctl start libvirtd

    info "Adding user '$USER' to libvirt group..."
    sudo usermod -aG libvirt "$USER"

    info "Loading KVM modules..."
    if grep -q vmx /proc/cpuinfo; then
        sudo modprobe kvm_intel
    elif grep -q svm /proc/cpuinfo; then
        sudo modprobe kvm_amd
    else
        error "❌ Could not detect Intel or AMD virtualization extensions."
        exit 1
    fi

    info "✅ Installation complete! Please log out and back in for group membership."
}

create_disk() {
    mkdir -p "$DISK_DIR"
    if [[ -f "$DISK_PATH" ]]; then
        error "Disk image already exists at $DISK_PATH"
        exit 1
    fi
    info "Creating qcow2 disk image at $DISK_PATH ..."
    qemu-img create -f qcow2 "$DISK_PATH" "$DISK_SIZE"
    info "✅ Disk image created."
}

run_virt_install() {
    if [[ ! -f "$DISK_PATH" ]]; then
        error "Disk image not found! Run '$0 create-disk' first."
        exit 1
    fi
    if [[ -z "$ISO_PATH" ]]; then
        error "ISO path not specified. Usage: ISO_PATH=/path/to.iso $0 virt-install"
        exit 1
    fi

    info "Running virt-install with:"
    echo "  VM Name : $VM_NAME"
    echo "  RAM     : ${RAM_MB} MB"
    echo "  CPUs    : $VCPUS"
    echo "  Disk    : $DISK_PATH"
    echo "  ISO     : $ISO_PATH"

    virt-install \
        --name "$VM_NAME" \
        --ram "$RAM_MB" \
        --vcpus "$VCPUS" \
        --disk path="$DISK_PATH",format=qcow2 \
        --os-type linux \
        --cdrom "$ISO_PATH" \
        --network network="$NETWORK" \
        --graphics spice \
        --virt-type kvm
}

start_vm() {
    info "Starting VM: $VM_NAME"
    virsh start "$VM_NAME"
}

stop_vm() {
    info "Stopping VM: $VM_NAME"
    virsh shutdown "$VM_NAME"
}

status_vm() {
    virsh list --all
}

# Main entrypoint
if [[ $# -lt 1 ]]; then
    usage
fi

case "$1" in
    install)
        check_virtualization
        install_packages
        ;;
    create-disk)
        create_disk
        ;;
    virt-install)
        run_virt_install
        ;;
    start)
        start_vm
        ;;
    stop)
        stop_vm
        ;;
    status)
        status_vm
        ;;
    *)
        usage
        ;;
esac
