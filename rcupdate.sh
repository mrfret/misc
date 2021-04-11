#!/bin/bash
function badinput() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
}
function rclone_update_stable() {
curl https://rclone.org/install.sh | sudo bash
}
function rclone_update_beta() {
curl https://rclone.org/install.sh | sudo bash -s beta
}
function sudocheck() {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  fi
}

function updateall() {
package_list="update upgrade dist-upgrade autoremove autoclean "
for i in ${package_list}; do
    sudo apt $i -yqq 1>/dev/null 2>&1
    echo "$i is running , please wait"
    sleep 1
done
}
function killmergerfs() {
if [[ $(command -v mergerfs) != "" ]]; then
   sudo apt-get purge mergerfs -yqq 1>/dev/null 2>&1
fi
}
function rcloneupdate() {
      tee <<-EOF
━━━━━━━━━━━━━━━━━━
 rClone Update Panel
━━━━━━━━━━━━━━━━━━

Update to STABLE = [ S / s ]
Update to BETA   = [ B / b ]

[ Z / z ] = Exit

━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type .... and press [ENTER]: ' typed </dev/tty

  case $typed in
  S) rclone_update_stable ;;
  s) rclone_update_stable ;;
  B) rclone_update_beta ;;
  b) rclone_update_beta ;;
  z) clear && exit ;;
  Z) clear && exit ;;
  *) badinput ;;
  esac
}

function update() {

sudocheck
killmergerfs
updateall
rcloneupdate
}

update
