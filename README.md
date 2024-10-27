# Webarchitects ONLYOFFICE Document Server Ansible Role

[![pipeline status](https://git.coop/webarch/onlyoffice/badges/master/pipeline.svg)](https://git.coop/webarch/onlyoffice/-/commits/master)

This Ansible role is based on the instructions for [Installing ONLYOFFICE Docs Community Edition for Debian, Ubuntu, and derivatives](https://helpcenter.onlyoffice.com/installation/docs-community-install-ubuntu.aspx).

## Usage

This role can be used to configure a stand-alone ONLYOFFICE Document Server that uses Nginx and PostgreSQL or it can be used to install ONLYOFFICE Document Server on a LAMP server with Apache providing a reverse proxy service to Nginx and MariaDB / MySQL being used as the database.

There is a [development repo available here](https://git.coop/webarch/nextcloud-server) that builds a Nextcloud server with ONLYOFFICE using this role.

This role checks the [latest releases](https://github.com/ONLYOFFICE/DocumentServer/releases) available at GitHub and required the full version string for `apt` package for the `onlyoffice_docserver_version` variable, a list of these can be found in [vars/main.yml](vars/main.yml).

## Role variables

See the [defaults/main.yml](defaults/main.yml) file for the default variables, the [vars/main.yml](vars/main.yml) file for the preset variables and the [meta/argument_specs.yml](meta/argument_specs.yml) file for the variable specification.

### onlyoffice

A boolean, set `onlyoffice` to `true` for the tasks in this role to be run, it defaults to `false`.

### onlyoffice_db_port

The port number of the database server, quoted so it is a string, defaults to the default MariaDB / MySQL port, `"3306"`, if PostgreSQL is used with the default port then `onlyoffice_db_port` should be set to `"5432"`.

### onlyoffice_db_type

The database type, a lowercase string, defaults to `mariadb`, set to `postgres` for PostgreSQL.

### onlyoffice_debconf

A list of [debconf options for ONLYOFICE](https://helpcenter.onlyoffice.com/installation/docs-community-install-ubuntu.aspx#moreOptions) to be applied using the [Ansible ansible.builtin.debconf module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debconf_module.html), for example:

```yaml
onlyoffice_debconf:
  - name: onlyoffice-documentserver
    question: onlyoffice/cluster-mode
    value: false
    vtype: boolean
```

The four required variables for each list item:

#### name

A string, the name of the package to configure, for all items in the list this is set to `onlyoffice-documentserver`.

#### question

A string, the debconf question.

#### value

A string, the value to set for the debconf question.

#### vtype

A string, the type of the value.

### onlyoffice_documentserver_version

The version of the `onlyoffice-documentserver` Debian package to be installed and pinned. This is set to prevent updates breaking production servers as this role sometimes needs updating for new versions of ONLYOFFICE.

### onlyoffice_docservice_host

The hostname used by Nginx to reverse proxy to.

### onlyoffice_docservice_port

The port used by Nginx to reverse proxy to.

### onlyoffice_ds_host

The Nginx hostname.

### onlyoffice_ds_port

The port number, quoted so it is string, that Nginx should make ONLYOFFICE available on, `onlyoffice_ds_port` defaults to `443`, set it to another port if a reverse proxy is to be used in front of Nginx.

### onlyoffice_local

A YAML dictionary, which will be converted to JSON and written to `/etc/onlyoffice/documentserver/local.json`.

ONLYOFFICE will merge the configuration in `local.json` with the configuration from `/etc/onlyoffice/documentserver/default.json` &mdash; this file contains the default configuration.

### onlyoffice_mariadb_socket

The path to the MariaDB socket, defaults to `/run/mysqld/mysqld.sock`.

### onlyoffice_nginx_localhost

Add Nginx configuration for the ONLYOFFICE info to be available, `onlyoffice_nginx_localhost` defaults to `true`.

### onlyoffice_nginx_localhost_domain

Domain name for the ONLYOFFICE info to be available on, `onlyoffice_nginx_localhost_domain` defaults to `localhost`.

### onlyoffice_nginx_localhost_port

Port for the ONLYOFFICE info to be available on, `onlyoffice_nginx_localhost_port` defaults to `82`.

### onlyoffice_nginx_sites_disabled

A list of disabled Nginx sites.

### onlyoffice_nginx_sites_enabled

A list of enabled Nginx sites.

### onlyoffice_rabbitmq_host

The RabbitMQ host, defaults to `localhost`.

### onlyoffice_ssl_certificate

A string, the path to the TLS fullchain certificate for HTTPS.

### onlyoffice_ssl_certificate_key

A string, the path to the TLS private key for HTTPS.

### onlyoffice_verify

A boolean, `onlyoffice_verify` defaults to `true` set it to false to skip the role using the [ansible.builtin.validate_argument_spec module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/validate_argument_spec_module.html) to verify variables that start with `onlyoffice_`.

### onlyoffice_wopi

Action to take if the WOPI is defined in the existing ONLYOFFICE Document Server `local.json` config but not the proposed config, defaults to `fail`, the Molecule tests use `ignore`.

## Upgrading from Debian Buster to Bullseye

After upgrading the Debian PostgreSQL needs to be upgraded:

```bash
pg_dropcluster --stop 13 main
pg_upgradecluster 11 main
apt remove postgresql-11 postgresql-client-11
```

### Check the debconf settings

```bash
debconf-show onlyoffice-documentserver
* onlyoffice/db-pwd: (password omitted)
* onlyoffice/rabbitmq-pwd: (password omitted)
* onlyoffice/jwt-secret: (password omitted)
* onlyoffice/db-port: 3306
* onlyoffice/jwt-enabled: true
* onlyoffice/db-host: localhost
* onlyoffice/rabbitmq-proto: amqp
* onlyoffice/ds-port: 8080
* onlyoffice/rabbitmq-user: onlyoffice
* onlyoffice/rabbitmq-host: localhost
* onlyoffice/jwt-header: AuthorizationJwt
* onlyoffice/db-name: onlyoffice
* onlyoffice/example-port: 3000
* onlyoffice/db-type: mariadb
* onlyoffice/db-user: onlyoffice
* onlyoffice/cluster-mode: false
* onlyoffice/remove-db: false
* onlyoffice/docservice-port: 8000
```

## Ports

The default settings for this role result in Nginx listening on port 443 reverse proxying to ONLYOFFICE on port 8000.

If another web server is already listening on 443, for example Apache, then you can run Nginx on port 8080 and configure Apache as a reverse proxy to Nginx, for example:

```apache
  <IfModule proxy_module>
    ProxyRequests Off
    ProxyAddHeaders Off
    ProxyPassMatch "(.*)(\/websocket)$" "ws://127.0.0.1:8080/$1$2"
    ProxyPass "/" "http://127.0.0.1:8080/"
    ProxyPassReverse "/" "http://127.0.0.1:8080/"
  </IfModule>
```

## References

* [Installing ONLYOFFICE Docs Community Edition for Debian, Ubuntu, and derivatives](https://helpcenter.onlyoffice.com/installation/docs-community-install-ubuntu.aspx)
* [Switching ONLYOFFICE Docs to HTTPS protocol](https://helpcenter.onlyoffice.com/installation/docs-community-https-linux.aspx)
* [Ports which must be opened for ONLYOFFICE Docs](https://helpcenter.onlyoffice.com/installation/docs-community-open-ports.aspx)
* [ONLYOFFICE Document Server example configurations for proxy](https://github.com/ONLYOFFICE/document-server-proxy)
* [Nextcloud ONLYOFFICE integration app](https://api.onlyoffice.com/editors/nextcloud)
* [ONLYOFFICE Api Documentation - Signature](https://api.onlyoffice.com/editors/signature/)
* [ONLYOFFICE Web Application Open Platform Interface Protocol (WOPI)](https://api.onlyoffice.com/editors/wopi/)

## Repository

The primary URL of this repo is [`https://git.coop/webarch/onlyoffice`](https://git.coop/webarch/onlyoffice) however it is also [mirrored to GitHub](https://github.com/webarch-coop/ansible-role-onlyoffice) and [available via Ansible Galaxy](https://galaxy.ansible.com/chriscroome/onlyoffice).

If you use this role please use a tagged release, see [the release notes](https://git.coop/webarch/onlyoffice/-/releases).

This role has been renamed from `onlyoffice-documentserver` to `onlyoffice` and also the repository has been moved, it was at `https://git.coop/webarch/onlyoffice-documentserver` but is now at `https://git.coop/webarch/onlyoffice` and the (not working) repo that was at this URL has been archived at `https://git.coop/webarch/onlyoffice_docker`.

## Copyright

Copyright 2020-2024 Chris Croome, &lt;[chris@webarchitects.co.uk](mailto:chris@webarchitects.co.uk)&gt;.

This role is released under [the same terms as Ansible itself](https://github.com/ansible/ansible/blob/devel/COPYING), the [GNU GPLv3](LICENSE).
