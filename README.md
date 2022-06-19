Getting Started
===============

Check the documentation added in:

<https://github.com/CoffeeITWorks/ansible-generic-help#getting-started>

Full list of roles: <https://github.com/grke/burp/wiki/Automated-deploy-and-maintenance>

Tests
-----

[![Molecule](https://github.com/CoffeeITWorks/ansible_burp2_server/actions/workflows/molecule-test.yml/badge.svg)](https://github.com/CoffeeITWorks/ansible_burp2_server/actions/workflows/molecule-test.yml)

quickstart
----------

Install ansible on your control machine (See getting-started)
Install python-minimal (for Ubuntu 16.04+) on remote machine (or in local if you are using ansible locally)

Copy example inventory and files: <https://github.com/CoffeeITWorks/ansible-generic-help/tree/master/example1>
(You can download the repo and copy the example1 dir)

See also [Quickstart.md](resources/quickstart/Quickstart.md)

Example playbook

```yaml
---

- name: burp2 servers
  become: yes
  become_method: sudo
  # environment: "{{ proxy_env }}"  # example to use behind proxy
  hosts: burp2_servers
  # Define the list of servers and add tags so you will be able to filter the call to a tag:
  roles:
    - role: coffeeitworks.burp2_server
      tags:
        - "burp2_server_all"
- "burp2_server"
```

Install this role, example:

```shell
ansible-galaxy install -r requirements.yml
- downloading role 'burp2_server', owned by CoffeeITWorks
- downloading role from https://github.com/CoffeeITWorks/ansible_burp2_server/archive/master.tar.gz
- extracting coffeeitworks.burp2_server to /home/pablo/.ansible/roles/coffeeitworks.burp2_server
- coffeeitworks.burp2_server (master) was installed successfully
```

Modify the ip address in `inventory/test`

run ansible-playbook:

```shell
ansible-playbook -i inventory/ roles.burp2_servers.yml -v -u pablo --ask-pass
```

Later you will be able to customize some vars adding your own values in `group_vars` variables or `host_vars`.

Requirements
------------

Install this role if you wanna use it with centos > 8
```yaml
- src: https://github.com/robertdebock/ansible-role-powertools
  name: ansible-role-powertools
```

Role Name
---------

ansible burp2_server deploy and maintenance role.

This roles builds burp version specified on defaults/main.yml.
Also configures it to get it working and maintained in a centralized way.

See [FEATURES.md](FEATURES.md)

Installing this role
--------------------

---

Install the role on the system:

    ansible-galaxy install coffeeitworks.burp2_server

Checkout more info at: <https://github.com/CoffeeITWorks/ansible-generic-help#installing-roles>

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

example file `group_vars/burp2_servers/burp2_server_vars.yml`

Check also all vars in `defaults/main.yml` you can override any default using your host/group_vars

Role Variables: Complete list of modules
----------------------------------------

Modules
-------

---

Configure Burp UI Agent
-----------------------

Burp-ui agent was moved to another role: https://github.com/CoffeeITWorks/ansible_burpui_agent

It's very recommended to use burpui-agent with python3, if you know role to add python3/pip3 on centos please contact me to update this information.

Configure Burp manual delete
----------------------------

(Enabled by default)

---

     burp_manual_delete_enabled: true

Configure Burp Autoupgrade
--------------------------

(Enabled by default)

---

     burp_server_autoupgrade_enabled: true

Port per operation
------------------

(Enabled by default)

---

Since version 2.1.10

+ Add the ability for the client to connect to different server ports

 according to whether it is doing backup/restore/verify/list/delete.
 These ports are based on: <https://github.com/CoffeeITWorks/ansible_burp2_server/issues/11>
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

Activate clients from git repository
------------------------------------

---

Example:

```yaml
 burp_repos:
  - { repo: "http://host/group/repo.git", version: "master", dir: "linux_clients"}
```

You just need files per client, example:

+ client1 file content:

    password = clientpassword
    dedup_group = trusty
    . incexc/profile_lnxsrv

Add clients from a list
-----------------------

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

<http://docs.ansible.com/ansible/playbooks_variables.html#passing-variables-on-the-command-line>

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

Configure your own profiles
---------------------------

---

Check `defaults/main.yml` file, to copy the content and create your own profiles with `profiles_templates var`

A small example:

```yaml
# See also files/incexc, those in this repo are copied to /etc/burp/clientconfdir/incexc
# This template create each template in: /etc/burp/clientconfdir/incexc/name
profiles_templates:

  - name: profile_lnxsrv
    content:
      - "#hard_quota No permitir backups a clientes con mas de xxGb en el backup total"
      - "#hard_quota Do not allow to backup clients with more than xxGb in the whole backup"
      - "hard_quota=65Gb"
      - ""
      - "#soft_quota enviar WARNING backups a de clientes con mas de xxGb en el backup total"
      - "#soft_quota send WARNING to backups clients with more than xxGb in the whole backup"
      - "soft_quota=50Gb"
      - ""
      - ". lnxsrv_global_inclusions"
      - ". lnxsrv_global_exclusions"
      - ". compressed_exclusions"
      - ". audio_compressed_exclusions"
      - ". generic_excluded_extensions"
      - ""
      - "cross_all_filesystems=1"
      - "dedup_group = lnxsrv"
```

Add your own lines to burp-server.conf
--------------------------------------

---

        burp_server_custom_lines:
        - "someextra=line"

See https://burp.grke.org/docs/manpage.html

Remove clients from a list
--------------------------

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

Services
--------

---

You can choose between [systemd, supervisor, systemd_unprivileged] using var:

    burp_sv_type: systemd

All systemd installs service 'burp-server' name. And you can use `systemctl start/stop burp-server` to control the service.

To control service with supervisor, use the following
-----------------------------------------------------

To restart installed services/daemons you should use:

    sudo supervisorctl restart buiagent/burp-server/burp-restore  (depends on the service you want to restart)

you can also use supervisorctl shell:

    sudo supervisorctl

And then interactively use all options.

*Logs:*

Also supervisord allow proper stdout and stderror to logs redirection, so all logs are under `/var/logs/supervisor`

Logs are also rotated by logrotate automatically.

Upgrading your OS
-----------------

Please note when using compiled version of burp with this role, after you upgrade your linux distribution is very recommended to run recompile and install of burp.

Example to run it once:

    ansible-playbook -i production burp-servers.yml -l client -e "burp_force_reinstall=yes"

The variable `burp_force_reinstall: yes` will do it for you.

License
-------

MIT

Author Information
------------------

This role was created by Diego Daguerre with collaboration of Pablo Estigarribia (pablodav at gmail)
Actually main developer is Pablo Estigarribia.

Burp backup and restore
-----------------------

Main page: <http://burp.grke.org/>

Testing master branch
---------------------

Now there is only need to modify these to group/host vars:

    burpsrcext: "zip"
    burp_version: "master"

Performance improvements
------------------------

+ compile optimizations.

Now this role compiles with some better configurations for performance improvements, you can also change the variable `burp_configure_line` with your own configure flags too.
See <https://github.com/CoffeeITWorks/ansible_burp2_server/issues/24.>

Backup script tool from deajan
------------------------------

+ Add backup script tool from @deajan

backup_script_tool is added as optional installation, you can use var `install_backup_tool_script: true` to install, see defaults/main.yml vars for more options.
<https://github.com/CoffeeITWorks/ansible_burp2_server/issues/26>

See <https://github.com/grke/burp/wiki/Utils#backup-tool-script>

Upgrades
--------

To upgrade previous version or also upgrade from apt/yum/dnf/zypper installation to this role, you can run the playbook located in: [resources/upgrade.yml](resources/upgrade.yml)

And run it

    ansible-playbook -i inventory upgrade.yml -u username -k

Collaborators
-------------

Put your name here.

Developers
----------

How to test this role?

I have prepared an script and molecule tests, just install docker in your system and start it, then run the script:
Disable selinux to allow setattr commands when using restore (disable and restart, permissive doesn't works too)

```bash
sudo systemctl start docker
./run_local_molecule_basic.sh
```

Once tests are done, clean the created instances with (after a reboot also use destroy):

```bash
./run_local_molecule_destroy.sh
```

As it uses docker images, you don't need to install anything.

For burp maintainers and developers, there is also a separate role to perform tests on any burp server:
<https://github.com/CoffeeITWorks/ansible_burp2_tests>
