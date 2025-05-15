# Ansible Role: dokuwikicmdb

[![CI](https://github.com/anylinq-B-V/ansible-role-dokuwikicmdb/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/anylinq-B-V/ansible-role-dokuwikicmdb/actions/workflows/ci.yml)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

## Overview

This Ansible role creates and manages a Configuration Management Database (CMDB) in [DokuWiki](https://www.dokuwiki.org/). It collects system information from your servers, generates documentation files locally, and updates DokuWiki pages with server details, monitoring agent status, logging configuration, and more.

## Features

- Collects and documents server hardware, OS, and network details.
- Integrates with Zabbix Agent 2 and Wazuh Agent for monitoring status.
- Checks and documents rsyslog and journald logging configuration.
- Generates and uploads server description, notes, and changelog files.
- Creates a server list page and individual server pages in DokuWiki using Jinja2 templates.

## Requirements

- Ansible 2.9 or higher.
- Target systems: Linux (tested on Debian, Ubuntu, EL/Rocky).
- DokuWiki instance accessible via SSH (for file upload).
- Python 3 on the Ansible control node.

## Role Variables

All variables and their defaults are defined in [`defaults/main.yml`](defaults/main.yml). Key variables include:

- **DokuWiki integration:**
  - `dokuwiki_targetserver`: Hostname or IP of your DokuWiki server (**must be overridden**).
  - `dokuwiki_directory`: Path to the DokuWiki pages directory on the DokuWiki server.
  - `dokuwiki_user`, `dokuwiki_group`: File owner/group for DokuWiki pages.
  - `dokuwiki_serverlist_destination`: Path for the generated server list page.
  - `dokuwiki_local_destination`: Local path for server description files on each managed host.

- **Zabbix Agent:**
  - `zabbix_agent_package_name`
  - `zabbix_agent_service_name`
  - `zabbix_agent_conf_file`

- **Wazuh Agent:**
  - `wazuh_agent_package_name`
  - `wazuh_agent_service_name`
  - `wazuh_agent_conf_file`

- **Logging:**
  - `graylog_rsyslog_conf_file`
  - `journald_conf_file`
  - `rsyslog_imjournal_conf_file`

See [`defaults/main.yml`](defaults/main.yml) for all variables.

## Templates

- [`templates/server.txt.j2`](templates/server.txt.j2): Main server documentation page.
- [`templates/description.txt.j2`](templates/description.txt.j2): Editable server description (owner, function, location, SLA).
- [`templates/serverlist.txt.j2`](templates/serverlist.txt.j2): Overview of all managed servers.

## Example Playbook

```yaml
- hosts: servers
  become: true
  vars:
    dokuwiki_targetserver: "dokuwiki.example.com"
    dokuwiki_directory: "/srv/dokuwiki/data/pages/servers"
    dokuwiki_user: "www-data"
    dokuwiki_group: "www-data"
    dokuwiki_serverlist_destination: "/srv/dokuwiki/data/pages/serverlist.txt"
    check_zabbix: yes
    check_wazuh: yes
    check_rsyslog: yes
    zabbix_agent_package_name: "zabbix-agent2"
    wazuh_agent_package_name: "wazuh-agent"
  roles:
    - role: anylinq.dokuwikicmdb
```

## Tasks Overview

- Gathers package and service facts.
- Checks Zabbix Agent, Wazuh Agent, and rsyslog/journald configuration.
- Creates and reads local documentation files (`description.txt`, `notes.txt`, `changelog.txt`).
- Renders and uploads server and server list pages to DokuWiki.

## Testing

This role is tested using Molecule with the following test matrix:
  - Debian 12
  - Ubuntu 24.04

### Running Tests Locally

First, install the Python dependencies:
```bash
python -m pip install --upgrade -r requirements.txt
```

Then run the tests for specific distributions:

```bash
# For Debian 12
MOLECULE_DISTRO=debian12 molecule test

# For Ubuntu 24.04
MOLECULE_DISTRO=ubuntu2404 molecule test
```

The CI pipeline automatically tests all supported distributions.

## License

MIT

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of all notable changes to this project.

## Security

Please see our [Security Policy](SECURITY.md) for reporting vulnerabilities.

## Contributing

Please read our [Contributing Guide](CONTRIBUTING.md) and our [Code of Conduct](CODE_OF_CONDUCT.md) before submitting a Pull Request.

---

<div align="center">
Created and maintained by <a href="https://www.anylinq.com">anylinq B.V.</a><br/><br/>
<a href="https://www.anylinq.com"><img src="https://anylinq.com/hubfs/AnyLinQ%20transparant.png" width="120" alt="anylinq Logo"/></a>
</div>

---

<sub>Author: Ronny Roethof (<a href="mailto:ronny@roethof.net">ronny@roethof.net</a>)</sub>
