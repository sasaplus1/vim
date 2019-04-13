FROM ubuntu:latest

ARG email="sasaplus1@gmail.com"
ARG name="sasa+1"

WORKDIR /root

RUN apt update && \
  apt install --yes autoconf build-essential git libncurses-dev

RUN git config --global user.email "${email}"
RUN git config --global user.name "${name}"

RUN git clone --depth 1 https://github.com/koron/guilt.git && \
  make install -C ./guilt

RUN git clone --depth 1 https://github.com/koron/vim-kaoriya.git && \
  cd ./vim-kaoriya && \
  git submodule update --init

RUN cd ./vim-kaoriya/vim && \
  git config --local guilt.patchesdir ../patches && \
  git checkout -b v$(cat ../VERSION | grep -E '\<VIM_VER\>' | grep -E -o '[[:digit:].]+') && \
  guilt init

RUN cd ./vim-kaoriya && \
  cp ./patches/master/* ./patches/v$(cat VERSION | grep -E '\<VIM_VER\>' | grep -E -o '[[:digit:].]+')

RUN cd ./vim-kaoriya/vim/src && \
  guilt push --all && \
  make autoconf

RUN cd ./vim-kaoriya/vim && \
  ./configure --with-compiledby="${name} <${email}>" --with-tlib=ncurses && \
  make && \
  make install

RUN make install -C ./vim-kaoriya/build/xubuntu && \
  vim --version
