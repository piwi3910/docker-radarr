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
ADD https://github.com/Radarr/Radarr/releases/download/${RADARR_VERSION}/Radarr.master.${RADARR_VERSION}.linux.tar.gz /tmp/sonarr.tar.gz


#
# Install sonarr and requied dependencies
#
RUN adduser -u 666 -D -h /radarr -s /bin/bash rdarr radarr && \
    chmod 755 /radarr.sh && \
    tar xzf /tmp/radarr.tar.gz -C /tmp && \
    mv /tmp/Radarr/* /radarr/ && \
    apk update && \
	apk add --no-cache libmediainfo ca-certificates && \
    apk add mono --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
	update-ca-certificates && \
    chown -R radarr: radarr && \
    rm -rf /tmp/Rad* /tmp/rad* && \
    mkdir -p /downloads && \
    mkdir -p /media


#
# Define container settings.
#
VOLUME ["/datadir", "/downloads"]

EXPOSE 8080

#
# Start radarr.
#

WORKDIR /radarr

CMD ["/radarr.sh"]
