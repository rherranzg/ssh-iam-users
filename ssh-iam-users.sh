#!/bin/bash

aws iam list-users --query "Users[].[UserName]" --output text | while read User; do
  if id -u "$User" >/dev/null 2>&1; then
    echo "$User exists"
    /opt/authorized_keys_command.sh $User > /home/$User/.ssh/authorized_keys
  else
    aws iam list-groups-for-user --user-name $User | jq ".Groups"[$i]".GroupName" | grep -E "^\"ssh-users\W$"
    if [ $? == 0 ]; then
        echo "Añado al usuario $User al sistema"
        /usr/sbin/adduser "$User" --home "/home/$User"
        mkdir /home/$User/.ssh
        chown $User:$User /home/$User/ -R
        cleanuser=`echo $User | sed "s/\.//g"`
        echo "$User ALL = NOPASSWD: ALL" > "/etc/sudoers.d/$cleanuser"
        echo "$User ALL=(ALL) NOPASSWD:ALL" >> "/etc/sudoers.d/$cleanuser"
        /opt/authorized_keys_command.sh $User > /home/$User/.ssh/authorized_keys
    else
        echo "El usuario $User no pertenece al grupo ssh-users"
    fi
  fi
done

