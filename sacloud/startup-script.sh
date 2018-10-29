#!/bin/bash

# @sacloud-name "sakura.io EVB dashboard"
# @sacloud-once

# @sacloud-desc sakura.io EVB dashboardをインストールします。
# @sacloud-desc sakura.io コントロールパネル上で作成したWebSocket連携サービスのTokenが必要です。
# @sacloud-desc 仕様上、サーバー1台につき1モジュールのみの表示となります。
# @sacloud-desc （このスクリプトは、Ubuntuでのみ動作します）
# @sacloud-require-archive distro-ubuntu



# @sacloud-text required shellarg minlen=36 maxlen=36 ex="websocket token" websocket_token "sakura.io WebSocket連携サービスのToken"
WEBSOCKET_TOKEN=@@@websocket_token@@@

# @sacloud-text required shellarg minlen=12 maxlen=12 ex="module ID" module_id "表示対象のsakura.ioモジュールID"
MODULE_ID=@@@module_id@@@

# @sacloud-text shellarg maxlen=5 ex=8080 integer min=80 max=65535 ui_port "Web UIポート番号"
UI_PORT=@@@ui_port@@@
${UI_PORT:=8080}

export DEBIAN_FRONTEND=noninteractive

apt-get -y update || exit 1
apt-get -y upgrade || exit 1

# Install packages to allow apt to use a repository over HTTPS
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker's apt repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker
apt-get -y update || exit 1
apt-get install -y docker-ce

# Pull dashboard image
docker pull misodengaku/sakuraio-evb-dashboard

mkdir /log
chmod 777 /log

cat <<EOF | sed -e "s/%UI_PORT%/$UI_PORT/" -e "s/%MODULE_ID%/$MODULE_ID/" -e "s/%WEBSOCKET_TOKEN%/$WEBSOCKET_TOKEN/" > /etc/systemd/system/sakuraio-evb-dashboard.service
[Unit]
Description=sakura.io EVB dashboard
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop misodengaku/sakuraio-evb-dashboard
ExecStartPre=-/usr/bin/docker rm misodengaku/sakuraio-evb-dashboard
ExecStartPre=/usr/bin/docker pull misodengaku/sakuraio-evb-dashboard
ExecStart=/usr/bin/docker run -d -p %UI_PORT%:8080 -v /log:/log -e MODULE_ID=%MODULE_ID% -e WEBSOCKET_TOKEN=%WEBSOCKET_TOKEN% misodengaku/sakuraio-evb-dashboard

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable sakuraio-evb-dashboard
systemctl start sakuraio-evb-dashboard

# docker run -d -p $UI_PORT:8080 -v /log:/log -e MODULE_ID=$MODULE_ID -e WEBSOCKET_TOKEN=$WEBSOCKET_TOKEN misodengaku/sakuraio-evb-dashboard

exit 0