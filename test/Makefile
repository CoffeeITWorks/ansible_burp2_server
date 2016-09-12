.PHONY: main groups

#all: main groups
all: main 

main:
	docker stop provision_docker_host_one provision_docker_host_two provision_docker_host_three provision_docker_host_four optimus ironhide megatron starscream || true
	ansible-playbook -i inventory main.yml -v -e burp_module_test_client=true
	ansible-playbook -i inventory main.yml -v 

#groups:
#	docker stop provision_docker_host_one provision_docker_host_two provision_docker_host_three provision_docker_host_four optimus ironhide megatron starscream || true
#ansible-playbook -i inventory groups.yml
