#!/bin/bash
function sudocheck () {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER or as ROOT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  else
    updatesystem
  fi
}

function updatesystem() {
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  This can take a while
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
updateall
uppercut
gcloudup
rclone
}
function updateall() {
package_list="update upgrade dist-upgrade autoremove autoclean"
for i in ${package_list}; do
    sudo apt $i -yqq 1>/dev/null 2>&1
    echo "$i is running , please wait"
    sleep 1
done
}

function uppercut() {
ansiv=$(ansible --version | head -n1 | awk '{print $2}')
if [[ "$ansiv" -lt "2.10" ]]; then
   pip uninstall ansible 1>/dev/null 2>&1
   pip install ansible-base 1>/dev/null 2>&1
   pip install ansible 1>/dev/null 2>&1
   python3 -m pip install ansible 1>/dev/null 2>&1
fi
}

function gcloudup() {
gcloudversion=$(gcloud --version | head -n1 | awk '{print $4}')
if [[ "$gcloudversion" -lt "307" ]]; then
   curl https://sdk.cloud.google.com > /tmp/install.sh
   export CLOUDSDK_CORE_DISABLE_PROMPTS=1
   if [[ -d "/root/google-cloud-sdk" ]]; then
      rm -rf /root/google-cloud-sdk
   fi
   bash /tmp/install.sh --disable-prompts
   rm -f /tmp/install.sh
fi
}

function rclone() {
  curl -fsSL https://raw.githubusercontent.com/mrfret/misc/master/rcupdate.sh | sudo bash
}

sudocheck

