SHELL := /bin/zsh

# Automatically load .env if present
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: help init fmt validate plan apply

help: ## Show available Make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

init: ## Initialize OpenTofu providers
	GITHUB_TOKEN=$$(gh auth token) tofu init

fmt: ## Format all .tf files
	tofu fmt -recursive

validate: ## Validate HCL syntax and configuration
	tofu validate

plan: ## Preview declarative changes against GitHub API
	GITHUB_TOKEN=$$(gh auth token) tofu plan

apply: ## Apply declarative changes and update encrypted terraform.tfstate
	GITHUB_TOKEN=$$(gh auth token) tofu apply

