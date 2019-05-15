FROM alpine:3.9

ARG datadir=/usr/local/share
ARG prefix=/opt/vim

RUN apk --update add --no-cache \
  bash libc6-compat libc-dev \
  autoconf git make \
  gcc ncurses-libs ncurses-dev \
  gettext gettext-dev \
  lua5.1 lua5.1-dev luajit luajit-dev \
  python2 python2-dev \
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
  make install

RUN make -C ./vim-kaoriya/build/xubuntu VIM_DIR="${prefix}/share/vim" install

RUN git clone --depth 1 https://github.com/vim-jp/vimdoc-ja.git "${prefix}/share/vim/plugins/vimdoc-ja" && \
  rm -rf "${prefix}/share/vim/plugins/vimdoc-ja/.git" "${prefix}/share/vim/plugins/vimdoc-ja/.gitignore"

COPY ./pvim "${prefix}/bin/pvim"

RUN make create-symlinks && \
  mv pex pview pvimdiff rpview rpvim "${prefix}/bin/"

RUN printf -- '\n\n%s\n' "PATH=${prefix}/bin:\$PATH" >> ${HOME}/.bashrc && \
  "${prefix}/bin/pvim" --version

ENV PATH ${prefix}/bin:${PATH}
