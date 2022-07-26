#!/bin/bash -x


## Variables
host='workstation'

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
  sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
  sudo dnf groupupdate sound-and-video
}

## Package Install
## Packages Config (awesome/qtile, backup restore)

sudo_config
dnf_tweaks
enable_fusion
set-_hostname
dnf_update
flathub
install_codecs
