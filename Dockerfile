FROM alpine:3.9

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.docker.cmd="docker run --detach --publish 3690:3690 --volume $PWD:/var/opt/svn jlira/svn-server" \
	org.label-schema.description="SVN Server" \
	org.label-schema.name="svn-server" \
	org.label-schema.schema-version="1.0" \
	org.label-schema.url="https://subversion.apache.org" \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/jlira-estrasol/docker-svn-server" \
	org.label-schema.vendor="jlira-estrasol" \
	org.label-schema.version="1.2.2"

ADD cron_svn_backup.txt /cron_svn_backup.txt
ADD dump_svn_repo.sh /dump_svn_repo.sh

CMD [ "/usr/bin/svnserve", "--daemon", "--log-file=/var/log/svnserve.log", "--foreground", "--root", "/var/opt/svn" ]
EXPOSE 3690
HEALTHCHECK CMD netstat -ln | grep 3690 || exit 1
VOLUME [ "/var/opt/svn" ]
WORKDIR /var/opt/svn

RUN apk add --no-cache subversion==1.11.1-r0

RUN chmod 755 /dump_svn_repo.sh
RUN /usr/bin/crontab /crontab_.txt
RUN /usr/sbin/crond -f
CMD ["/usr/sbin/crond", "-f"]
