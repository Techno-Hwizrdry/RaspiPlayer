#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "usage: $0 USERNAME_HERE"
    exit 1
fi

sudo apt install git build-essential libevdev2 libevdev-dev -y
git clone 'git@github.com:Techno-Hwizrdry/evdev-right-click-emulation.git'
cd 'evdev-right-click-emulation'
make all
sudo cp out/evdev-rce /usr/local/bin/
sudo chmod +x /usr/local/bin/evdev-rce
sudo usermod -G 'input' -a $1
echo 'uinput' | sudo tee -a /etc/modules

sudo touch /etc/udev/rules.d/99-uinput.rules
sudo sh -c 'echo KERNEL==\"uinput\", MODE=\"0660\", GROUP=\"input\" >> /etc/udev/rules.d/99-uinput.rules'
sudo udevadm control --reload-rules
sudo udevadm trigger

mkdir -p $HOME/.config/autostart
cd $HOME/.config/autostart
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=evdev-rce
GenericName=Enable long-press-to-right-click gesture
Exec=env LONG_CLICK_INTERVAL=500 LONG_CLICK_FUZZ=50 /usr/local/bin/evdev-rce
Terminal=true
StartupNotify=false"  >> evdev-rce.desktop

echo ""
echo "Right click for touchscreen has been installed."
echo "Please reboot when you are ready."