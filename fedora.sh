#!/bin/bash

## Variables
host='workstation'
fusion='https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-36.noarch.rpm'
fusion-non='https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-36.noarch.rpm'

## DNF Settings
dnf_tweaks(){
  echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
  echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
  echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
  echo 'defaultyes=True' | sudo tee -a /etc/dnf/dnf.conf
  dnf clean all
}

enable_fusion(){
 sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
 sudo dnf groupupdate core
}

## General Config (user/system)
hostname(){
  hostnamectl set-hostname $host
}

dnf_update(){
  sudo dnf upgrade --refresh
  sudo dnf check
  sudo dnf autoremove
  sudo fwupdmgr get-devices
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-updates
  sudo fwupdmgr update
  sudo reboot now
}

flathub(){
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

## Package Install
## Packages Config (awesome/qtile, backup restore)
