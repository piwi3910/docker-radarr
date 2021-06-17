#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="radarr"

echo "radarr settings"
echo "================"
echo
echo "  User:       ${USER}"
echo "  UID:        ${RADARR_UID:=666}"
echo "  GID:        ${RADARR_GID:=666}"
echo "  GID_LIST:   ${RADARR_GID_LIST:=}"
echo
echo "  Config:     ${CONFIG:=/datadir}"
echo "  Downloads:  ${DOWNLOADS:=/downloads} "
echo "  Media:      ${MEDIA:=/media}"

#
# Change UID / GID of RADARR user.
#

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${RADARR_UID} ]] || usermod  -o -u ${RADARR_UID} ${USER}
[[ $(id -g ${USER}) == ${RADARR_GID} ]] || groupmod -o -g ${RADARR_GID} ${USER}
echo "[DONE]"

#
# Create groups from RADARR_GID_LIST.
#
if [[ -n ${RADARR_GID_LIST} ]]; then
    for gid in $(echo ${RADARR_GID_LIST} | sed "s/,/ /g")
    do
        printf "Create group $gid and add user ${USER}..."
        groupadd -g $gid "grp_$gid"
        usermod -aG grp_$gid ${USER}
        echo "[DONE]"
    done
fi

#
# Set directory permissions.
#

printf "Set permissions... "
chown -R ${USER}: /radarr
function check_permissions {
  [ "$(stat -c '%u %g' $1)" == "${RADARR_UID} ${RADARR_GID}" ] || chown ${USER}: $1
}
check_permissions ${CONFIG}
check_permissions ${DOWNLOADS}
check_permissions ${MEDIA}
echo "[DONE]"


#
# Finally, start Radarr.
#

echo "Starting Radarr..."
exec su -pc "mono Radarr.exe -data=${CONFIG}" ${USER}
