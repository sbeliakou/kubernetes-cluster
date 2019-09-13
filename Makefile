.PHONY: ssh

ifeq (ssh, $(firstword $(MAKECMDGOALS)))
  vmbox := $(word 2, $(MAKECMDGOALS))
  $(eval $(vmbox):;@true)
endif


ifeq (set, $(firstword $(MAKECMDGOALS)))
  prm_key := $(word 2, $(MAKECMDGOALS))
  prm_val := $(word 3, $(MAKECMDGOALS))
  $(eval $(prm_key):;@true)
  $(eval $(prm_val):;@true)
endif

base = "CentOS"

help:
	@echo 'Usage:'
	@echo '  make <target> [base=CentOS|CoreOS]'
	@echo
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

validate:
	@cd vagrant/$(base) && vagrant validate

status:      ## Get Cluster Status
	@cd vagrant/$(base) && vagrant status

load:        ## Load KUBECONFIG for the Cluster
	@KUBECONFIG=$(shell pwd)/.kube/config bash

create:
	@cd vagrant/$(base) && vagrant up

up: create load    ## Up Cluster

down:  	     ## Stop Cluster
	@cd vagrant/$(base) && vagrant halt

stop: down   ## Stop Cluster (same as "down")

destroy:     ## Destroy the Cluster
	@cd vagrant/$(base) && vagrant destroy -f

provision:   ## (Re)provision the Cluster
	@cd vagrant/$(base) && vagrant provision

whoup:       ## Show Running VMs
	@cd vagrant/$(base) && vagrant status --machine-readable | awk -F, 'BEGIN{printf("VM Name             | State\n--------------------+------------\n")}$$3 == "state" {printf("%-20s| %s\n", $$2, $$4)}END{printf("--------------------+------------\n")}'

who: whoup

ssh:         ## SSH Jump Into VM
	@cd vagrant/$(base) && vagrant ssh $(shell /usr/bin/env ruby vagrant/$(base)/names.rb $(vmbox))

info:        ## Get Infrastructure Info
	@ruby -r ipaddr -e 'load "config.rb"; print("Nodes: \n"); (0..$$worker_count).each { |i| print("  ", (i == 0) ? "k8s-master" : "k8s-worker-%d" % i, "\t  ", (IPAddr.new $$cluster_ips)|(1+i), "\n")}; print("\nLoadBalancers: ", $$metallb_ips, "\n")'

set:         ## Set Confuration Parameters
	@if [ $(shell grep $(prm_key) config.rb | wc -l) -eq 1 ]; then sed -i 's/\($(prm_key).*\)=.*/\1= $(prm_val)/' config.rb; grep $(prm_key) config.rb; else grep $(prm_key) config.rb; fi

