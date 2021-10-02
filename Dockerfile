From itzg/minecraft-server

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends supervisor zstd jq cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./src/supervisor /etc/supervisor
COPY ./src/dockerstartup /dockerstartup
COPY ./src/cron/cron_mc_backup /etc/cron.d/cron_mc_backup

RUN chmod -R u+x /dockerstartup

RUN /dockerstartup/minecraft_mods_restore.sh

ENV DEBIAN_FRONTEND=""

ENTRYPOINT [ "/usr/bin/supervisord" ]
