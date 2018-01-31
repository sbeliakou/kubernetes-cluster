.PHONY: version

help:
	@echo 'Usage:'
	@echo '  make <target>'
	@echo 
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

status:      ## Get Cluster Status
	@vagrant status

up:          ## Up Cluster
	@vagrant up

down:  	     ## Stop Cluster
	@vagrant halt

stop: down

destroy:     ## Destroy the Cluster
	@vagrant destroy -f

provision:   ## (Re)provision the Cluster
	@vagrant provision
