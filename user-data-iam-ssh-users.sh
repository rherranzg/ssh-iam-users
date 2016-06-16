#!/bin/bash
/usr/bin/yum install -y epel-release
/usr/bin/yum install -y jq
/usr/bin/yum install -y python-pip
/usr/bin/pip install awscli
/usr/bin/aws s3 cp s3://madiva-config/ssh-iam-users/ssh-iam-users.sh /opt/
/usr/bin/aws s3 cp s3://madiva-config/ssh-iam-users/authorized_keys_command.sh /opt/
/usr/bin/chmod +x /opt/*.sh
/usr/bin/echo "*/10 * * * * root /opt/ssh-iam-users.sh" > /etc/cron.d/ssh-iam-users

