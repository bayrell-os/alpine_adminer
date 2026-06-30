ARG ARCH=
FROM ${ARCH}php:8.4-alpine

RUN cd ~; \
	apk update; \
	apk upgrade; \
	apk add bash mc nano wget procps net-tools; \
	apk add php84 php84-session php84-pdo_mysql php84-pdo_sqlite php84-pdo_pgsql; \
	mkdir -p /tmp/sessions && chmod 777 /tmp/sessions; \
	echo 'Ok'

RUN adduser -u 1000 -s /bin/sh -D user

ADD files /
RUN cd ~; \
	chmod +x /etc/run.sh; \
	echo 'Ok'

USER user
CMD ["/etc/run.sh"]