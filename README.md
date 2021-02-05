<p><img src="https://code.benco.io/icon-collection/logos/ansible.svg" alt="ansible logo" title="ansible" align="left" height="60" /></p>
<p><img src="https://www.servethehome.com/wp-content/uploads/2017/11/Redhat-logo.jpg" alt="redhat logo" title="redhat" align="right" height="60" /></p>

Ansible Role:vertical_traffic_light:Systemd
=========
[![Galaxy Role](https://img.shields.io/ansible/role/44466.svg)](https://galaxy.ansible.com/0x0I/systemd)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/0x0I/ansible-role-systemd?color=yellow)
[![Downloads](https://img.shields.io/ansible/role/d/44466.svg?color=lightgrey)](https://galaxy.ansible.com/0x0I/systemd)
[![Build Status](https://travis-ci.org/0x0I/ansible-role-systemd.svg?branch=master)](https://travis-ci.org/0x0I/ansible-role-systemd)
[![License: MIT](https://img.shields.io/badge/License-MIT-blueviolet.svg)](https://opensource.org/licenses/MIT)

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

Ansible role that installs and configures **Systemd** [units](http://man7.org/linux/man-pages/man5/systemd.unit.5.html): system components and services managed by the Linux `systemd` system/service manager.

##### Supported Platforms:
```
* Debian
* Redhat(CentOS/Fedora)
* Ubuntu
```

Requirements
------------

`systemd` is generally considered the de-facto service management tool for Linux distributions and should be included with most OS installations. While typically not a concern, it may be worth noting that *Linux kernel >= 3.13* is required by `systemd` and *Linux kernel >= 4.2* is necessary for unified cgroup hierarchy support.

Reference the systemd [README](https://github.com/systemd/systemd/blob/master/README) for further details.

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_
* _launch_

#### Install

`[unit_config: <config-list-entry>:] path:` (**default**: <string> `/etc/systemd/system`)
- load path to systemd unit configuration.

  In addition to /etc/systemd/system (*default*), unit configs and associated drop-in ".d" directory overrides for system services can be placed in `/usr/lib/systemd/system` or `/run/systemd/system` directories.

  Files in **/etc** take precedence over those in **/run** which in turn take precedence over those in **/usr/lib**. Drop-in files under any of these directories take precedence over unit files wherever located. Multiple drop-in files with different names are applied in lexicographic order, regardless of which of the directories they reside in. See table below and consult **systemd(1)** for additional details regarding path load priority.

*Load paths when running in **system mode*** (--system)

| Unit Load File Path | Description |
| --- | --- |
| /etc/systemd/system | Local configuration |
| /run/systemd/system | Runtime units |
| /usr/local/lib/systemd/system | Units installed for local system administration |
| /usr/lib/systemd/system | Units of installed packages |

*Load paths when running in **user mode*** (--user)

| Unit Load File Path | Description |
| --- | --- |
| *$XDG_CONFIG_HOME*/systemd/user or *$HOME*/.config/systemd/user | User configuration (*$XDG_CONFIG_HOME* is used if set, ~/.config otherwise) |
| /etc/systemd/user | User units created by the administrator |
| *$XDG_RUNTIME_DIR*/systemd/user | Runtime units (only used when *$XDG_RUNTIME_DIR* is set) |
| /run/systemd/user | Runtime units |
| *$dir*/systemd/user for each *$dir* in *$XDG_DATA_DIRS* | Additional locations for installed user units, one for each entry in *$XDG_DATA_DIRS* |
| /usr/local/lib/systemd/user | User units installed for local system administration |
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

`[unit_config: <config-list-entry>:] type: <string>` (**default**: `service`)
- type of systemd unit to configure. There are currently 11 different unit types, ranging from daemons and the processes they consist of to path modification triggers. Consult [systemd(1)](http://man7.org/linux/man-pages/man1/systemd.1.html) for the full list of available units.

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

Configuration of a `systemd` unit is declared in an [ini-style](https://en.wikipedia.org/wiki/INI_file) config file. A `systemd` unit *INI* config is composed of sections: 2 common amongst all unit types (`Unit` and `Install`) and 1 specific to each unit type. These unit configurations can be expressed within the role's `unit_config` hash variable as lists of dicts containing key-value pairs representing the name, type, load path of the unit and a combination of the aforemented section definitions.

Each configuration section definition provides a dict containing a set of key-value pairs for corresponding section options (e.g. the `ExecStart` specification for a system or web service `[Service]` section or the `ListenStream` option for a web `[Socket]` section).

`[unit_config: <list-entry>:] Unit | <unit-type e.g. Service, Socket, Device or Mount> | Install: <dict>` (**default**: {})
- section definitions for a unit configuration

Any configuration setting/value key-pair supported by the corresponding *Systemd* unit type specification should be expressible within each `unit_config` collection and properly rendered within the associated *INI* config.

_The following provides an overview and example configuration of each unit type for reference_.

**[[Service](http://man7.org/linux/man-pages/man5/systemd.service.5.html)]**

Manages daemons and the processes they consist of.

#### Example

 ```yaml
  unit_config:
    # path: /etc/systemd/system/example-service.service
    - name: example-service
      Unit:
        Description: Sleepy service
      Service:
        ExecStart: /usr/bin/sleep infinity
      Install:
        WantedBy: multi-user.target
```
**[[Socket](http://man7.org/linux/man-pages/man5/systemd.socket.5.html)]**

Encapsulates local IPC or network sockets in the system.

#### Example

 ```yaml
  unit_config:
    - name: docker
      type: socket
      Unit:
        Description: Listens/accepts connection requests at /var/run/docker/sock (implicitly *Requires=* associated docker.service)
      Socket:
        ListenStream: /var/run/docker.sock
        SocketMode: 0660
        SockerUser: root
        SocketGroup: docker
      Install:
        WantedBy: sockets.target
```

**[[Mount](http://man7.org/linux/man-pages/man5/systemd.mount.5.html)]**

Controls mount points in the sytem.

#### Example

 ```yaml
  unit_config:
    - name: tmp_new
      type: mount
      Unit:
        Description: New Temporary Directory (/tmp_new)
        Conflicts: umount.target
        Before: local-fs.target umount.target
        After: swap.target
      Mount:
        What: tmpfs
        Where: /tmp_new
        Type: tmpfs
        Options: mode=1777,strictatime,nosuid,nodev
```

**[[Automount](http://man7.org/linux/man-pages/man5/systemd.automount.5.html)]**

Provides automount capabilities for on-demand mounting of file systems as well as parallelized boot-up.

#### Example

 ```yaml
  unit_config:
    - name: proc-sys-fs-binfmt_misc
      type: automount
      Unit:
        Description: Arbitrary Executable File Formats File System Automount Point
        Documentation: https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html
        ConditionPathExists: /proc/sys/fs/binfmt_misc/
        ConditionPathIsReadWrite: /proc/sys/
      Automount:
        Where: /proc/sys/fs/binfmt_misc
```

**[[Device](http://man7.org/linux/man-pages/man5/systemd.device.5.html)]**

Exposes kernel devices and implements device-based activation.

This unit type has no specific options and as such a separate `[Device]` section does not exist. The common configuration items are configured in the generic `[Unit]` and `[Install]` sections. `systemd` will dynamically create device units for all kernel devices that are marked with the "systemd" udev tag (by default all block and network devices, and a few others). To tag a udev device, use **TAG+="systemd** in the udev rules file. Also note that device units are named after the */sys* and */dev* paths they control.

#### Example

 ```yaml
# /usr/lib/udev/rules.d/10-nvidia.rules

SUBSYSTEM=="pci", ATTRS{vendor}=="0x12d2", ATTRS{class}=="0x030000", TAG+="systemd", ENV{SYSTEMD_WANTS}="nvidia-fallback.service"

# Will result in the automatic generation of a nvidia-fallback.device file with appropriate [Unit] and [Install] sections set
```

**[[Target](http://man7.org/linux/man-pages/man5/systemd.target.5.html)]**

Provides unit organization capabilities and setting of well-known synchronization points during boot-up.

This unit type has no specific options and as such a separate `[Target]` section does not exist. The common configuration items are configured in the generic `[Unit]` and `[Install]` sections.

#### Example

 ```yaml
  unit_config:
    - name: graphical
      path: /usr/lib/systemd/system/graphical.target
      type: target
      Unit:
        Description: Graphical Interface
        Documentation: man:systemd.special(7)
        Requires: multi-user.target
        Wants: display-manager.service
        Conflicts: rescue.service rescue.target
        After: multi-user.target rescue.service rescue.target display-manager.service
        AllowIsolate: yes
```

**[[Timer](http://man7.org/linux/man-pages/man5/systemd.timer.5.html)]**

Triggers activation of other units based on timers.

#### Example

 ```yaml
  unit_config:
    - name: dnf-makecache
      type: timer
      Timer:
        OnBootSec: 10min
        OnUnitInactiveSec: 1h
        Unit: dnf-makecache.service
      Install:
        WantedBy: multi-user.target
```

**[[Swap](http://man7.org/linux/man-pages/man5/systemd.swap.5.html)]**

Encapsulates memory swap partitions or files of the operating system.

#### Example

 ```yaml
  # Ensure existence of swap file
  mkdir -p /var/vm
  fallocate -l 1024m /var/vm/swapfile
  chmod 600 /var/vm/swapfile
  mkswap /var/vm/swapfile

------------------------------------

  unit_config:
    - name: var-vm-swap
      type: swap
      Unit:
        Description=Turn on swap for /var/vm/swapfile
      Swap:
        What: /var/vm/swapfile
      Install:
        WantedBy: multi-user.target
```

**[[Path](http://man7.org/linux/man-pages/man5/systemd.path.5.html)]**

Activates other services when file system objects change or are modified.

#### Example

 ```yaml
  unit_config:
    - name: Repository Code Coverage Analysis trigger
      type: path
      Unit:
        Description: Activate code coverage analysis on modified git repositories
      Path:
        PathChanged: /path/to/git/repo
        Unit: code-coverage-analysis
```

**[[Scope](http://man7.org/linux/man-pages/man5/systemd.scope.5.html)]**

Manages a set of system or foreign/remote processes.

**Scope units are not configured via unit configuration files, but are only created programmatically using the bus interfaces of systemd.** Unlike service units, scope units manage externally created processes and do not fork off processes on their own. The main purpose of scope units is grouping worker processes of a system service for organization and for managing resources.

#### Example

 ```yaml
 # *This configuration is for a transient unit file, created programmatically via the systemd API. Do not copy or edit.*
  unit_config:
    - name: user-session
      type: scope

      Unit:
        Description: Session of user
        Wants: user-runtime-dir@1000.service
        Wants: user@1000.service
        After: systemd-logind.service systemd-user-sessions.service user-runtime-dir@1000.service user@1000.service
        RequiresMountsFor: /home/user
        Scope:
          Slice: user-1000.slice
       Scope:
          SendSIGHUP=yes
          TasksMax=infinity
```

**[[Slice](http://man7.org/linux/man-pages/man5/systemd.slice.5.html)]**

Group and manage system processes in a hierarchical tree for resource management purposes.

The name of the slice encodes the location in the tree. The name consists of a dash-separated series of names, which describes the path to the slice from the root slice. By default, service and scope units are placed in system.slice, virtual machines and containers registered with systemd-machined(1) are found in machine.slice and user sessions handled by systemd-logind(1) in user.slice.

See [systemd.slice(5)](http://man7.org/linux/man-pages/man5/systemd.slice.5.html) for more details.

**[[Drop-in](http://man7.org/linux/man-pages/man1/systemd.1.html)]**

Provides override capabilities for units.

#### Example

 ```yaml
  unit_config:
    - name: override.conf
      type: conf
      path: "/lib/systemd/system/getty@.service.d"
      Service:
        ExecStart:
          - ""
          - "-/sbin/agetty -a muru --noclear %I $TERM"
        EnvironmentFile=/path/to/some/file
```

#### Launch

`[unit_config: <config-list-entry>:] enabled:` (**default**: <string> `no`)
- whether the service should start on boot

`[unit_config: <config-list-entry>:] state:` (**default**: <string> `stopped`)
- unit activation state

Dependencies
------------

None

Example Playbook
----------------
default example (no custom unit configurations specified):
```
- hosts: all
  roles:
  - role: 0x0I.systemd
```

service/socket/mount pair:
```
- hosts: webservers
  roles:
  - role: 0x01.systemd
    vars:
      unit_config:
      - name: "my-service"
        Unit:
          After: network-online.target
          Wants: network-online.target
          Requires: my-service.socket
        Service:
          User: 'web'
          Group: 'web'
          ExecStart: '/usr/local/bin/my_service $ARGS'
          ExecReload: '/bin/kill -s HUP $MAINPID'
        Install:
          WantedBy: 'multi-user.target'
      - name: "my-service"
        type: "socket"
        Socket:
          ListenStream: '0.0.0.0:4321'
          Accept: 'true'
        Install:
          WantedBy: 'sockets.target'
      - name: "var-data-my_service"
        type: "mount"
        path: "/run/systemd/system"
        Mount:
          What: '/dev/nvme0'
          Where: '/var/data/my_service'
        Install:
          WantedBy: 'multi-user.target'
```

License
-------

MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
