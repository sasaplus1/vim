FROM ubuntu:latest

ARG email="sasaplus1@gmail.com"
ARG name="sasa+1"

ARG dist=/opt/vim

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

RUN cd ./vim-kaoriya && \
  tar --exclude-vcs -cvz -f /root/vim.tar.gz . && \
  tar --exclude-vcs -cvJ -f /root/vim.tar.xz .

RUN cd ./vim-kaoriya/vim && \
  ./configure --prefix="${dist}" --with-compiledby="${name} <${email}>" --with-tlib=ncurses && \
  make && \
  make install

RUN make install VIM_DIR="${dist}/share/vim" -C ./vim-kaoriya/build/xubuntu

RUN printf -- "\nPATH=${dist}/bin:\$PATH\n" >> /root/.bashrc && \
  "${dist}/bin/vim" --version
