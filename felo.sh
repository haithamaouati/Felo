#!/data/data/com.termux/files/usr/bin/bash

# Author: Haitham Aouati
# GitHub: github.com/haithamaouati

# ANSI Colors
nc="$(printf '\e[0m')"
bold="$(printf '\e[1m')"
underline="$(printf '\e[4m')"
bold_green="$(printf '\e[1;32m')"
bold_red="$(printf '\e[1;31m')"
bold_yellow="$(printf '\e[1;33m')"

# List of packages
PACKAGES=(
  bc
  boxes
  curl
  figlet
  git
  jhead
  jq
  nano
  nnn
  pv
  unzip
  wget
  zip
)

# ASCII banner
show_banner() {
    clear
    cat <<"EOF"
 ______   ______     __         ______
/\  ___\ /\  ___\   /\ \       /\  __ \
\ \  __\ \ \  __\   \ \ \____  \ \ \/\ \
 \ \_\    \ \_____\  \ \_____\  \ \_____\
  \/_/     \/_____/   \/_____/   \/_____/
EOF
echo -e "\n ${bold}Felo${nc} — Termux package manager helper\n"
echo -e " Author: Haitham Aouati"
echo -e " GitHub: ${underline}github.com/haithamaouati${nc}"
}

# Ask to exit
return_or_exit() {
  echo
  read -r -p "Return to main menu? [y/N]: " answer
  case "$answer" in
    y|Y) return ;;
    *) exit 0 ;;
  esac
}

# Spinner function
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 $pid 2>/dev/null; do
    for i in $(seq 0 3); do
      printf "\b${spinstr:i:1}"
      sleep $delay
    done
  done
  printf "\b"
}

# Install packages
install_packages() {
  for pkg_name in "${PACKAGES[@]}"; do
    printf "${bold}[*]${nc} Installing %s ... " "$pkg_name"
    pkg install -y "$pkg_name" >/dev/null 2>&1 &
    pid=$!
    spinner $pid
    wait $pid
    echo -e "${bold_green}[✓]${nc} Installed."
  done
  return_or_exit
}

# Update packages
update_upgrade() {
  echo -e "${bold}[*]${nc} Updating packages ..."
  pkg update -y >/dev/null 2>&1 &
  pid=$!
  spinner $pid
  wait $pid
  echo -e "${bold_green}[✓]${nc} Packages updated."

  echo -e "${bold}[*]${nc} Upgrading packages ..."
  pkg upgrade -y >/dev/null 2>&1 &
  pid=$!
  spinner $pid
  wait $pid
  echo -e "${bold_green}[✓]${nc} Packages upgraded."

  return_or_exit
}

# Uninstall packages
uninstall_packages() {
  for pkg_name in "${PACKAGES[@]}"; do
    printf "${bold}[*]${nc} Uninstalling %s ... " "$pkg_name"
    pkg uninstall -y "$pkg_name" >/dev/null 2>&1 &
    pid=$!
    spinner $pid
    wait $pid
    echo -e "${bold_green}[✓]${nc} Packages uninstalled."
  done
  return_or_exit
}

# Main menu
while true; do
  clear
  show_banner
  echo -e "\n${bold}Main menu${nc}\n"
  echo -e "[1] Install"
  echo -e "[2] Update & Upgrade"
  echo -e "[3] Uninstall"
  echo -e "[4] ${bold_red}Quit${nc}"
  echo
  read -r -p "Select option (1-4): " choice

  case "$choice" in
    1) install_packages ;;
    2) update_upgrade ;;
    3) uninstall_packages ;;
    4) exit 0 ;;
    *) continue ;;
  esac
done
