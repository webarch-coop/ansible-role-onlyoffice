#!/usr/bin/env bash

ansible-galaxy install -r requirements.yml --force && \
  ansible-playbook root.yml -v

