# Makefile for running a series of commands for tofu initialization and deployment

.PHONY: all

all:
	cd tf-ncr && \
	cd openTofuCode && \
	tofu init && \
	tofu apply -auto-approve > tofuApplyStdout.tmp && \
	cat tofuApplyStdout.tmp | ./../../deployAndExecute.sh
