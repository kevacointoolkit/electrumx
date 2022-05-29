#!/bin/bash
echo "Fix electrumx 65535!" 

systemctl stop electrumx.kevacoin.service

rm -rf /root/kevax

mkdir /root/kevax

systemctl start electrumx.kevacoin.service
