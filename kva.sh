#!/bin/sh

echo "This is a shell script to automatically install kevacoin+electrumX tcp on Ubuntu for localhost."
echo "Source:https://github.com/kevacointoolkit/electrumx"
echo "You need input sudo -s to get rights to setup kevacoind and input chmod +x kva.sh to run the scripts ./kva.sh"

##kevacoin

wget=/usr/bin/wget
tar=/bin/tar

cd /home

apt install git -y

git clone https://github.com/kevacoin-project/electrumx

wget "https://github.com/kevacoin-project/kevacoin/releases/download/v0.16.8.0/kevacoin-0.16.8.0.tar.gz"

mkdir kevacoin

tar zxvf kevacoin-0.16.8.0.tar.gz -C kevacoin

cd /root

mkdir .kevacoin

cd .kevacoin

cat>kevacoin.conf<<EOF
rpcuser=galaxy
rpcpassword=frontier
rpcport=9992
server=1
addressindex=1
txindex=1
EOF

cd /home

cd kevacoin

mv kevacoin-0.16.8.0/bin .

cd bin

./kevacoind -daemon

cd  /home

##python




sudo apt install python3-pip -y

python3.8 -m pip install pip

python3.8 -m pip install aiohttp

python3.8 -m pip install pylru

python3.8 -m pip install plyvel

python3.8 -m pip install aiorpcx

python3.8 -m pip install aiorpcX==0.18.4

sudo apt install python3.8-dev -y

python3.8 -m pip install py-cryptonight

sudo apt-get install libgflags2.2 libgflags-dev -y

sudo apt-get install librocksdb-dev -y

sudo apt-get install libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev -y

python3.8 -m pip install Cython

python3.8 -m pip install git+https://github.com/twmht/python-rocksdb.git

##apt-get update && apt-get -y upgrade

##electrumx

mkdir kevax

cd /etc/systemd/system/

cat>electrumx.kevacoin.service<<EOF
[Unit]
Description=Kevacoin
After=network.target
[Service]
EnvironmentFile=/etc/electrumx.kevacoin.conf
ExecStart=/home/electrumx/electrumx_server
User=root
LimitNOFILE=8192
TimeoutStopSec=30min
[Install]
WantedBy=multi-user.target
EOF

cd /etc/

cat>electrumx.kevacoin.conf<<EOF
DB_DIRECTORY = /home/kevax/
COIN=Kevacoin
PEER_ANNOUNCE=on
SERVICES=tcp://:50001
REQUEST_SLEEP=1000
INITIAL_CONCURRENT=20
COST_HARD_LIMIT=1000000
DAEMON_URL=http://galaxy:frontier@127.0.0.1:9992/
DB_ENGINE=rocksdb
ALLOW_ROOT=True
EOF


systemctl daemon-reload

systemctl start electrumx.kevacoin.service

systemctl enable electrumx.kevacoin.service

cd /etc/systemd/system

cat>keva.service<<EOF
[Unit]
Description=keva
After=network.target
[Service]
ExecStart=/home/kevacoin/bin/kevacoind
User=root
LimitNOFILE=8192
TimeoutStopSec=30min
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl start keva

systemctl enable keva

cd /home

./kevacoin/bin/kevacoin-cli get_info


