#
# Ntfy Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

LABEL org.opencontainers.image.authors="hihouhou < hihouhou@hihouhou.com >"

ENV NTFY_VERSION v2.11.0

# Update & install packages for ntfy
RUN apt-get update && \
    apt-get install -y unzip wget

RUN wget https://github.com/binwiederhier/ntfy/releases/download/${NTFY_VERSION}/ntfy_$(echo "$NTFY_VERSION" | cut -c2-)_linux_amd64.tar.gz && \
    tar xf ntfy_$(echo $NTFY_VERSION | cut -c2-)_linux_amd64.tar.gz && \
    cp -a ntfy_$(echo $NTFY_VERSION | cut -c2-)_linux_amd64/ntfy /usr/bin/ntfy && \
    mkdir /etc/ntfy && \
    mkdir /var/cache/ntfy

#Configure the server
COPY server.yml /etc/ntfy/server.yml

RUN groupadd -r ntfy && useradd -u 1000 -ms /bin/bash -g ntfy ntfy && \
    chown -R ntfy /var/cache/ntfy

USER ntfy

EXPOSE 8080

CMD ["ntfy", "serve"]
