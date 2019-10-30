# vim

[![test](https://github.com/sasaplus1/vim/workflows/test/badge.svg)](https://github.com/sasaplus1/vim)
[![build](https://github.com/sasaplus1/vim/workflows/build/badge.svg)](https://github.com/sasaplus1/vim)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/sasaplus1/vim.svg)](https://hub.docker.com/r/sasaplus1/vim)
[![renovate](https://badges.renovateapi.com/github/sasaplus1/vim)](https://renovatebot.com)

my KaoriYa Vim

## Install

### macOS

```console
$ curl -LO https://github.com/sasaplus1/vim/releases/latest/download/vim-osx.tar.xz
$ tar xvf vim-osx.tar.xz
```

or

```console
$ curl -L https://github.com/sasaplus1/vim/releases/latest/download/vim-osx.tar.xz | tar xf -
```

### Linux

```console
$ curl -LO https://github.com/sasaplus1/vim/releases/latest/download/vim-linux.tar.xz
$ tar xvf vim-linux.tar.xz
```

or

```console
$ curl -L https://github.com/sasaplus1/vim/releases/latest/download/vim-linux.tar.xz | tar xf -
```

## Setup

add the below to `~/.bashrc`:

```sh
alias vim='/path/to/vim/bin/pvim'
```

## Build Docker container

### Ubuntu

```console
$ docker-compose run --rm ubuntu
```

### Alpine Linux

```console
$ docker-compose run --rm alpine
```

## Related

- https://github.com/vim/vim
- https://github.com/koron/vim-kaoriya
- https://github.com/splhack/macvim-kaoriya

## License

The MIT license.
