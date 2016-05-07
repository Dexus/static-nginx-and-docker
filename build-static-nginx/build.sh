#!/bin/bash

VER=1.9.15
TAR_FILE=nginx-$VER.tar.gz
SRC_DIR=nginx-$VER

PCRE_VER=8.38
PCRE_DIR=pcre-${PCRE_VER}
PCRE_ZIP=pcre-${PCRE_VER}.zip

SSL_VER=1.0.2h
SSL_TAR=openssl-${SSL_VER}.tar.gz
SSL_DIR=openssl-${SSL_VER}

ZLIB_VER=1.2.8
ZLIB_TAR=zlib-${ZLIB_VER}.tar.gz
ZLIB_DIR=zlib-${ZLIB_VER}


### zlib
install -d zlib
cd zlib
if [ ! -e $ZLIB_TAR ]; then
	curl http://zlib.net/$ZLIB_TAR > $ZLIB_TAR
fi

if [ ! -d $ZLIB_DIR ]; then
	tar xzvf $ZLIB_TAR
fi
cd -


### pcre
install -d pcre
cd pcre
if [ ! -e $PCRE_ZIP ]; then
	curl ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE_ZIP} > $PCRE_ZIP
fi

if [ ! -d ${PCRE_DIR} ]; then
	unzip $PCRE_ZIP
fi
cd -


### openssl
install -d openssl
cd openssl
if [ ! -e $SSL_TAR ]; then
	curl ftp://ftp.openssl.org/source/$SSL_TAR > $SSL_TAR || (echo "Failed to fetch openssl" && exit $?)
fi

if [ ! -d $SSL_DIR ]; then
	tar zxvf $SSL_TAR
fi
cd -


### nginx
if [ ! -e $TAR_FILE ]; then
	curl http://nginx.org/download/$TAR_FILE > $TAR_FILE
fi

if [ ! -d $SRC_DIR ]; then
	tar xzvf $TAR_FILE
fi

cd $SRC_DIR
./configure --with-cc-opt="-static -static-libgcc" --with-ld-opt="-static" \
	--user=nobody --group=nogroup --build="b1s-extra" --with-threads \
	--with-file-aio \
	--with-http_realip_module --with-ipv6 --with-http_gunzip_module \
	--with-poll_module --with-select_module --with-http_gzip_static_module \
	--with-http_ssl_module \
	--with-http_auth_request_module --with-mail --with-mail_ssl_module \
	--with-stream --with-google_perftools_module --with-libatomic \	
	--with-pcre=../pcre/${PCRE_DIR} \
	--with-openssl=../openssl/$SSL_DIR --with-zlib=../zlib/${ZLIB_DIR}
make -j1
cd -

cp $SRC_DIR/objs/nginx ./
