#!/bin/bash
#user_data will get sudo access

dnf install ansible -y
cd /tmp
git clone https://github.com/JDdaws78s/expense-ansible.git
cd expense-ansible
ansible-playbook -i inventory.ini -e login_password=ExpenseApp1 backend.yaml
ansible-playbook -i inventory.ini frontend.yaml