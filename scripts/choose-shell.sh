#!/usr/bin/env bash

BOLD='\e[1m'
GREEN='\e[92m'
YELLOW='\e[93m'
RESET='\e[0m'

print_info() {
  echo -ne "${BOLD}${YELLOW}$1${RESET}\n"
}

print_choice() {
  echo -ne "${BOLD}${GREEN}>> $1${RESET}\n\n"
}

print_info "Choose your user's default shell:"
echo "1. /bin/bash"
echo "2. /bin/fish"
echo "3. /bin/zsh"
echo "4. quit"

read -p "Enter the number of your preferred shell: " choice

case $choice in
1)
  chsh -s /bin/bash
  print_choice "Shell choice: /bin/bash"
  printf '%s\n' "If default shell was changed, you will need to logout and 
log back in for change to take effect."
  ;;
2)
  chsh -s /bin/fish
  print_choice "Shell choice: /bin/fish"
  printf '%s\n' "If default shell was changed, you will need to logout and 
log back in for change to take effect."
  ;;
3)
  chsh -s /bin/zsh
  print_choice "Shell choice: /bin/zsh"
  printf '%s' "If default shell was changed, you will need to logout and 
log back in fo\nr change to take effect."
  ;;
4)
  echo "User has chosen to quit program."
  exit 1
  ;;
*)
  echo "Invalid choice. Please try again."
  exit 1
  ;;
esac
