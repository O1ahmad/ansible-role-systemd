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

Ansible role that installs and configures Systemd [units](http://man7.org/linux/man-pages/man5/systemd.unit.5.html): system components and services managed by the Linux Systemd system/service manager.

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

_The following variables can be customized to control various aspects of installation of individual systemd units. It is assumed that the host has a working version of the systemd package. Available versions based on OS distribution can be found [here](http://fr2.rpmfind.net/linux/rpm2html/search.php?query=systemd&submit=Search+...&system=&arch=)_.

`[unit_config: <config-list-entry>:] path:` (**default**: `/etc/systemd/system`)
- load path to systemd unit configuration. 

  In addition to /etc/systemd/system (*default*), unit configs and associated drop-in ".d" directory overrides for system services can be placed in `/usr/lib/systemd/system` or `/run/systemd/system` directories.
  
  Files in **/etc** take precedence over those in **/run** which in turn take precedence over those in **/usr/lib**. Drop-in files under any of these directories take precedence over unit files wherever located. Multiple drop-in files with different names are applied in lexicographic order, regardless of which of the directories they reside in. See table below and consult systemd(1) for details regarding path load priority.
  
Load paths when running in **system mode** (--system)

| Unit Load File Path | Description |
| --- | --- |
| /etc/systemd/system | Local configuration |
| /run/systemd/system | Runtime units |
| /usr/local/lib/systemd/system | Units installed for local system administrator |
| /usr/lib/systemd/system | Units of installed packages |

Load paths when running in **user mode** (--user)

| Unit Load File Path | Description |
| --- | --- |
| $XDG_CONFIG_HOME/systemd/user or $HOME/.config/systemd/user | User configuration ($XDG_CONFIG_HOME is used if set, ~/.config otherwise) |
| /etc/systemd/user | User units created by the administrator |
| $XDG_RUNTIME_DIR/systemd/user | Runtime units (only used when $XDG_RUNTIME_DIR is set) |
| /run/systemd/user | Runtime units |
| $dir/systemd/user for each $dir in $XDG_DATA_DIRS | Additional locations for installed user units, one for each entry in $XDG_DATA_DIRS |
| /usr/local/lib/systemd/user | User units installed by the administrator |
| /usr/lib/systemd/user | User units installed by the distribution package manager |

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

Configuration of a `systemd` unit is declared in an [ini-style](https://en.wikipedia.org/wiki/INI_file) config file see [here](https://www.freedesktop.org/software/systemd/man/systemd.unit.html) to get an idea how the config should look. 

A Systemd unit INI config is composed of sections: 2 common amongst all unit types (`Unit` and `Install`) and 1 specific to each unit type. These unit configurations can be expressed within the role's `unit_config` hash variable as lists of dicts containing key-value pairs representing the name, type, load path of the unit and a combination of the aforemented sections definitions.

Each configuration section definition provides a dict containing a set of key-value pairs for corresponding section options (e.g. the `ExecStart` specification for a system or web service `[Service]` section or the `ListenStream` option for a web `[Socket]` section.

[unit_config: <list-entry>:] Unit | <unit-type e.g. Service, Socket, Device or Mount> | Install: (**default**: {})
- section definitions for a unit configuration

Any configuration setting/value key-pair supported by the corresponding `Systemd` unit type specification should be expressible within each `unit_config` collection and properly rendered within the associated INI config.

_The following provides an overview and example configuration of each unit type for reference_.

**[Service]**

Manage daemons and the processes they consist of.

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
**[Socket]**

Encapsulating local IPC or network sockets in the system.

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

**[Mount]**

Control mount points in the sytem.

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

**[Automount]**

Provide automount capabilities, for on-demand mounting of file systems as well as parallelized boot-up.

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

**[Device]**

Expose kernel devices and implement device-based activation.

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

**[Target]**

Provides unit organization capabilities and setting of well-known synchronization points during boot-up.

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

**[Timer]**

Triggers activation of other units based on timers.

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

**[Swap]**

Encapsulate memory swap partitions or files of the operating system.

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

**[Path]**

Activates other services when file system objects change or are modified.

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

**[Scope]**

Manage foreign processes.

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

**[Slice]**

Group and manage system processes in a hierarchical tree for resource management purposes.

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
