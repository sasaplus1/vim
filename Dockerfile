FROM ubuntu:latest

ARG dist=/opt/vim

WORKDIR /root

RUN apt update && \
  apt install --yes autoconf build-essential git libncurses-dev

COPY ./Makefile /root/Makefile

RUN make set-git-user clone
RUN make -C ./guilt install

RUN cd ./vim-kaoriya/vim && \
  git config --local guilt.patchesdir ../patches && \
  git checkout -b $(make --no-print-directory -C /root print-git-tag) && \
  guilt init

RUN cd ./vim-kaoriya && \
  cp ./patches/master/* ./patches/$(make --no-print-directory -C /root print-git-tag)

RUN cd ./vim-kaoriya/vim/src && \
  guilt push --all && \
  make autoconf

RUN make create-source-archive

RUN cd ./vim-kaoriya/vim && \
  ./configure --prefix="${dist}" $(make --no-print-directory -C /root print-configure) && \
  make && \
  make install

RUN make -C ./vim-kaoriya/build/xubuntu install VIM_DIR="${dist}/share/vim"

RUN printf -- "\nPATH=${dist}/bin:\$PATH\n" >> /root/.bashrc && \
  "${dist}/bin/vim" --version
