settings {
    inotifyMode = "CloseWrite or Modify"
}

sync {
    default.rsync,
    source = "/home/steam/csgo/cstrike",
    target = "/home/steam/backup",
    rsync = {
        archive  = true
    }
}
