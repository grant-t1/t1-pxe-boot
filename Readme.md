# t1-pxe-boot

A simplified Docker based iPXE network boot server using a proxy DHCP (DNSmasq) and an NGINX HTTP server (hosting ISO files)

## How it works

**dnsmasq** runs in proxy DHCP mode — it does not assign IPs, routing, or DNS. The existing DHCP server on the network handles all of that. dnsmasq only intercepts PXE boot requests and injects the boot filename, leaving everything else untouched. At this time the DNSmasq container requires full access to the host networking
- DHCP discovery relies on UDP broadcasts, which Docker's bridge network does not forward to containers.
- TFTP transfers are unicast and would work through port mapping, but since DHCP already requires host networking, both services share it.

### Boot flow

```
1. Client broadcasts DHCPDISCOVER
2. Router's DHCP server → assigns IP (unchanged)
3. dnsmasq → responds simultaneously with PXE options only (no IP)
4. Client downloads iPXE binary from TFTP (undionly.kpxe or ipxe.efi)
5. iPXE fetches boot menu from HTTP and displays it
```

## Getting Started

### Server Configuration

Edit `.env` before starting:

```
INTERFACE=eth0,enp130s0       # Network interface on this machine (while wireless is not specifically excluded most network controllers will not have a boot option for wireless)
SERVER_IP=10.130.1.132   # IP address of the machine used to host the TFPT server and HTTP server. This will bind do the host networking as proxy configuration or virtualization will interfere with lower level broadcast packets.
DHCP_NETWORK=10.130.1.0  # Subnet of proxy DHCP. This will not adversely affect your network. Only the DNS server is started and will incercept PXE boot requests broadcast on the network. The client will receive a response from the TFTP server and this will initiate the entire network boot process.
```

## Usage

```bash
docker compose up
```

## Files

| Path | Description |
|------|-------------|
| `dnsmasq/dnsmasq.conf.template` | dnsmasq config (rendered at startup via envsubst) |
| `dnsmasq/Dockerfile` | Builds iPXE binaries from source |
| `docker-compose.yml` | Docker compose for TFTP and HTTP containers |
| `dnsmasq/entrypoint.sh` | Docker entrypoint shell script. Invokes the fetchall script. Creates the UEFI boot files for different platforms. |
| `tools/fetchall.sh` | Script to fetch ISOs and extract the initrd and kernel. |
| `http/www/boot.ipxe` | iPXE boot menu script |
| `.env` | Network configuration |
| `tftp/` | Directory to store all of the different OS data including the GRUB config, local, extracted initrd and kernel files as well as the generated UEFI boot configuration files |