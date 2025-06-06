# Ansible Role: DokuWiki CMDB

[![CI](https://github.com/AnyLinQ-B-V/ansible-role-dokuwikicmdb/actions/workflows/ci.yml/badge.svg)](https://github.com/AnyLinQ-B-V/ansible-role-dokuwikicmdb/actions/workflows/ci.yml)
[![Ansible Galaxy](https://img.shields.io/ansible/role/d/anylinq/dokuwikicmdb)](https://galaxy.ansible.com/anylinq/dokuwikicmdb)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This Ansible role gathers information from managed hosts and generates CMDB (Configuration Management Database) pages in a DokuWiki instance. It also creates a server list page for easy navigation.

## Features

*   Collects basic system information (OS, kernel, hardware, network).
*   Collects filesystem mount information.
*   Allows for local, server-specific documentation (`description.txt`, `notes.txt`, `changelog.txt`) to be included on DokuWiki pages.
*   Generates a DokuWiki page for each managed host.
*   Generates an overview server list page in DokuWiki with key details.
*   Optional checks for:
    *   Zabbix agent status.
    *   Wazuh agent status.
    *   Rsyslog configuration (forwarding to Graylog, journald integration).
    *   NTP client status and configured servers.
    *   Realmd (domain join) status and details.

## Requirements

*   Ansible 2.10 or higher.
*   A DokuWiki instance accessible from the Ansible controller.
*   SSH access from the Ansible controller to the DokuWiki server (for `delegate_to`).
*   The DokuWiki server must have write permissions for the `dokuwiki_user` to the `dokuwiki_data_root_path`.

## Supported Platforms

*   Debian (Bookworm, Trixie)
*   Ubuntu (Jammy, Noble)
*   EL (RHEL/Rocky 9)

Other Linux distributions might work but are not actively tested.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

### DokuWiki Configuration

These variables control how the role interacts with your DokuWiki instance.

| Variable                          | Default                                  | Description                                                                                                |
| --------------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `dokuwiki_targetserver`           | `your_dokuwiki_server_hostname_or_ip`    | **Required.** Hostname or IP address of the DokuWiki server.                                               |
| `dokuwiki_data_root_path`         | `/srv/dokuwiki/data/pages`               | Base path to DokuWiki's `pages` directory on the DokuWiki server.                                          |
| `dokuwiki_server_pages_namespace` | `servers`                                | DokuWiki namespace where individual server pages will be created (e.g., `servers` or `cmdb:nodes`).        |
| `dokuwiki_serverlist_page_fqn`    | `serverlist`                             | Fully qualified DokuWiki page name for the server list (e.g., `serverlist` or `cmdb:overview:serverlist`). |
| `dokuwiki_user`                   | `www-data`                               | User that owns DokuWiki files on the DokuWiki server.                                                      |
| `dokuwiki_group`                  | `www-data`                               | Group for DokuWiki files on the DokuWiki server.                                                           |

### Local Documentation Files

These variables define where local documentation files are stored on each managed host. The content of these files will be included in the DokuWiki page for that host.

| Variable                             | Default                        | Description                                                                          |
| ------------------------------------ | ------------------------------ | ------------------------------------------------------------------------------------ |
| `dokuwiki_local_destination`         | `/opt/ansible_server_docs`     | Path on managed hosts where `description.txt`, `notes.txt`, `changelog.txt` are stored. |
| `dokuwiki_local_destination_user`  | `root`                         | Owner of the local documentation files.                                              |
| `dokuwiki_local_destination_group` | `root`                         | Group of the local documentation files.                                              |

### Optional Checks

Set these variables to `"yes"` or `"true"` to enable the corresponding checks.

| Variable                  | Default | Description                                  |
| ------------------------- | ------- | -------------------------------------------- |
| `check_zabbix`            | `yes`   | Enable Zabbix agent checks.                  |
| `check_wazuh`             | `no`    | Enable Wazuh agent checks.                   |
| `check_rsyslog`           | `yes`   | Enable Rsyslog configuration checks.         |
| `check_ntp`               | `yes`   | Enable NTP client checks.                    |
| `check_realmd`            | `yes`   | Enable Realmd (domain join) checks.          |

### Agent/Service Specific Variables

These variables are used if the corresponding `check_*` variable is enabled.

**Zabbix:**
*   `zabbix_agent_package_name`: "zabbix-agent2"
*   `zabbix_agent_service_name`: "zabbix-agent2.service"
*   `zabbix_agent_conf_file`: "/etc/zabbix/zabbix_agent2.conf"

**Wazuh:**
*   `wazuh_agent_package_name`: "wazuh-agent"
*   `wazuh_agent_service_name`: "wazuh-agent"
*   `wazuh_agent_conf_file`: "/var/ossec/etc/ossec.conf"

**Rsyslog:**
*   `graylog_rsyslog_conf_file`: "/etc/rsyslog.d/99-graylog.conf"
*   `journald_conf_file`: "/etc/systemd/journald.conf"
*   `rsyslog_imjournal_conf_file`: "/etc/rsyslog.d/00-journalctl.conf"

### Debugging

| Variable                    | Default | Description                                                                 |
| --------------------------- | ------- | --------------------------------------------------------------------------- |
| `dokuwikicmdb_debug_checks` | `yes`   | Set to `true` to enable detailed debug output for the various checks.       |

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  become: true
  vars:
    dokuwiki_targetserver: "your-dokuwiki.example.com"
    dokuwiki_server_pages_namespace: "cmdb:servers"
    dokuwiki_serverlist_page_fqn: "cmdb:server_overview"
    check_wazuh: "yes"
    check_rsyslog: "no"
    dokuwikicmdb_debug_checks: false
  roles:
    - role: anylinq.dokuwikicmdb
```

**Explanation of the example:**

1.  **`hosts: all`**: This playbook will run on all hosts defined in your inventory.
2.  **`become: true`**: The role needs root privileges on managed hosts to gather certain facts and create local documentation directories.
3.  **`vars`**:
    *   `dokuwiki_targetserver`: **You must change this** to the hostname or IP of your DokuWiki server.
    *   `dokuwiki_server_pages_namespace`: Server pages will be created under the `cmdb:servers` namespace in DokuWiki (e.g., `yourwiki/doku.php?id=cmdb:servers:yourhostname`).
    *   `dokuwiki_serverlist_page_fqn`: The server list page will be `cmdb:server_overview` (e.g., `yourwiki/doku.php?id=cmdb:server_overview`).
    *   `check_wazuh: "yes"`: Enables the Wazuh agent checks.
    *   `check_rsyslog: "no"`: Disables the Rsyslog checks.
    *   `dokuwikicmdb_debug_checks: false`: Disables the extra debug output from the role's checks.
4.  **`roles`**:
    *   `role: anylinq.dokuwikicmdb`: Includes this role.

### Local Documentation Files

On each managed host, the role will look for the following files in the directory specified by `dokuwiki_local_destination` (default: `/opt/ansible_server_docs`):

*   `description.txt`: A general description of the server.
*   `notes.txt`: Any specific notes or important information about the server.
*   `changelog.txt`: A log of changes made to the server.

If these files do not exist, the role will create empty ones (except for `description.txt` which gets a default template). You can then populate them with relevant information. The content of these files will be embedded into the DokuWiki page for that server.

## DokuWiki Output

*   **Server Pages**: For each host, a page will be created (e.g., `servers:hostname.txt`). This page will contain:
    *   Server Description (from `description.txt`)
    *   Server Notes (from `notes.txt`)
    *   Hardware/Virtualization details
    *   Operating System details
    *   Network details
    *   Filesystem Mounts
    *   Results of enabled checks (Zabbix, Wazuh, Rsyslog, NTP, Realmd)
    *   Server Changelog (from `changelog.txt`)
*   **Server List Page**: A page (e.g., `serverlist.txt`) will be created with a table listing all managed servers, their OS, kernel, and domain join status (if `check_realmd` is enabled).

## License

MIT

## Author Information

This role was created in 2025 by Ronny Roethof for AnyLinQ B.V..

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check issues page.