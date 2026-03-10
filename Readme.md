# t1-pxe-boot

A simplified Docker based iPXE network boot server using a proxy DHCP (DNSmasq) and an NGINX HTTP server (hosting ISO files)

## How it works

**dnsmasq** runs in proxy DHCP mode — it does not assign IPs, routing, or DNS. The existing DHCP server on the network handles all of that. dnsmasq only intercepts PXE boot requests and injects the boot filename, leaving everything else untouched. At this time the DNSmasq container requires full access to the host networking
- DHCP discovery relies on UDP broadcasts, which Docker's bridge network does not forward to containers. Network virtualization may not work correctly with this process.
- TFTP transfers are unicast and would work through port mapping, but since DHCP already requires host networking, both services share it.

**NGINX** hosts a file server for the OS ISOs downloaded (uses an obscure port 9876)

### Boot flow

```
1. Client broadcasts DHCPDISCOVER
2. Router's DHCP server → assigns IP (unchanged)
3. dnsmasq → responds simultaneously with PXE options only (no IP)
4. Client downloads iPXE binary from TFTP (undionly.kpxe or ipxe.efi) and displays the iPXE menu. This is the first selection the user should make. (which OS to install?)
5. iPXE menu selection chainloads GRUB config and displays boot menu. This is the second selection the user should make (to be automated).
6. GRUB loads kernel and initrd. Local ISO is used to facilitate the installation.
7. Preseed/Autoinstall configuration is used to automatically configure the
hardware and orchestrate the setup process.
8. Final result (5-10 minutes depending on network speed and storage performance) should result in a login shell for the OS selected
```

## Getting Started

### Server Configuration

Edit `.env` before starting:

```
INTERFACE=<eth0 OR enp130s0, etc.>   # Network interface on this machine (while wireless is not specifically excluded most network controllers will not have a boot option for wireless)
SERVER_IP=10.130.1.132   # IP address of the machine used to host the TFPT server and HTTP server. This will bind do the host networking as proxy configuration or virtualization will interfere with lower level broadcast packets.
DHCP_NETWORK=10.130.1.0  # Subnet of proxy DHCP. This will not adversely affect your network. Only the DNS server is started and will incercept PXE boot requests broadcast on the network. The client will receive a response from the TFTP server and this will initiate the entire network boot process.
```

#### Usage

```bash
docker compose up
```

### Client Configuration

> [!WARNING]
> The process is end to end automated. DO NOT RUN THIS ON A SYSTEM YOU DO NOT WANT TO OVERWRITE. Once the preseed/autoconfig stage is reached then storage is likely to be erased. TEST ON A BARE METAL MACHINE. YOU HAVE BEEN WARNED.

>Only UEFI BIOS machines are supported at the moment. Legacy BIOS is unlikely to work correctly. If you are using a Single Board Computer or a small ARM based device this process may encounter issues due to custom hardware, driver requirements or other nuances not easily handled by the netboot. Just report them and I can investigate. Machines without a built in bootable networking device may need a USB PXE client bootloader to kickstart the process.

>Devices should be placed in PXE boot mode. You may need to change the boot order of your device to boot or select from the Boot Menu. Only IPv4 is supported at this time.

>Make sure to select the correct architecture (AMD64 or ARM64 at this time). User selections for the OS Booting are on purpose at this point. Further automation is desired but some human intervention is required.

#### CAVEATS
1. First observed storage device is used. Aware this should likely be gated. Minimum storage size is ~5 GB
2. Working on ARM device support. Have only tested this on 2 different


## Files

| Path | Description |
|------|-------------|
| `dnsmasq/dnsmasq.conf.template` | DNSMasq (DNS Masquerade) config (rendered at startup via envsubst). |
| `dnsmasq/Dockerfile` | Builds iPXE binaries from source. |
| `docker-compose.yml` | Docker compose for TFTP and HTTP containers. |
| `dnsmasq/entrypoint.sh` | Docker entrypoint shell script. Invokes the fetchall script. Creates the UEFI boot files for different platforms. |
| `tools/fetchall.sh` | Script to fetch ISOs and extract the initrd and kernel. |
| `http/www/boot.ipxe` | iPXE boot menu script. |
| `.env` | Network configuration. |
| `tftp/` | Directory to store all of the different OS data including the GRUB config, local, extracted initrd and kernel files as well as the generated UEFI boot configuration files. |
| `http/nginx.conf` | NGINX configuration file. |