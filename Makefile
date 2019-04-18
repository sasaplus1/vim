.DEFAULT_GOAL := all

SHELL := /bin/bash

email := sasaplus1@gmail.com
name  := sasa+1

configure := $(strip \
  --with-compiledby="$(name) <$(email)>" \
  --with-tlib=ncurses \
)

git_user_email := $(email)
git_user_name  := $(name)

source_archive := kaoriya-patched-vim-src

dockerfile := sasaplus1/vim

makefile := $(abspath $(lastword $(MAKEFILE_LIST)))

-include ./vim-kaoriya/VERSION

# NOTE: VIM_VER from ./vim-kaoriya/VERSION
tag := v$(VIM_VER)

.PHONY: all
all: ## output targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(makefile) | awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

.PHONY: build
build: ## build Docker image
	docker build -t $(dockerfile) .

.PHONY: clean
clean: makefile_dir := $(dir $(makefile))
clean: ## remove some files and directories
	$(RM) -rf $(makefile_dir)/guilt $(makefile_dir)/vim-kaoriya

.PHONY: clone
clone: clone-guilt clone-vim-kaoriya ## clone-guilt and clone-vim-kaoriya

.PHONY: clone-guilt
clone-guilt: ## clone koron/guilt
	-git clone --depth 1 https://github.com/koron/guilt.git

.PHONY: clone-vim-kaoriya
clone-vim-kaoriya: ## clone koron/vim-kaoriya
	-git clone --depth 1 https://github.com/koron/vim-kaoriya.git
	-cd ./vim-kaoriya && git submodule update --init

.PHONY: copy-source-archive
copy-source-archive: container := $$(docker ps --latest --quiet)
copy-source-archive: ## copy KaoriYa patched source archive from Docker container
	docker run --rm --detach sasaplus1/vim tail -f /dev/null
	-docker cp $(container):/root/$(source_archive).tar.gz .
	-docker cp $(container):/root/$(source_archive).tar.xz .
	docker stop $(container)

.PHONY: create-source-archive
create-source-archive: ## create source archive
	@$(MAKE) clone-vim-kaoriya >/dev/null 2>&1
	# NOTE: GNU tar has --exclude-vcs option, but BSD not
	tar --exclude='.git*' -cvz -f $(source_archive).tar.gz ./vim-kaoriya
	tar --exclude='.git*' -cvJ -f $(source_archive).tar.xz ./vim-kaoriya

.PHONY: print-configure
print-configure: ## print configure options
	@printf -- '%s' '$(configure)'

.PHONY: print-git-tag
# NOTE: print-git-tag requires clone-vim-kaoriya
# requires --no-print-directory option if use -C option
# print-git-tag: clone-vim-kaoriya
print-git-tag: ## print target Vim version for KaoriYa patch
	@$(MAKE) clone-vim-kaoriya >/dev/null 2>&1
	@printf -- '%s' '$(tag)'

.PHONY: run
run: ## run Docker container and attach TTY
	docker run --rm -it $(dockerfile) /bin/bash

.PHONY: set-git-user
set-git-user: ## set user.email and user.name for Git
	git config --global user.email '$(git_user_email)'
	git config --global user.name '$(git_user_name)'
