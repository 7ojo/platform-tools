FROM debian:stretch
MAINTAINER Jarkko Haapalainen <jarkko@viidakko.fi>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update &&\
 apt-get install -y build-essential debhelper devscripts git libncurses5-dev libssl-dev zlib1g-dev libcurl4-openssl-dev libexpat1-dev patchelf
RUN mkdir /tools

# Install VIM
RUN git clone https://github.com/vim/vim.git /src/vim
RUN cd /src/vim ;\
 ./configure --prefix=/tools ;\
 make ;\
 make install

# Install Git
RUN git clone git://git.kernel.org/pub/scm/git/git.git /src/git
RUN apt-get install
RUN cd /src/git ;\
 make configure ;\
 ./configure --prefix=/tools ;\
 make ;\
 make install

# Environment
RUN mkdir -p /tools/lib64 /tools/lib /tools/usr/lib ;\
 cp -a /lib64/* /tools/lib64/ ;\
 cp -a /lib/* /tools/lib/ ;\
 cp -a /usr/lib/* /tools/usr/lib/

# Patch binaries to new shared library path
#RUN patchelf patchelf --add-needed libnghttp2.so.14 /tools/libexec/git-core/git-remote-https

#RUN for i in /tools/bin/* /tools/libexec/git-core/*; do\
# patchelf --set-interpreter /tools/lib64/ld-linux-x86-64.so.2 $i;\
# patchelf --set-rpath /tools/lib:/tools/lib64:/tools/lib/x86_64-linux-gnu:/tools/usr/lib:/tools/usr/lib/x86_64-linux-gnu $i;\
# patchelf --shrink-rpath $i;\
# echo "$i";\
# done

CMD bash
