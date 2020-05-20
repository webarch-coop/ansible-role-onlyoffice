#!/usr/bin/env bash

ansible-galaxy install -r requirements.yml --force && \
  ansible-playbook onlyoffice.yml -vv

