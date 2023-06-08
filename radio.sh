#!/usr/bin/env bash
#radio.sh
if [ -z "$1" ]; then
    echo "usage: $0 USERNAME_HERE"
    exit 1
fi
sudo python player25.py -m /home/$1/Music/