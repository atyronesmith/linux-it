#!/bin/bash

sudo yum groupinstall "GNOME Desktop"
sudo yum install tigervnc-server xorg-x11-fonts-Type1

sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:3.service

cat /lib/systemd/system/vncserver@.service | sed -re 's/^([^#].*)<USER>/\1root/' \
 | sudo tee /etc/systemd/system/vncserver@:1.service > /dev/null

firewall-cmd --permanent --zone=public --add-port=5903/tcp
firewall-cmd --reload

yum install -y epel-release
yum install -y hstr

cat <<EOF >> $HOME/.bash_profile

sudo vncserver

sudo systemctl daemon-reload
sudo systemctl start vncserver@:1.service
sudo systemctl enable vncserver@:1.service
sudo ln -s '/etc/systemd/system/vncserver@:1.service' '/etc/systemd/system/multi-user.target.wants/vncserver@:1.service'

