# vim

[![build](https://github.com/sasaplus1/vim/workflows/build/badge.svg)](https://github.com/sasaplus1/vim/actions?query=workflow%3Abuild)
[![test](https://github.com/sasaplus1/vim/workflows/test/badge.svg)](https://github.com/sasaplus1/vim/actions?query=workflow%3Atest)
[![Build Status](https://travis-ci.com/sasaplus1/vim.svg?branch=master)](https://travis-ci.com/sasaplus1/vim)
[![renovate](https://badges.renovateapi.com/github/sasaplus1/vim)](https://renovatebot.com)

my KaoriYa Vim

## Install

see [latest release](https://github.com/sasaplus1/vim/releases/latest).

## Setup

add the below to `~/.bashrc`:

```sh
alias vim='/path/to/vim/bin/pvim'
```

and execute vim:

```console
$ vim
```

## Run Docker container

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
