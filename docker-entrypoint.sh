#!/bin/bash
set -e

game_dir=/home/steam/$APP_NAME
game_data=${game_dir}/cstrike
game_data_backup=/media/user_data

function install_or_update_game {
    gosu steam bash -c "./steamcmd.sh +login anonymous +force_install_dir $game_dir +app_update $APP_ID validate +quit"
}

# restore data from backup if any
if [ "$(ls -A ${game_data_backup})" ]; then
    echo ">> Restoring backup data..."
    # sync backup volume -> container
    rsync -aP ${game_data_backup}/ ${game_data}

    # fix files permissions after rsync
    chown -R steam:steam ${game_data}
fi

# install game data if dest directory doesn't exists
if [ ! -d ${game_data} ]; then
    echo ">> Installing game data..."
    install_or_update_game
fi

# update game data if asked to
if [ ! -z $UPDATE_GAME ]; then
    echo ">> Updating game data..."
    install_or_update_game
fi

# launch lsyncd to sync container -> backup volume
lsyncd /etc/lsyncd/lsyncd.conf.lua

cd ${game_dir}

echo ">> Starting dedicated server..."
exec gosu steam "$@ -console -usercon +sv_lan 0 ${EXEC_EXTRA_PARAMS}"
