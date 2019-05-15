FROM travisci/ci-sardonyx:packer-1554885359-f909ac5

ARG datadir=/usr/local/share
ARG prefix=/opt/vim
ARG slug=sasaplus1/vim

# NOTE: requires: autoconf git make
# NOTE: requires if compile: build-essential libncurses-dev
# NOTE: requires if use +gettext: gettext
# NOTE: requires if use +lua: lua5.1 liblua5.1-dev luajit libluajit-5.1-dev
# NOTE: requires if use +python: python python-dev
# NOTE: requires if use +python3: python3 python3-dev
RUN apt update && apt install --yes \
  autoconf git make \
  build-essential libncurses-dev \
  gettext \
  lua5.1 liblua5.1-dev luajit libluajit-5.1-dev \
  python python-dev \
  python3 python3-dev

WORKDIR /home/travis/${slug}

RUN chown -R travis:travis /home/travis/${slug}

USER travis

COPY --chown=travis:travis ./Makefile ./Makefile

RUN make set-git-user clone

RUN make -C ./guilt PREFIX=/opt/guilt install

ENV PATH /opt/guilt/bin:${PATH}

RUN make apply-patch

RUN cd ./vim-kaoriya/vim && \
  ./configure --prefix="${prefix}" $(make --no-print-directory -C ../../ print-configure) && \
  make -j $(make --no-print-directory -C ../../ print-cpu-count) DATADIR=${datadir} && \
  make install

RUN sed -i.bak -r -e 's|\<root\>|travis|g' ./vim-kaoriya/build/xubuntu/Makefile && \
  make -C ./vim-kaoriya/build/xubuntu VIM_DIR="${prefix}/share/vim" install

RUN git clone --depth 1 https://github.com/vim-jp/vimdoc-ja.git "${prefix}/share/vim/plugins/vimdoc-ja" && \
  rm -rf "${prefix}/share/vim/plugins/vimdoc-ja/.git" "${prefix}/share/vim/plugins/vimdoc-ja/.gitignore"

COPY --chown=travis:travis ./pvim "${prefix}/bin/pvim"

RUN make create-symlinks && \
  mv pex pview pvimdiff rpview rpvim "${prefix}/bin/"

RUN printf -- '\n\n%s\n' "PATH=${prefix}/bin:\$PATH" >> ${HOME}/.bashrc && \
  "${prefix}/bin/pvim" --version

ENV PATH ${prefix}/bin:${PATH}
