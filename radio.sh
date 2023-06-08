#!/usr/bin/env bash
#radio.sh
if [ -z "$1" ]
then
    echo "usage: $0 USERNAME_HERE"
else
    sudo python player25.py -m /home/$1/Music/
fi