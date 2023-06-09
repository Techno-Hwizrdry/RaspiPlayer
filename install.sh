#!/usr/bin/env bash

#pi-radio installation
clear
# Install dependencies
echo "Installing ffmpeg, imagemagick,"
echo "jq, mpc, mpd, and sxiv..."
echo "==============================="
sudo apt install mpd mpc ffmpeg sxiv imagemagick jp -y

echo "Installing Kunst..."
echo "==================="
sudo git clone https://github.com/sdushantha/kunst
cd kunst
sudo make install
cd ..
sudo rm -fr kunst

#create playlists
echo "Generating Playlists:"
echo "====================="
echo ""
sudo touch /var/lib/mpd/playlists/Radio.m3u

#build sample internet radio playlist

cat <<EOF > /var/lib/mpd/playlists/Radio.m3u

http://airspectrum.cdnstream1.com:8018/1606_192
http://uk3.internet-radio.com:8198/
http://wbez.ord.streamguys1.com/wbez128.mp3
http://relay3.slayradio.org:8000/
http://bigrradio-edge1.cdnstream.com/5106_128
http://s1.distortionradio.com/absolute-alternative-64
http://c10icy.prod.playlists.ihrhls.com/4846_icy
http://c5icy.prod.playlists.ihrhls.com/857_icy
http://c5icy.prod.playlists.ihrhls.com/849_icy
http://hyades.shoutca.st:8400/stream

EOF

# create shortcut on desktop

echo "Creating Desktop shortcut:"
echo "==========================" 
echo ""
touch Piradio.desktop
cat <<EOF > Piradio.desktop
#!/usr/bin/bash
[Desktop Entry]
Name=Radio
Type=Application
Exec=lxterminal -t "Radio" --working-directory=$HOME/RaspiPlayer/ -e ./radio.sh $USER
Icon=$HOME/RaspiPlayer/icon.png
Comment=test
Terminal=true
EOF

sudo chmod +x Piradio.desktop
sudo mv Piradio.desktop $HOME/Desktop

echo "Make files executible:"
echo "======================"
echo ""
sudo chmod +x *.sh

echo "Move kunst-run.sh to init.d:"
echo "and run at boot"
echo "============================"
echo ""
sudo cp kunst-run.sh /etc/init.d/
sudo chmod +x /etc/init.d/kunst-run.sh
sudo update-rc.d kunst-run.sh defaults

echo "Make backup of mpd.conf and create new:"
echo "======================================="
echo ""
sudo mv /etc/mpd.conf /etc/mpd.bak
sudo cat <<EOF > /etc/mpd.conf
# created by RaspiPlayer
# An example configuration file for MPD.
# Files and directories #######################################################
#
music_directory		"/mnt/usbdrive"
playlist_directory	"/var/lib/mpd/playlists"
db_file			"/var/lib/mpd/database"
log_file		"/var/log/mpd/mpd.log"
pid_file		"/run/mpd/pid"
state_file		"/var/lib/mpd/state"
sticker_file            "/var/lib/mpd/sticker.sql"
# General music daemon options ################################################
user			"mpd"
bind_to_address		"localhost"
# Input #######################################################################
input {
        plugin "curl"
}
# Audio Output ################################################################
audio_output {
       type            "pulse"
       name            "BTS0011"
       server          "127.0.0.1"
       mixer_type      "software"
}
#
filesystem_charset		"UTF-8"
id3v1_encoding			"UTF-8"

EOF

sudo cp etc/pulse/default.pa /etc/pulse/
pulseaudio --kill
pulseaudio --start
sudo systemctl restart mpd
source install_touchscreen_right_click.sh $USER