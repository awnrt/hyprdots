#!/bin/sh

WORKDIRECTORY=$PWD
PERMUSER="awy"

if [ "$(id -u)" -ne 0 ]
  then printf "The script has to be run as root.\n"
  exit
fi

DEPLIST="`sed -e 's/#.*$//' -e '/^$/d' dependencies.txt | tr '\n' ' '`"
pacman -Sy --noconfirm
pacman -S $DEPLIST --noconfirm

usermod -aG seat,input,audio,video $PERMUSER
doas -u $PERMUSER cp -r $WORKDIRECTORY/.config /home/$PERMUSER
doas -u $PERMUSER cp -r $WORKDIRECTORY/.local /home/$PERMUSER
doas -u $PERMUSER cp -a $WORKDIRECTORY/.zprofile /home/$PERMUSER

doas -u $PERMUSER mkdir -p /home/$PERMUSER/.cache/lf
doas -u $PERMUSER mkdir -p /home/$PERMUSER/.cache/zsh
doas -u $PERMUSER mkdir -p /home/$PERMUSER/.local/share/themes
doas -u $PERMUSER mkdir -p /home/$PERMUSER/.local/share/icons

cd $WORKDIRECTORY
doas -u $PERMUSER curl -LO "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-yellow-standard+default.zip"
doas -u $PERMUSER unzip catppuccin-mocha-yellow-standard+default.zip
doas -u $PERMUSER mv catppuccin-mocha-yellow-standard+default catppuccin-yellow
doas -u $PERMUSER cp -r catppuccin-yellow /home/$PERMUSER/.local/share/themes

doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-yellow"
doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu'
doas -u $PERMUSER dbus-launch gsettings set org.gnome.desktop.interface font-name "Ubuntu 11"

cd $WORKDIRECTORY
doas -u $PERMUSER git clone https://github.com/zdharma-continuum/fast-syntax-highlighting
mkdir -p /usr/share/zsh/plugins
cp -rf fast-syntax-highlighting /usr/share/zsh/plugins
cd ..
rm -rf hyprdots 

doas -u $PERMUSER mkdir -p /home/$PERMUSER/.ssh
doas -u $PERMUSER mkdir -p /home/$PERMUSER/.gnupg
doas -u $PERMUSER touch /home/$PERMUSER/.ssh/config
doas -u $PERMUSER touch /home/$PERMUSER/.gnupg/gpg-agent.conf
echo 'Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"' > /home/$PERMUSER/.ssh/config
echo 'enable-ssh-support' > /home/$PERMUSER/.gnupg/gpg-agent.conf
echo 'pinentry-program /usr/bin/pinentry-curses' >> /home/$PERMUSER/.gnupg/gpg-agent.conf
rc-update add sshd default
rc-service sshd start

chsh -s /bin/zsh $PERMUSER

mkdir -p /root/.config/nvim
cat <<EOL >> /root/.config/nvim/init.vim
set title
set clipboard+=unnamedplus
set relativenumber
colorscheme vim
EOL

sed -i -e "/^#"Color"/s/^#//" /etc/pacman.conf
sed -i -e '/Color/a\ILoveCandy' /etc/pacman.conf

echo "Your linux is riced!"
