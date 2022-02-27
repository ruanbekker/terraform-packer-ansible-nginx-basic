# Thanks: https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# TASKS
packer: ## builds packer image
	cd packer 
	packer validate packer.json
	packer build packer.json
	cd ..

venv: ## sets up virtualenv
	test -d .venv || python3 -m virtualenv -p /usr/local/bin/python3 .venv 
	. .venv/bin/activate; pip install -r dependencies/requirements.pip

tfplan: ## terraform validate
	terraform -chdir=./terraform init ; \
	terraform -chdir=./terraform plan 

tfapply: ## terraform apply
	terraform -chdir=./terraform apply

checkov: ## run checkov
	checkov -d ./terraform --skip-check CKV2_AWS_8 ; echo