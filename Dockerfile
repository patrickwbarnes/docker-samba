FROM debian:stable

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -y \
     samba \
     smbclient \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -c 'Samba User' -G users -d /tmp -M -s /bin/false smbuser

WORKDIR /etc/samba

COPY smb.conf smb.conf

VOLUME /etc/samba

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

HEALTHCHECK --interval=60s --timeout=15s \
 CMD smbclient -L '\\localhost' -U '%' -m SMB3

CMD ["/usr/local/bin/docker-entrypoint.sh"]

