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
  docker-ce-cli
  gtk3-devel
  pass
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
  org.onlyoffice.desktopeditors
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
  sudo hostnamectl set-hostname $host
}

dnf_update(){
  sudo dnf upgrade -y --refresh
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

system_update(){
  sudo dnf upgrade -y
}

vscode(){
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install -y code
}

## Package Install

install_codecs(){
  sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
  sudo dnf groupupdate -y sound-and-video
}

notion_enhanced(){
  sudo cp notion-repackaged.repo /etc/yum.repos.d/
  sudo dnf install -y notion-app-enhanced
}

install_usr_pkg(){
  echo "INSTALLING USER PACKAGES"
  for program in ${usr_pkg[@]}; do
    if ! rpm -qa | grep -q $program  ; then
      sudo dnf install -y $program
    else
      echo "INSTALLED: $program"
    fi
  done
}

install_sys_pkg(){
  echo "INSTALLING SYSTEM PACKAGES"
  for program in ${sys_pkg[@]}; do
    if ! rpm -qa | grep -q $program  ; then
      sudo dnf install -y $program
    else
      echo "INSTALLED: $program"
    fi
  done
}

install_wm_pkg(){
  echo "INSTALLING WINDOW MANAGER PACKAGES"
  for program in ${wm_pkg[@]}; do
    if ! rpm -qa | grep -q $program ; then
      sudo dnf install -y $program
    else
      echo "INSTALLED: $program"  
    fi
  done
}

install_wrk_pkg(){
  echo "INSTALLING WORK PACKAGES"
  for program in ${wrk_pkg[@]}; do
    if ! rpm -qa | grep -q $program ; then
      sudo dnf install -y $program
    else
      echo "INSTALLED: $program"
    fi
  done
}

install_docker(){
  sudo dnf -y install dnf-plugins-core
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

install_flatpak(){
  for program in ${flatpaks[@]}; do
    if ! flatpak list | grep -q $program ; then
      sudo flatpak install -y $program
    else
      echo "INSTALLED: $program"
    fi
  done
}

## Packages Config (awesome/qtile, backup restore)
wm_config(){
  git clone --bare https://github.com/nanoesouza/wm.git
}
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
install_sys_pkg
install_usr_pkg
install_wrk_pkg
install_wm_pkg
install_docker
install_flatpak
wm_config

## TODO
# Dotfiles (Clone as bare repo, set up the aliases, checkout to the config)