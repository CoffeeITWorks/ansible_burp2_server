[![CircleCI](https://circleci.com/gh/CoffeeITWorks/ansible_burp2_server.svg?style=svg)](https://circleci.com/gh/CoffeeITWorks/ansible_burp2_server)

[![Build Status](https://travis-ci.org/CoffeeITWorks/ansible_burp2_server.svg?branch=master)](https://travis-ci.org/CoffeeITWorks/ansible_burp2_server)

Getting Started
================

Check the documentation added in: 

https://github.com/CoffeeITWorks/ansible-generic-help#getting-started


Role Name
=========

ansible burp2_server deploy and maintenance role.

This roles builds burp version specified on defaults/main.yml. 
Also configures it to get it working and maintained in a centralized way.

See [FEATURES.md](FEATURES.md)

Installing this role
--------------------

---

Install the role on the system: 

    $ ansible-galaxy install CoffeeITWorks.burp2_server

Checkout more info at: https://github.com/CoffeeITWorks/ansible-generic-help#installing-roles

Requirements
------------


Preparing the variables
-----------------------

---

We have an **inventory** and a **playbook** to call the roles, but we must customize the [variables](http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) before running 
 the playbook. 
 
Here we will organize the variables files into the `group_vars` directory:

    mkdir -p group_vars/burp2_servers

Inside it you can add a file with the name of the group or the host where you want to add specific options of this role.

example file `group_vars/burp2_servers/burp2_server_vars`

*Options vars:* 

```yaml
burp_module_agent: true # Will add buiagent and configure it properly to use on burpui-multiagent mode. 
burp_module_restore: true # Will configure a second burp server with same spool, useful to configure one restore_client to get restores faster on large deployments.
```

Check also all vars in `defaults/main.yml` you can override any default using your host/group_vars



Role Variables: Complete list of modules:
-----------------------------------------

### Modules

---

#### Configure Burp UI Agent

---

    burp_module_agent: true
    # You can also change the password:
    burp_agent_global_password: "password"
    # For centos use pip2 or add role to install pip3 with pyton3 (very recommended)
    python_pip_executable: "pip2" # options pip3 / pip2

It's very recommended to use burpui-agent with python3, if you know role to add python3/pip3 on centos please contact me to update this information.
	
#### Configure burp restore service

---

 Burp Restore is another burp daemon with the unique purpose
 to have possibility to restore when backups reach max_children
 This was created before 2.1.10 added port per operation support
 and will be deprecated once burp 2.1 becomes stable	

     burp_module_restore: true
	
#### Configure Burp manual delete

---

     burp_manual_delete_enabled: true
	
#### Configure Burp Autoupgrade

---

     burp_server_autoupgrade_enabled: true

#### Port per operation

--- 

Since version 2.1.10
   + Add the ability for the client to connect to different server ports

 according to whether it is doing backup/restore/verify/list/delete.
 These ports are based on: https://github.com/CoffeeITWorks/ansible_burp2_server/issues/11
 Compatible since burp 2.1.10

```yaml
burp_server_port_per_operation_bool: true

# Default optional vars to change:
# These are not needed to be changed, but showing here the
# defaults that we have in defaults/main.yml
burp_server_port_operation_restore: 4975
burp_server_port_operation_verify: 4976
burp_server_port_operation_list: 4977
burp_server_port_operation_delete: 4978
```

This option **will setup** `/etc/burp/burp.conf` for `burp-ui-agent` when used with `burp_module_agent: true` to benefit the performance of `burp-ui`

Check also `burp_server_ports_per_operation:` on `defaults/main.yml` to change
max_children per operation

#### Activate clients from git repository

---

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

#### Add clients from a list

---

 Optional list of clients to add on specific execution

```yaml
burp2_add_manual_clients:
  - name: client_name
    profile: profile name to use (optional), default: profile_lnxsrv (these files are in incexc/ dir).
    password: client_password (optional), default: burp_client_password var
  - name: second_client
```

You can use it as a fixed list or a dinamic specifying it during `ansible-playbook` command execution: 

http://docs.ansible.com/ansible/playbooks_variables.html#passing-variables-on-the-command-line

Example using json like var in command line: 

    --extra-vars '{ "burp2_add_manual_clients": [ { "name": "test_manual" }, { "name": "test_manual2", "profile": "profile_win6x" } ] }'

It will create the files: 

```bash

ansible@ubuntuburp2:~$ cat /etc/burp/clientconfdir/test_manual2
# Ansible managed

password = password

# More configuration files can be read, using syntax like the following
# (without the leading '# ').
. incexc/profile_win6x
ansible@ubuntuburp2:~$ cat /etc/burp/clientconfdir/test_manual
# Ansible managed

password = password

# More configuration files can be read, using syntax like the following
# (without the leading '# ').
. incexc/profile_lnxsrv

```

#### Configure your own profiles

---

Check `defaults/main.yml` file, to copy the content and create your own profiles with `profiles_templates var`

#### Add your own lines to burp-server.conf

---

        burp_server_custom_lines:
        - "someextra=line"

#### Remove clients from a list

---

There is now a feature to allow you to remove a client from a list, variable used is: 

```yaml
burp_remove_clients:
  - name: client_to_remove
  - name: other_client_to_remove
```

You can use this variable in a static var file like:  `group_vars`, or at runtime. Example: 

    ansible-playbook --extra-vars '{ "burp_remove_clients": [ { "name": "test_manual" }, { "name": "test_manual2" } ] }' -i inventory roles.burp_servers.yml -u user -k

Dependencies
------------


Installed services
------------------

---

It uses http://supervisord.org/ for better management of third-party  services on the system and to be compatible with most systems (ubuntu trusty+, debian, centos, fedora, etc).

To restart installed services/daemons you should use: 

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

This role was created by Diego Daguerre with collaboration of Pablo Estigarribia (pablodav at gmail)
Actually main developer is Pablo Estigarribia.

Burp backup and restore
-----------------------

Main page: http://burp.grke.org/

Burpui
------

Main page: https://git.ziirish.me/ziirish/burp-ui


Testing master branch:
----------------------

Now there is only need to modify these to group/host vars:

    burpsrcext: "zip"
    burp_version: "master"
