FROM scratch

MAINTAINER Josef Fröhle <froehle@b1-systems.de>

ADD ./src/* /

EXPOSE 80 443

ENTRYPOINT ["/nginx"]

CMD ["-c", "/conf/nginx.conf", "-p", "/"]