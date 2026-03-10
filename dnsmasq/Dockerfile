FROM debian:bookworm-slim

RUN dpkg --add-architecture arm64 && \
    apt-get update -qq && apt-get install -y --no-install-recommends \
    ca-certificates \
    dnsmasq \
    gettext-base \
    ipxe \
    wget \
    xorriso \
    grub-efi-amd64-bin \
    grub-efi-arm64-bin:arm64 \
    && rm -rf /var/lib/apt/lists/*

COPY dnsmasq/dnsmasq.conf.template /etc/dnsmasq.conf.template
COPY dnsmasq/entrypoint.sh /entrypoint.sh
COPY tools/fetch-all.sh /tools/fetch-all.sh
RUN chmod +x /entrypoint.sh /tools/fetch-all.sh

EXPOSE 67/udp 69/udp

ENTRYPOINT ["/entrypoint.sh"]
