FROM piwi3910/base:latest

LABEL maintainer="Pascal Watteel"


#
# Add radarr init script.
#
COPY radarr.sh /radarr.sh

#
# Fix locales to handle UTF-8 characters.
#
ENV LANG C.UTF-8

#
# Specify versions of software to install.
#
ARG RADARR_VERSION=DEFAULT

#
# Add (download) radarr
#
ADD https://github.com/Radarr/Radarr/releases/download/v${RADARR_VERSION}/Radarr.master.${RADARR_VERSION}.linux.tar.gz /tmp/radarr.tar.gz


#
# Install sonarr and requied dependencies
#
RUN adduser -u 666 -D -h /radarr -s /bin/bash radarr radarr && \
    chmod 755 /radarr.sh && \
    tar xzf /tmp/radarr.tar.gz -C /tmp && \
    mv /tmp/Radarr/* /radarr/ && \
    apk update && \
	apk add --no-cache wget ca-certificates shadow icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib && \
    apk add libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ && \
    cd /tmp && wget https://dot.net/v1/dotnet-install.sh && chmod +x dotnet-install.sh && \
    ./dotnet-install.sh -c Current --runtime aspnetcore && \
    update-ca-certificates && \
    chown -R radarr: radarr && \
    rm -rf /tmp/Rad* /tmp/rad* && \
    mkdir -p /downloads && \
    mkdir -p /media


#
# Define container settings.
#
VOLUME ["/datadir", "/downloads"]

EXPOSE 7878

#
# Start radarr.
#

WORKDIR /radarr

CMD ["/radarr.sh"]
