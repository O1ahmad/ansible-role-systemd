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

_The following variables can be customized to control various aspects of installation of individual systemd units. It is assumed that the host has a working version of the systemd package. Available versions based on OS distribution can be found [here](http://fr2.rpmfind.net/linux/rpm2html/search.php?query=systemd&submit=Search+...&system=&arch=)_

`[unit_config: <config-list-entry>:] path:` (**default**: `/etc/systemd/system`)
- load path to systemd unit configuration. 

  In addition to /etc/systemd/system (*default*), unit configs and associated drop-in ".d" directory overrides for system services can be placed in `/usr/lib/systemd/system` or `/run/systemd/system` directories.
  
  Files in **/etc** take precedence over those in **/run** which in turn take precedence over those in **/usr/lib**. Drop-in files under any of these directories take precedence over unit files wherever located. Multiple drop-in files with different names are applied in lexicographic order, regardless of which of the directories they reside in. See table below and consult systemd(1) for details regarding path load priority.
  
| Unit Load File Path | Description |
| --- | --- |
| /etc/systemd/system | Local configuration |
| /run/systemd/system | Runtime units |
| /usr/lib/systemd/system | Units of installed packages |

#### Example

 ```yaml
  unit_config:
    - name: apache
      path: /run/systemd/system
      Service:
        ExecStart: /usr/sbin/httpd
        ExecReload: /usr/sbin/httpd $OPTIONS -k graceful
      Install:
        WantedBy: multi-user.target
```

`[unit_config: <config-list-entry>:] type:` (**default**: `service`)
- type of systemd unit to configure. There are currently 11 different unit types, ranging from daemons and the processes they consist of to path modification triggers. Consult systemd(1) for the full list of available units [here](https://web.kamihq.com/web/viewer.html?state=%7B%22ids%22%3A%5B%221lUefHPsKMkh0s9xbPopMy56HNk2JO6jS%22%5D%2C%22action%22%3A%22open%22%2C%22userId%22%3A%22112001717226039816040%22%7D&filename=null).

#### Example

 ```yaml
  unit_config:
    - name: apache
      type: socket
      Socket:
        ListenStream: 0.0.0.0:8080
        Accept: yes
      Install:
        WantedBy: sockets.target
```

#### Config

Configuration of a `systemd` unit can be expressed in an ini-style config [file](https://en.wikipedia.org/wiki/INI_file)[Reference](https://www.freedesktop.org/software/systemd/man/systemd.unit.html) to get an idea how the config should look.

Each Systemd unit INI config is composed of sections: 2 common amongst all unit types (Unit and Install) and 1 specific to each unit type. Each section can be expressed within a hash, keyed by section title. The value of these section keys are generally dicts representing config specifications containing a set of key-value pairs listing associated settings for each section (e.g. the `ExecStart` specification for a system or web service `[Service]` section or the `ListenStream` option for a web `[Socket]` section) . The following provides an overview and example configuration of each unit type for reference.

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
