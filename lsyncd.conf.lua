settings {
    inotifyMode = "CloseWrite or Modify"
}

sync {
    default.rsync,
    source = "/home/steam/csgo/cstrike",
    target = "/media/user_data",
    rsync = {
        archive  = true
    }
}
