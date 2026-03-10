#!/bin/sh
set -e

envsubst < /etc/dnsmasq.conf.template > /etc/dnsmasq.conf

TFTP=/tftp /tools/fetch-all.sh

[ -s /tftp/undionly.kpxe ]      || wget -O /tftp/undionly.kpxe      https://boot.ipxe.org/undionly.kpxe
[ -s /tftp/snponly.efi ]       || cp /usr/lib/ipxe/snponly.efi     /tftp/snponly.efi
[ -s /tftp/snponly-arm64.efi ] || wget -O /tftp/snponly-arm64.efi  https://boot.ipxe.org/arm64-efi/snponly.efi || \
                                  wget -O /tftp/snponly-arm64.efi  https://boot.ipxe.org/arm64-efi/ipxe.efi

for grub_cfg in /tftp/*/amd64/boot/grub/grub.cfg /tftp/*/arm64/boot/grub/grub.cfg; do
    [ -f "$grub_cfg" ] || continue
    os_dir=$(echo "$grub_cfg" | sed 's|/tftp/\([^/]*\)/.*|\1|')
    arch=$(echo "$grub_cfg" | sed 's|/tftp/[^/]*/\([^/]*\)/.*|\1|')

    case "$arch" in
        amd64) grub_format=x86_64-efi ; efi_name=bootnetx64.efi  ;;
        arm64) grub_format=arm64-efi  ; efi_name=bootnetaa64.efi ;;
        *)     echo "Skipping unknown arch: $arch" ; continue ;;
    esac

    mkdir -p "/tftp/${os_dir}/${arch}"
    grub-mkimage -O "$grub_format" -o "/tftp/${os_dir}/${arch}/${efi_name}" \
        -p "(tftp,${SERVER_IP})/${os_dir}/${arch}/boot/grub" \
        efinet tftp net linux normal configfile all_video echo regexp

    echo "Built ${efi_name} for ${os_dir}/${arch}"
done

exec dnsmasq --no-daemon --log-facility=- --log-queries
