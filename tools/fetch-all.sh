#!/bin/sh
# Download kernel, initrd, and ISOs for all Ubuntu PXE boot options.
# Run from the repo root: ./tools/fetch-all.sh
# Requires: wget, xorriso
TFTP=${TFTP:-./tftp}

# ─── Ubuntu 20.04 amd64 ──────────────────────────────────────────────────────
echo "==> Ubuntu 20.04 amd64: downloading ISO..."
mkdir -p "$TFTP/ubuntu20_04/amd64" "$TFTP/iso"
wget -c --show-progress -O "$TFTP/iso/ubuntu-20.04.6-live-server-amd64.iso" \
    "https://releases.ubuntu.com/20.04.6/ubuntu-20.04.6-live-server-amd64.iso"
if [ -s "$TFTP/ubuntu20_04/amd64/linux" ] && [ -s "$TFTP/ubuntu20_04/amd64/initrd" ]; then
    echo "    kernel/initrd already present, skipping extraction."
else
    echo "    extracting kernel/initrd..."
    xorriso -osirrox on -indev "$TFTP/iso/ubuntu-20.04.6-live-server-amd64.iso" \
        -extract /casper/vmlinuz "$TFTP/ubuntu20_04/amd64/linux" \
        -extract /casper/initrd  "$TFTP/ubuntu20_04/amd64/initrd"
fi

# ─── Ubuntu 22.04 amd64 ──────────────────────────────────────────────────────
echo "==> Ubuntu 22.04 amd64: downloading ISO..."
mkdir -p "$TFTP/ubuntu22_04/amd64" "$TFTP/iso"
wget -c --show-progress -O "$TFTP/iso/ubuntu-22.04.5-live-server-amd64.iso" \
    "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
if [ -s "$TFTP/ubuntu22_04/amd64/linux" ] && [ -s "$TFTP/ubuntu22_04/amd64/initrd" ]; then
    echo "    kernel/initrd already present, skipping extraction."
else
    echo "    extracting kernel/initrd..."
    xorriso -osirrox on -indev "$TFTP/iso/ubuntu-22.04.5-live-server-amd64.iso" \
        -extract /casper/vmlinuz "$TFTP/ubuntu22_04/amd64/linux" \
        -extract /casper/initrd  "$TFTP/ubuntu22_04/amd64/initrd"
fi

# ─── Ubuntu 22.04 arm64 ──────────────────────────────────────────────────────
echo "==> Ubuntu 22.04 arm64: downloading ISO..."
mkdir -p "$TFTP/ubuntu22_04/arm64"
wget -c --show-progress -O "$TFTP/iso/ubuntu-22.04.5-live-server-arm64.iso" \
    "https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.5-live-server-arm64.iso"
if [ -s "$TFTP/ubuntu22_04/arm64/linux" ] && [ -s "$TFTP/ubuntu22_04/arm64/initrd" ]; then
    echo "    kernel/initrd already present, skipping extraction."
else
    echo "    extracting kernel/initrd..."
    xorriso -osirrox on -indev "$TFTP/iso/ubuntu-22.04.5-live-server-arm64.iso" \
        -extract /casper/vmlinuz "$TFTP/ubuntu22_04/arm64/linux" \
        -extract /casper/initrd  "$TFTP/ubuntu22_04/arm64/initrd"
fi

# ─── Ubuntu 24.04 amd64 ──────────────────────────────────────────────────────
echo "==> Ubuntu 24.04 amd64: downloading ISO..."
mkdir -p "$TFTP/ubuntu24_04/amd64"
wget -c --show-progress -O "$TFTP/iso/ubuntu-24.04.4-live-server-amd64.iso" \
    "https://releases.ubuntu.com/24.04.4/ubuntu-24.04.4-live-server-amd64.iso"
if [ -s "$TFTP/ubuntu24_04/amd64/linux" ] && [ -s "$TFTP/ubuntu24_04/amd64/initrd" ]; then
    echo "    kernel/initrd already present, skipping extraction."
else
    echo "    extracting kernel/initrd..."
    xorriso -osirrox on -indev "$TFTP/iso/ubuntu-24.04.4-live-server-amd64.iso" \
        -extract /casper/vmlinuz "$TFTP/ubuntu24_04/amd64/linux" \
        -extract /casper/initrd  "$TFTP/ubuntu24_04/amd64/initrd"
fi

# ─── Ubuntu 24.04 arm64 ──────────────────────────────────────────────────────
echo "==> Ubuntu 24.04 arm64: downloading ISO..."
mkdir -p "$TFTP/ubuntu24_04/arm64"
wget -c --show-progress -O "$TFTP/iso/ubuntu-24.04.4-live-server-arm64.iso" \
    "https://cdimage.ubuntu.com/releases/24.04.4/release/ubuntu-24.04.4-live-server-arm64.iso"
if [ -s "$TFTP/ubuntu24_04/arm64/linux" ] && [ -s "$TFTP/ubuntu24_04/arm64/initrd" ]; then
    echo "    kernel/initrd already present, skipping extraction."
else
    echo "    extracting kernel/initrd..."
    xorriso -osirrox on -indev "$TFTP/iso/ubuntu-24.04.4-live-server-arm64.iso" \
        -extract /casper/vmlinuz "$TFTP/ubuntu24_04/arm64/linux" \
        -extract /casper/initrd  "$TFTP/ubuntu24_04/arm64/initrd"
fi

echo ""
echo "==> All done. Run 'docker compose up --force-recreate' to rebuild GRUB EFI binaries."
