[![Build Status](https://travis-ci.org/CoffeeITWorks/ansible_burp2_server.svg?branch=master)](https://travis-ci.org/CoffeeITWorks/ansible_burp2_server)

Getting Started
================

Install ansible http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip

Install the role on the system: 

    $ ansible-galaxy install CoffeeITWorks.burp2_server

Or clone the repo to you roles subdir (subidr of dir where you have your site.yml file), role folder name must be the same as specified in site.yml.

Redhat support is not fully tested and there is some doubts with dependencies to build burp. 
Please check vars/Redhat.yml file and help on it. Also check tasks/build-burp.yml to check compatiblity of the steps.

Role Name
=========

ansible burp2_server deploy and maintenance role.

This roles builds burp version specified on defaults/main.yml. 
Also configures it to get it working and maintained in a centralized way.

Requirements
------------


Role Variables
--------------

### Add to your host/group_vars:
 
Create host_vars or group_vars dirs. 

Inside it you can add a file with the name of the group or the host where you want to add specific options of this role.

*Options vars:* 

    burp_module_agent: true # Will add buiagent and configure it properly to use on burpui-multiagent mode. 
    burp_module_restore: true # Will configure a second burp server with same spool, useful to configure one restore_client to get restores faster on large deployments.

Check also all vars in `defaults/main.yml` you can override any default using your host/group_vars   

Role Variables: Complete list of modules:
-----------------------------------------

### Modules
##### Configure Burp UI Agent
	
	burp_module_agent: true
	
##### Configure burp restore service
	
	burp_module_restore: true
	
##### Configure Burp manual delete

	burp_manual_delete_enabled: true
	
##### Configure Burp Autoupgrade

	burp_server_autoupgrade_enabled: true
	
##### Activate clients from git repository

Example: 

```yaml
 burp_repos:
  - { repo: "http://host/group/repo.git", version: "master", dir: "linux_clients"}
```

You just need files per client, example: 

* client1 file content: *
 
	 password = 8urpCl13nt2015
	 dedup_group = trusty
	 . incexc/profile_lnxsrv

Dependencies
------------


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

First create your site.yml file:

*site.yml:*

```yaml
    - name: apply Burp 2 Server settings
      hosts: burp2_servers
      become: yes
      become_method: sudo
      # environment: "{{ proxy_env }}"
      roles:
        - { role: CoffeeITWorks.burp2_server, tags: [ "burp2_server_all", "burp2_server" ] }
```

And your inventory:

I'm would recommend to create inventory directory and put your inventories there, so you can call `ansible-playbook -i inventory` or `ansible-playbook -i inventory/production`.

*inventory/stage*: 

```yml
[burp2_servers]
srv1        ansible_ssh_host=192.168.77.10
```

Check connection before run:

    ssh user@address
    
Use `ssh-copy-id user@address` to avoid usage of -k (ask password)

Deploy it: 

    ansible-playbook -i inventory site.yml -u user -k

http://linux.die.net/man/1/ansible-playbook

Deploy it only to burp2_server and with limit tag (example, you don't need the limit and tag really): 

    ansible-playbook -i inventory site.yml --limit burp2_servers --tag burp2_server -u user -k

If you want to test with localhost, you can just have an inventory file with: 

    localhost

you will need to run with `ansible-playbook -i inventory site.yml --become --connection=local`

http://docs.ansible.com/ansible/playbooks_best_practices.html

Example tree
============ 

Example of all directories created: 

    
    ├── group_vars
    │   ├── all
    │   ├── burp2_servers
    ├── host_vars
    │   ├── srv1
    ├── inventory
    │   ├── production
    │   └── stage
    ├── site.yml


Installed services
==================

It user http://supervisord.org/ for better management of third-party  services on the system and to be compatible with most systems (ubuntu trusty+, debian, centos, fedora, etc).

So to restart installed services/daemons you should use: 

	supervisorctl restart buiagent/burp-server/burp-restore  (depends on the service you want to restart)

you can also just use: 

	supervisorctl

And then interactively use all options. 

*Logs:* 

Also supervisord allow proper stdout and stderror to logs redirection, so all logs are under `/var/logs/supervisor`

Logs are also rotated by logrotate automatically.


Behind proxy
============

(only if you are behind proxy)

Add to your group_vars file:

    proxy_env:
      http_proxy: "http://user:pass@hostname:port"

And uncomment `environment:` line in site.yml example. 

License
-------

MIT

Author Information
------------------

This role was main developed by Diego Daguerre with collaboration of Pablo Estigarribia (pablodav at gmail)

Burp backup and restore
=======================

Main page: http://burp.grke.org/

Burpui
======

Main page: https://git.ziirish.me/ziirish/burp-ui

Testing for developers
======================

https://molecule.readthedocs.io/en/latest/
