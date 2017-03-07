#!/bin/bash
set -e

home_dir=/home/steam/csgo
backup_vol=/home/steam/backup

exec_extra_params=${EXEC_EXTRA_PARAMS:-"+map de_dust2"}

function install_update_game {
    gosu steam bash -c "./steamcmd.sh +login anonymous +force_install_dir /home/steam/$APP_NAME +app_update $APP_ID validate +quit"
}

# install game data on first launch
if [ ! -z $FIRST_LAUNCH ]; then
    echo ">> Installing game data..."
    install_update_game
fi

# docker volumes are mounted as root
# chown them to the correct user after mount
chown steam:steam ${backup_vol}

# restore data from backup if any
if [ "$(ls -A ${backup_vol})" ]; then
    echo ">> Restoring backup data..."
    # sync backup volume -> container
    rsync -aP ${backup_vol}/ ${home_dir}/cstrike
fi

# update game data if asked to
if [ ! -z $UPDATE_GAME ]; then
    echo ">> Updating game data..."
    install_update_game
fi

# launch lsyncd to sync container -> backup volume
lsyncd /etc/lsyncd/lsyncd.conf.lua

cd ${home_dir}

echo ">> Starting dedicated server..."
exec gosu steam "$@ -console -usercon +sv_lan 0 ${exec_extra_params}"
