#!/bin/bash
# Second script to run for setting up hduser as hadoop datanode
# slave. Script should be run from slave host as root

echo "Setting ssh permissions"
# change ownership and permissions for ssh configuration
chown -R hduser:hduser /home/hduser/.ssh
chmod 700 /home/hduser/.ssh
chmod 600 /home/hduser/.ssh/id_rsa
cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys
chmod 600 /home/hduser/.ssh/authorized_keys

#ssh-copy-id -i ~/.ssh/id_rsa.pub master
#ssh-copy-id -i ~/.ssh/id_rsa.pub slave-1
#ssh-copy-id -i ~/.ssh/id_rsa.pub slave-2

echo "Stopping iptables"
# drop iptables / firewall
/etc/init.d/iptables stop
