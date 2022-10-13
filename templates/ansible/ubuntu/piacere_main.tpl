---
- hosts: localhost
  tasks:
    - name: print disclamer
      debug:
        msg: this can also be done with "ansible-galaxy install -r requirements"
    - name: install telegraf from galaxy
      community.general.ansible_galaxy_install:
        type: role
        requirements_file: ansible_requirements.yml

- hosts: all
  pre_tasks:
    - name: Ensure gnupg package
      package:
        name: gnupg
        state: present
      become: true
  vars_files:
    - vars/main.yaml
  roles:
    - dj-wasabi.telegraf