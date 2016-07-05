FROM    alpine:3.3
MAINTAINER  Willpower-chen  <yibo090@126.com>

#安装bash（forego执行需要bash）lighttpd rsync
RUN apk update && apk add bash lighttpd rsync

#下载forego工具，加执行权限
ADD http://archive.hivelinks.com/forego/forego /usr/local/bin
RUN chmod +x /usr/local/bin/forego
#rsync.sh同步rsync://rsync.alpinelinux.org/alpine/源文件，脚本文件放至crontab任务的每小时执行一次目录下
ADD rsync.sh /etc/periodic/hourly/package-rsync
#同步时需要排除的文件列表，包含在次文件下
ADD exclude.txt /etc/rsync/exclude.txt 
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN     mkdir /app
#此文件提供给forego执行
COPY    Procfile /app 
WORKDIR /app
#此映射目录是lighttpd的根目录，详细查看lighttpd.conf的var.basedir
VOLUME  /data 
EXPOSE  80
EXPOSE  5000

CMD     ["forego", "start"]
