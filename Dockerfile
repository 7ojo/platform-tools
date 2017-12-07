FROM alpine:3.7
MAINTAINER Jarkko Haapalainen <jarkko@viidakko.fi>
RUN apk update
RUN apk add vim git patchelf rsync
RUN mkdir /tools;\
 rsync -a -H --exclude=tools --exclude=sys --exclude=proc / /tools/

# Patch binaries to new shared library path
#RUN patchelf patchelf --add-needed libnghttp2.so.14 /tools/libexec/git-core/git-remote-https

RUN for i in /tools/usr/bin/vim; do\
 echo "File: $i";\
 patchelf --set-interpreter /tools/lib/ld-musl-x86_64.so.1 $i;\
 patchelf --set-rpath /tools/lib:/tools/usr/lib $i;\
 patchelf --shrink-rpath $i;\
 done ;\
 exit 0

CMD bash
