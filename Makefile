.DEFAULT_GOAL := all
SHELL := /bin/bash

configure := $(strip \
  --enable-fail-if-missing \
  --disable-smack \
  --disable-selinux \
  --disable-xsmp \
  --disable-xsmp-interact \
  --enable-luainterp=dynamic \
  --enable-pythoninterp=dynamic \
  --enable-python3interp=dynamic \
  --enable-cscope \
  --disable-netbeans \
  --enable-terminal \
  --enable-multibyte \
  --disable-rightleft \
  --disable-arabic \
  --enable-gui=no \
  --with-compiledby="sasa+1" \
  --with-features=huge \
  --with-luajit \
  --without-x \
  --with-tlib=ncurses \
)

slug := sasaplus1/vim

makefile     := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(dir $(makefile))

.PHONY: all
all: ## output targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(makefile) | awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

.PHONY: apply-patch
apply-patch: patch_dir := $(makefile_dir)/vim-kaoriya
apply-patch: vim_dir := $(makefile_dir)/vim-kaoriya/vim
apply-patch: src_dir := $(makefile_dir)/vim-kaoriya/vim/src
apply-patch: ## apply KaoriYa patch
	cd $(vim_dir) && git checkout -b $$($(MAKE) --no-print-directory -C $(makefile_dir) print-git-tag) >/dev/null
	cd $(vim_dir) && git config --local guilt.patchesdir ../patches
	cd $(vim_dir) && guilt init
	cd $(patch_dir) && cp ./patches/master/* ./patches/$$($(MAKE) --no-print-directory -C $(makefile_dir) print-git-tag)
	cd $(src_dir) && guilt push --all
	make -C $(src_dir) autoconf

.PHONY: build
build: ## build Travis-CI Docker image
	DOCKER_BUILDKIT=1 docker build -t $(slug) .

.PHONY: build-alpine
build-alpine: dockerfile := ./dockerfiles/alpine/Dockerfile
build-alpine: ## build Alpine Docker image
	DOCKER_BUILDKIT=1 docker build -t $(slug)-alpine -f $(dockerfile) .

.PHONY: build-ubuntu
build-ubuntu: dockerfile := ./dockerfiles/ubuntu/Dockerfile
build-ubuntu: ## build Ubuntu Docker image
	DOCKER_BUILDKIT=1 docker build -t $(slug)-ubuntu -f $(dockerfile) .

.PHONY: clean
clean: ## remove some files and directories
	$(RM) -rf $(makefile_dir)/guilt $(makefile_dir)/vim-kaoriya

.PHONY: clone
clone: clone-guilt clone-vim-kaoriya ## clone-guilt and clone-vim-kaoriya

.PHONY: clone-guilt
clone-guilt: ## clone koron/guilt
	-git clone --depth 1 https://github.com/koron/guilt.git

.PHONY: clone-vim-kaoriya
clone-vim-kaoriya: submodules := ./patches ./vim
clone-vim-kaoriya: ## clone koron/vim-kaoriya
	-git clone --depth 1 https://github.com/koron/vim-kaoriya.git
	-cd ./vim-kaoriya && git submodule update --init -- $(submodules)

.PHONY: create-symlinks
create-symlinks: ## create symbolic links to pvim
	ln -s pvim pex
	ln -s pvim pview
	ln -s pvim pvimdiff
	ln -s pvim rpview
	ln -s pvim rpvim

.PHONY: print-configure
print-configure: ## print configure options
	@printf -- '%s' '$(configure)'

define print_cpu_count
  if [ -f "/proc/cpuinfo" ]
  then
    grep -c processor < /proc/cpuinfo
  elif type sysctl >/dev/null 2>&1
  then
    sysctl -n hw.ncpu
  else
    printf -- '%d\n' 1
  fi
endef
export print_cpu_count

.PHONY: print-cpu-count
print-cpu-count: ## print CPU count
	@$(SHELL) -c "$${print_cpu_count}"

define print_git_tag
.DEFAULT_GOAL := all

SHELL := /bin/bash

.PHONY: all
all:
	@printf -- '%s' '$$(VIM_VER)'
endef
export print_git_tag

.PHONY: print-git-tag
print-git-tag: ## print target Vim version for KaoriYa patch
	@$(MAKE) clone-vim-kaoriya >/dev/null 2>&1
	@printf -- 'v%s' "$${print_git_tag}" | $(MAKE) -f ./vim-kaoriya/VERSION -f - all

.PHONY: run
run: options := --interactive --rm --tty
run: ## run Travis-CI Docker container and attach TTY
	docker run $(options) $(slug) /bin/bash

.PHONY: run-alpine
run-alpine: options := --interactive --rm --tty
run-alpine: ## run Alpine Docker container and attach TTY
	docker run $(options) $(slug)-alpine /bin/bash

.PHONY: run-ubuntu
run-ubuntu: options := --interactive --rm --tty
run-ubuntu: ## run Ubuntu Docker container and attach TTY
	docker run $(options) $(slug)-ubuntu /bin/bash

.PHONY: set-git-user
set-git-user: ## set user.email and user.name for Git
	git config --global user.email 'johndoe@example.com'
	git config --global user.name 'John Doe'
