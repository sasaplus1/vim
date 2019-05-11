FROM ubuntu:xenial

ARG datadir=/usr/local/share
ARG prefix=/opt/vim

RUN apt update && apt install --yes \
  autoconf git make \
  build-essential libncurses-dev \
  gettext \
  lua5.1 liblua5.1-dev luajit libluajit-5.1-dev \
  python python-dev \
  python3 python3-dev

WORKDIR /root

COPY ./Makefile ./Makefile

RUN make set-git-user clone

RUN make -C ./guilt PREFIX=/opt/guilt install

ENV PATH /opt/guilt/bin:${PATH}

RUN make apply-patch

RUN cd ./vim-kaoriya/vim && \
  ./configure --prefix="${prefix}" $(make --no-print-directory -C ../../ print-configure) && \
  make -j $(make --no-print-directory -C ../../ print-cpu-count) DATADIR=${datadir} && \
  make -j $(make --no-print-directory -C ../../ print-cpu-count) install

RUN make -C ./vim-kaoriya/build/xubuntu VIM_DIR="${prefix}/share/vim" install

RUN printf -- '\n\n%s\n' "PATH=${prefix}/bin:\$PATH" >> ${HOME}/.bashrc && \
  "${prefix}/bin/vim" --version

ENV PATH ${prefix}/bin:${PATH}
