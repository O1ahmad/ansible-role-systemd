Ansible Role:vertical_traffic_light:Systemd
=========
[![Galaxy Role](https://img.shields.io/ansible/role/44466.svg)](https://galaxy.ansible.com/0x0I/systemd)
[![Downloads](https://img.shields.io/ansible/role/d/44466.svg)](https://galaxy.ansible.com/0x0I/systemd)
[![Build Status](https://travis-ci.org/0x0I/ansible-role-systemd.svg?branch=master)](https://travis-ci.org/0x0I/ansible-role-systemd)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Role Variables](#role-variables)
      - [Install](#install)
      - [Config](#config)
      - [Launch](#launch)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [License](#license)
  - [Author Information](#author-information)

Ansible role that installs and configures Systemd [Units](http://man7.org/linux/man-pages/man5/systemd.unit.5.html): system components and services managed by the Linux Systemd system/service manager.

##### Supported Platforms:
```
* Debian
* Redhat(CentOS/Fedora)
* Ubuntu
```

Requirements
------------

Systemd is generally considered the de-facto service management tool for Linux distributions and should be included with most OS installations. While typically not a concern, it is worth noting that Linux kernel >= 3.13 is required and Linux kernel >= 4.2 is necessary for unified cgroup hierarchy support.

Reference the systemd [README](https://github.com/systemd/systemd/blob/master/README) for further details.

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_

#### Install

...*description of installation related vars*...

#### Config

...*description of configuration related vars*...

Dependencies
------------

None

Example Playbook
----------------
default example:
```
- hosts: all
  roles:
  - role: 0xOI.systemd
```

License
-------

Apache, BSD, MIT

Author Information
------------------

This role was created in 2019 by O1 Labs.
