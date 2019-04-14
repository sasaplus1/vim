.DEFAULT_GOAL := all

SHELL := /bin/bash

MAKEFILE_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

.PHONY: all
all: ## output targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

.PHONY: clean
clean: ## remove some files and directories
	$(RM) -rf $(MAKEFILE_DIR)/guilt $(MAKEFILE_DIR)/vim-kaoriya

.PHONY: clone
clone: clone-guilt clone-vim-kaoriya ## clone-guilt and clone-vim-kaoriya

.PHONY: clone-guilt
clone-guilt: ## clone koron/guilt
	git clone --depth 1 https://github.com/koron/guilt.git

.PHONY: clone-vim-kaoriya
clone-vim-kaoriya: ## clone koron/vim-kaoriya
	git clone --depth 1 https://github.com/koron/vim-kaoriya.git
	cd ./vim-kaoriya && git submodule update --init
