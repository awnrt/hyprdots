WORKDIRECTORY=$PWD
PERMUSER="awy"

if [ "$EUID" -ne 0 ]
  then printf "The script has to be run as root.\n"
  exit
fi

DEPLIST="`sed -e 's/#.*$//' -e '/^$/d' dependencies.txt | tr '\n' ' '`"
pacman -Sy --noconfirm
pacman -S $DEPLIST --noconfirm

usermod -aG seat,input,audio,video $PERMUSER
doas -u $PERMUSER cp -r $WORKDIRECTORY/.config /home/$PERMUSER

doas -u $PERMUSER mkdir -p /home/$PERMUSER/.local/share/themes
doas -u $PERMUSER mkdir -p /home/$PERMUSER/.local/share/icons
doas -u $PERMUSER mkdir -p /home/$PERMUSER/.local/share/papes

cd $WORKDIRECTORY
git clone https://codeberg.org/awy/gruvbox-gtk-theme
doas -u $PERMUSER cp -r $WORKDIRECTORY/gruvbox-gtk-theme/Gruvbox-Dark /home/$PERMUSER/.local/share/themes
#doas -u $PERMUSER cp -r $WORKDIRECTORY/gruvbox-gtk-theme/Gruvbox-Icons /home/$PERMUSER/.local/share/icons
rm -rf $WORKDIRECTORY/gruvbox-gtk-theme

doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Dark"
#doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Gruvbox-Icons"
doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu'
doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.interface font-name "Ubuntu Nerd Font 11"

su - $PERMUSER -c "yes | fish $WORKDIRECTORY/fishrice"
echo "[ -x /usr/bin/fish ] && SHELL=/usr/bin/fish exec fish" >> /home/$PERMUSER/.bashrc
sudo -u $PERMUSER mkdir -p /home/$PERMUSER/.config/fish

#echo -e '\033c\e[35mwelcome to the system, master >w<\e[36m' > /etc/issue
#sed -i "s/seat\ -n\ 3/seat -n 3 -l silent/g" /etc/runit/sv/seatd/run
cd $WORKDIRECTORY
cd ..
rm -rf hyprdots
echo "Your linux is riced!"
