#!/bin/bash -x


## Variables
host='workstation'

sys_pkg=(
  alacritty
  kitty
  ripgrep
  parallel
  pwgen
  git
  ranger
  vim
  python3-neovim
  dejavu-fonts-all
  jetbrains-mono-fonts-all
  fira-code-fonts
  mozilla-fira-fonts-common
  bat
  exa
  shellcheck
  fish
  zsh
  fd-find
  git-crypt
  tldr
  z
  nmap
  sshpass
  python3-pip
  strace
  htop
  bpytop
  awscli
  android-tools
  neofetch
  gparted
  barrier

)

usr_pkg=(
  kvantum
  latte-dock
  steam
  discord
  easyeffects
  vlc
  deja-dup
  thunderbird
  qbittorrent
  bottles
)

wm_pkg=(
  nitrogen
  rofi
  dunst
  redshift
  brightnessctl
  lxappearance-gtk3
  flameshot
  i3lock
  picom
  julietaula-montserrat
  awesome
)

wrk_pkg=(
  ansible
  ansible-lint
  virtualbox
  vagrant
  python3-virtualenv
  python3-virtualenvwrapper
  remmina
  remmina-plugins-rdp
  remmina-plugins-vnc
)

flatpaks=(
  com.bitwarden.desktop
  com.mattermost.Desktop
  com.brave.Browser
  com.anydesk.Anydesk
  md.obsidian.Obsidian
)

rpms=(
  'https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm'
  'https://desktop.docker.com/linux/main/amd64/docker-desktop-4.10.1-x86_64.rpm?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64'
)


## Sudo Config
sudo_config(){
  sudo sed -i '110s/# %wheel/%wheel/' /etc/sudoers
  sudo sed -i '107s/%wheel/#%wheel/' /etc/sudoers
}

## DNF Settings
dnf_tweaks(){
  echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
  echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
  echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
  echo 'defaultyes=True' | sudo tee -a /etc/dnf/dnf.conf
  dnf clean all
}

enable_fusion(){
 sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
 sudo dnf groupupdate core -y
}

## General Config (user/system)
set_hostname(){
  hostnamectl set-hostname $host
}

dnf_update(){
  sudo dnf upgrade --refresh
  sudo dnf check -y
  sudo dnf autoremove -y
  sudo fwupdmgr get-devices
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-updates
  sudo fwupdmgr update
}

flathub(){
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

install_codecs(){
  sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
  sudo dnf groupupdate -y sound-and-video
}

notion_enhanced(){
  sudo echo  "[notion-repackaged]\
              name=notion-repackaged\
              baseurl=https://yum.fury.io/notion-repackaged/\
              enabled=1\
              gpgcheck=0" >> /etc/yum.repos.d/notion-repackaged.repo
  
  sudo dnf install notion-app-enhanced
}

vscode(){
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install -y code
}

## Package Install
system_update(){
  sudo dnf upgrade -y
}

install_usr_pkg(){
  sudo dnf install -y $usr_pkg
}
## Packages Config (awesome/qtile, backup restore)

sudo_config
dnf_tweaks
enable_fusion
set_hostname
dnf_update
flathub
install_codecs
system_update
notion_enhanced
vscode
install_usr_pkg

## TODO
# Dotfiles (Clone as bare repo, set up the aliases, checkout to the config)