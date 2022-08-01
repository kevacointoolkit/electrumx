https://keva.app/?62493681

# Now you can use kva.sh script to automatically install kevacoin+electrumx local tcp server on ubuntu 20.04.

wget keva.app/kva.sh
chmod +x kva.sh
sudo -s
./kva.sh

Then you can use your ip and tcp port 50001 in kevacoin app.

check electrumx status

systemctl status electrumx.kevacoin.service

# Install electrumx on virsual machine

Download Ubuntu 20.04  

https://releases.ubuntu.com/20.04.4/ubuntu-20.04.4-live-server-amd64.iso

Download VirtualBox 

https://www.virtualbox.org/wiki/Downloads

Install Ubuntu on VirtualBox and use kva.sh

# ubuntu 20.04

apt-get update && apt-get -y upgrade

# add ram

sudo swapoff -a

sudo fallocate -l 4G /swapfile && \

sudo chmod 600 /swapfile && \

sudo mkswap /swapfile && \

sudo swapon /swapfile && \

sudo cp /etc/fstab /etc/fstab.bak && \

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && \

sudo swapon --show


# use free -m to check

wget https://github.com/kevacoin-project/kevacoin/releases/download/v0.16.8.0/kevacoin-0.16.8.0.tar.gz

mkdir kevacoin

tar zxvf kevacoin-0.16.8.0.tar.gz -C kevacoin



cd kevacoin

mv kevacoin-0.16.8.0/bin .

cd bin

./kevacoind -daemon

./kevacoin-cli stop

cd /root/.kevacoin

# clear 

rm -rf *

# create new conf

vi kevacoin.conf

# change your own user/password/port

rpcuser=galaxy

rpcpassword=frontier

rpcport=9992

server=1

addressindex=1

txindex=1

# run kevacoin daemon

cd /root/kevacoin/bin

./kevacoind -daemon

#check stats

./kevacoin-cli get_info

# electrumx https://kevacoin.org/keva_electrumx.html

cd /root

# python

sudo apt install python3-pip

python3.8 -m pip install pip

python3.8 -m pip install aiohttp

python3.8 -m pip install pylru

python3.8 -m pip install plyvel

python3.8 -m pip install aiorpcx

python3.8 -m pip install aiorpcX==0.18.4

sudo apt install python3.8-dev

python3.8 -m pip install py-cryptonight

sudo apt-get install libgflags2.2 libgflags-dev

sudo apt-get install librocksdb-dev

sudo apt-get install libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev

python3.8 -m pip install Cython

python3.8 -m pip install git+git://github.com/twmht/python-rocksdb.git

apt-get update && apt-get -y upgrade

# domain

sudo apt-get update

sudo apt-get install software-properties-common

sudo add-apt-repository universe

sudo add-apt-repository ppa:certbot/certbot

sudo apt-get update

sudo apt-get install certbot

sudo certbot certonly --standalone

crontab -e 

0 0 1 * * /usr/bin/certbot renew --force-renewal

# setup email and domain

sudo chmod -R 755 /etc/letsencrypt/archive/

sudo chmod -R 755 /etc/letsencrypt/live/

# setup electrumx profile

mkdir kevax

cd /etc/systemd/system/

vi electrumx.kevacoin.service

#services profile

[Unit]

Description=Kevacoin

After=network.target

[Service]

EnvironmentFile=/etc/electrumx.kevacoin.conf

ExecStart=/root/electrumx/electrumx_server

User=root

LimitNOFILE=8192

TimeoutStopSec=30min

[Install]

WantedBy=multi-user.target

# electrumx profile

cd /root

vi /etc/electrumx.kevacoin.conf

#profile


DB_DIRECTORY = /root/kevax/

COIN=Kevacoin

PEER_ANNOUNCE=on

SERVICES=rpc://localhost:50001,ssl://:50002

REQUEST_SLEEP=1000

INITIAL_CONCURRENT=20

COST_HARD_LIMIT=1000000

#change your user:password and port

DAEMON_URL = http://galaxy:frontier@127.0.0.1:9992/

DB_ENGINE=rocksdb

