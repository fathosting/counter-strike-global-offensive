FROM fathosting/steamcmd:latest
MAINTAINER FAT <contact@fat.sh>

RUN ./steamcmd.sh \
      +login anonymous \
      +force_install_dir /home/steam/csgo \
      +app_update 740 validate \
      +quit

COPY lsyncd.conf.lua /etc/lsyncd/
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME ["/home/steam/backup"]
EXPOSE 27015

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["./srcds_run -game csgo -console -usercon +sv_lan 0"]
