#!/bin/sh
#update packages and install missing
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y ainstall midori matchbox-window-manager xserver-xorg x11-xserver-utils unclutter xinit git omxplayer

#install nodejs
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

#install MediaPlayerPi
cd /home/pi
git clone git@github.com:lazyzero/MediaPlayerPi.git
cd /home/pi/MediaPlayerPi
npm install

#add pi user to tty group
sudo gpasswd -a pi tty
sudo sed -i '/^exit 0/c\chmod g+rw /dev/tty?\nexit 0' /etc/rc.local

#only local login starts the run script. Not ssh login
echo '
if [ -z "${SSH_TTY}" ]; then
  xinit ~/MediaPlayerPi/run.sh
fi'  >> /home/pi/.bashrc

sudo wget https://raw.githubusercontent.com/lazyzero/MediaPlayerPiInit/master/autologin.conf -O /etc/systemd/system/getty@tty1.service.d/autologin.conf
sudo systemctl enable getty@tty1.service
