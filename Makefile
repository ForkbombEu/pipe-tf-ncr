# Makefile for running a series of commands for tofu initialization and deployment

.PHONY: all

all:
	cd tf-ncr && \
	if [ ! -f ./testED25519Key ]; then \
		ssh-keygen -t ed25519 -C "noOwnerName" -f ./testED25519Key; \
		chmod 600 ./testED25519Key; \
	else \
		echo "SSH key already exists, skipping generation."; \
	fi && \
	cd openTofuCode && \
	tofu init && \
	tofu apply -auto-approve > tofuApplyStdout.tmp && \
	chmod +x ./../../deployAndExecute.sh && \
	cat tofuApplyStdout.tmp | ./../../deployAndExecute.sh && \
	echo "End make all."


destroy:
	cd tf-ncr && \
	cd openTofuCode && \
	tofu destroy -auto-approve && \
	echo "End make destroy."

clear: destroy
	rm -f ./tf-ncr/./testED25519Key
	rm -f ./tf-ncr/./testED25519Key.pub && \
	echo "End make clear."