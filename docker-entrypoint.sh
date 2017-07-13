#!/bin/bash
set -e

game_dir=/home/steam/$APP_NAME
game_cfg_dir=${game_dir}/cfg
game_backup_dir=/media/game_data
game_cfg_backup_dir=/media/user_data


echo ">> Syncing game data..."
rsync -aP ${game_backup_dir}/ ${game_dir}

# restore data from backup if any
if [ "$(ls -A ${game_cfg_backup_dir})" ]; then
    echo ">> Restoring backup data..."
    # sync backup volume -> container
    rsync -aP ${game_cfg_backup_dir}/ ${game_cfg_dir}

    # fix files permissions after rsync
    chown -R steam:steam ${game_dir}
fi

# update game data if asked to
if [ ! -z $UPDATE_GAME ]; then
    echo ">> Updating game data..."
    gosu steam bash -c "./steamcmd.sh +login anonymous +force_install_dir $game_dir +app_update $APP_ID validate +quit"
fi

# launch lsyncd to sync container -> backup volume
lsyncd /etc/lsyncd/lsyncd.conf.lua

cd ${game_dir}

echo ">> Starting dedicated server..."
exec gosu steam "$@ -console -usercon +sv_lan 0 ${EXEC_EXTRA_PARAMS}"
