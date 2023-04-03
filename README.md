# Webarchitects ONLYOFFICE Document Server Ansible Role

[![pipeline status](https://git.coop/webarch/onlyoffice/badges/master/pipeline.svg)](https://git.coop/webarch/onlyoffice/-/commits/master)

This Ansible role is based on the instructions for [Installing Document Server for Linux on Debian, Ubuntu and derivatives](https://helpcenter.onlyoffice.com/server/linux/document/linux-installation.aspx).

The ONLYOFFICE code is [available on GitHub under the AGPL](https://github.com/ONLYOFFICE/DocumentServer).

There is a [development repo available here](https://git.coop/webarch/nextcloud-server) that builds a ONLYOFFICE server using this role.


## References

* [Installing ONLYOFFICE Docs Community Edition for Debian, Ubuntu, and derivatives](https://helpcenter.onlyoffice.com/installation/docs-community-install-ubuntu.aspx)
* [Nextcloud ONLYOFFICE integration app](https://api.onlyoffice.com/editors/nextcloud)
* [ONLYOFFICE Api Documentation - Signature](https://api.onlyoffice.com/editors/signature/)

## Upgrading from Debian Buster to Bullseye

After upgrading the Debian PostgreSQL needs to be upgraded:

```bash
pg_dropcluster --stop 13 main
pg_upgradecluster 11 main
apt remove postgresql-11 postgresql-client-11
```

## Role name and repo URL

This role has been renamed from `onlyoffice-documentserver` to `onlyoffice` and also the repository has been moved, it was at `https://git.coop/webarch/onlyoffice-documentserver` but is now at `https://git.coop/webarch/onlyoffice` and the (not working) repo that was at this URL has been archived at `https://git.coop/webarch/onlyoffice_docker`.
