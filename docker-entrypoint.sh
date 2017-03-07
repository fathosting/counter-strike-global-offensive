#!/bin/bash

home_dir=/home/steam/csgo
backup_vol=/home/steam/backup

exec_extra_params=${EXEC_EXTRA_PARAMS:-"+map de_dust2"}

# install or update game data
if [ ! -z $FIRST_LAUNCH ] || [ ! -z $UPDATE_GAME ]; then
    ./steamcmd.sh \
        +login anonymous \
        +force_install_dir /home/steam/$APP_NAME \
        +app_update $APP_ID validate \
        +quit
fi

# docker volumes are mounted as root
# chown them to the correct user after mount
chown steam:steam ${backup_vol}

if [ "$(ls -A ${backup_vol})" ]; then
    echo ">> Restoring backup data from volume..."
    # sync backup volume -> container
    rsync -aP ${backup_vol}/ ${home_dir}/cstrike
fi

# launch lsyncd to sync container -> backup volume
lsyncd /etc/lsyncd/lsyncd.conf.lua

cd ${home_dir}

echo ">> Starting CS:GO dedicated server..."
exec gosu steam "$@ -console -usercon +sv_lan 0 ${exec_extra_params}"