SSL_CERTFILE=/etc/letsencrypt/live/your doamin/fullchain.pem

SSL_KEYFILE=/etc/letsencrypt/live/your doamin/privkey.pem

ALLOW_ROOT=True

# install exlectrum

apt install git

git clone https://github.com/kevacoin-project/electrumx

# check block stats

./kevacoin/bin/kevacoin-cli get_info

# if sync ok, run electrumx.

systemctl daemon-reload

systemctl start electrumx.kevacoin.service

systemctl status electrumx.kevacoin.service


systemctl enable electrumx.kevacoin.service

# start kevacoin daemon when reboot

vi /etc/systemd/system/keva.service

#profile

[Unit]
  
Description=keva

After=network.target

[Service]

ExecStart=/root/kevacoin/bin/kevacoind

User=root

LimitNOFILE=8192

TimeoutStopSec=30min

[Install]

WantedBy=multi-user.target

# check

systemctl daemon-reload

systemctl start keva

systemctl status keva

./kevacoin/bin/kevacoin-cli get_info

systemctl enable keva

# install ipfs

wget https://dist.ipfs.io/go-ipfs/v0.7.0/go-ipfs_v0.7.0_linux-amd64.tar.gz

tar -xvzf go-ipfs_v0.7.0_linux-amd64.tar.gz

cd go-ipfs

sudo bash install.sh

ipfs init 

# Start the daemon

ipfs daemon   

ctrl+c to stop

# start ipfs when reboot

vi /etc/systemd/system/ipfs.service

# profile

[Unit]

Description=IPFS daemon

After=network.target

[Service]

#Uncomment the following line for custom ipfs datastore location

#Environment=IPFS_PATH=/path/to/your/ipfs/datastore

ExecStart=/usr/local/bin/ipfs daemon

Restart=on-failure

[Install]

WantedBy=multi-user.target

# test

systemctl daemon-reload

systemctl start ipfs

systemctl status ipfs

systemctl enable ipfs

# install go

wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin

git clone https://github.com/kevacoin-project/keva_ipfs

cd ..

cd keva_ipfs

go build .

# setup server

vi /etc/profile

#profile

#Connection to ElectrumX server

export KEVA_ELECTRUM_HOST=your domain

export KEVA_ELECTRUM_SSL_PORT=50002

export KEVA_MIN_PAYMENT=9

#Payment address

export KEVA_PAYMENT_ADDRESS=your keva address

export KEVA_TLS_ENABLED=1

export KEVA_TLS_KEY=/etc/letsencrypt/live/$KEVA_ELECTRUM_HOST/privkey.pem

export KEVA_TLS_CERT=/etc/letsencrypt/live/$KEVA_ELECTRUM_HOST/fullchain.pem

# reboot to test

reboot

# start go

cd keva_ipfs

nohup ./go_be >/dev/null 2>&1 &


# Update Electrumx

update

./kevacoin/bin/kevacoin-cli stop

systemctl stop electrumx.kevacoin.service

rm -rf electrumx

git clone https://github.com/kevacoin-project/electrumx

systemctl start electrumx.kevacoin.service

if the database is change, delete the kevax and mkdir kevax.

rm -rf kevax

mkdir kevax

reboot

./kevacoin/bin/kevacoin-cli get_info

systemctl status electrumx.kevacoin.service

wait sync ok and reboot

#start go

cd keva_ipfs

nohup ./go_be >/dev/null 2>&1 &

# 65535 fix

The electrumx db will stop every 65535. It is better to clear db and rebuild some time.

#create fixe.sh

vi fixe.sh

#!/bin/bash
echo "Fix electrumx 65535!" 

systemctl stop electrumx.kevacoin.service

rm -rf /root/kevax

mkdir /root/kevax

systemctl start electrumx.kevacoin.service

#run

chmod -R 777 fixe.sh

#clear db every month/2month

crontab -e

1 1 1 * * bash /root/fixe.sh

1 1 15 * * bash /root/fixe.sh

1 1 1 */2 * bash /root/fixe.sh

1 1 1 1-11/2 * bash /root/fixe.sh

