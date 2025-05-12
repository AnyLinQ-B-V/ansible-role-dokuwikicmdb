# Ansible Role: dokuwikicmdb

[![CI](https://github.com/anylinq-B-V/ansible-role-dokuwikicmdb/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/anylinq-B-V/ansible-role-dokuwikicmdb/actions/workflows/ci.yml)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

## Overview

This Ansible role creates and manages a Configuration Management Database (CMDB) in [DokuWiki](https://www.dokuwiki.org/). It collects system information from your servers, generates documentation files locally, and updates DokuWiki pages with server details, monitoring agent status, and logging configuration.

## Requirements

- Ansible 2.9 or higher.
- Target systems should be Linux (tested on EL, Debian, Ubuntu derivatives).
- DokuWiki instance accessible via SSH (for file upload).
- Python 3 on the Ansible control node.

## Role Variables

Available variables are listed in `defaults/main.yml`. Key variables include:

- `check_zabbix`: Set to `yes` to enable Zabbix agent checks and documentation (default: `no`).
- `check_wazuh`: Set to `yes` to enable Wazuh agent checks and documentation (default: `no`).
- `check_rsyslog`: Set to `yes` to enable rsyslog/journald checks and documentation (default: `no`).

- `zabbix_agent_package_name`: Name of the Zabbix agent package (e.g., "zabbix-agent2").
- `zabbix_agent_service_name`: Name of the Zabbix agent service (e.g., "zabbix-agent2.service").
- `zabbix_agent_conf_file`: Path to the Zabbix agent configuration file.

- `wazuh_agent_package_name`: Name of the Wazuh agent package.
- `wazuh_agent_service_name`: Name of the Wazuh agent service.
- `wazuh_agent_conf_file`: Path to the Wazuh agent configuration file.

- `graylog_rsyslog_conf_file`: Path to Graylog-specific rsyslog configuration.
- `journald_conf_file`: Path to journald configuration file.
- `rsyslog_imjournal_conf_file`: Path to rsyslog imjournal module configuration.

See [`defaults/main.yml`](defaults/main.yml) for all variables.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: servers
  become: true
  vars:
    check_zabbix: yes
    check_wazuh: yes
    check_rsyslog: yes
    zabbix_agent_package_name: "zabbix-agent2"
    wazuh_agent_package_name: "wazuh-agent"
  roles:
    - role: anylinq.dokuwikicmdb
```

## Testing

This role is tested using Molecule with the following test matrix:
  - Debian 12

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
