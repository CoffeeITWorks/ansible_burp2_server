[![CircleCI](https://circleci.com/gh/CoffeeITWorks/ansible_burp2_server.svg?style=svg)](https://circleci.com/gh/CoffeeITWorks/ansible_burp2_server)

Getting Started
================

Check the documentation added in: 

https://github.com/CoffeeITWorks/ansible-generic-help#getting-started


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
    # You can also change the password:
    burp_agent_global_password: "password"

	
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

* client1 file content: 
 
    password = clientpassword
    dedup_group = trusty
    . incexc/profile_lnxsrv


Dependencies
------------


Installed services
==================

It user http://supervisord.org/ for better management of third-party  services on the system and to be compatible with most systems (ubuntu trusty+, debian, centos, fedora, etc).

So to restart installed services/daemons you should use: 

    sudo supervisorctl restart buiagent/burp-server/burp-restore  (depends on the service you want to restart)

you can also use supervisorctl shell: 

    sudo supervisorctl

And then interactively use all options. 

*Logs:* 

Also supervisord allow proper stdout and stderror to logs redirection, so all logs are under `/var/logs/supervisor`

Logs are also rotated by logrotate automatically.


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


Testing master branch:
----------------------

Now there is only need to modify these to group/host vars:

    burpsrcext: "zip"
    burp_version: "master"



