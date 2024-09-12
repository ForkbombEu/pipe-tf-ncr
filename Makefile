# Makefile for running a series of commands for tofu initialization and deployment

.PHONY: all

all:
	cd tf-ncr && \
	ssh-keygen -t ed25519 -C "noOwnerName" -f ./testRsaKey && \
	chmod 700 ./testRsaKey &&\
	cd openTofuCode && \
	tofu init && \
	tofu apply -auto-approve > tofuApplyStdout.tmp && \
	cat tofuApplyStdout.tmp | ./../../deployAndExecute.sh

destroy:
	cd tf-ncr && \
	cd openTofuCode && \
	tofu destroy -auto-approve