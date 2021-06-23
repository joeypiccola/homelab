FROM mcr.microsoft.com/powershell:alpine-3.12

RUN apk update && apk add dcron ca-certificates && rm -rf /var/cache/apk/*

RUN mkdir -p /var/log/cron
RUN mkdir -m 0644 -p /var/spool/cron/crontabs
RUN touch /var/log/cron/cron.log
RUN mkdir -m 0644 -p /etc/cron.d

COPY /scripts/docker-cmd.sh /
COPY /scripts/docker-entry.sh /
RUN chmod 0700 /docker-entry.sh
RUN chmod 0700 /docker-cmd.sh

ENTRYPOINT ["/docker-entry.sh"]
CMD ["/docker-cmd.sh"]
