#!/bin/bash
OUT_FILE_PATH=/tmp/snapshotdb
if ! [ -z "$1" ]
then
    OUT_FILE_PATH=$1
fi


ETCD_TRUSTED_CA_FILE=$(cat /etc/etcd.env | grep ETCD_TRUSTED_CA_FILE | awk -F'=' '{print $2}')
ETCD_CERT_FILE=$(cat /etc/etcd.env | grep ETCD_CERT_FILE | awk -F'=' '{print $2}')
ETCD_KEY_FILE=$(cat /etc/etcd.env | grep ETCD_KEY_FILE | awk -F'=' '{print $2}')

sudo etcdctl --cacert=$ETCD_TRUSTED_CA_FILE \
 --cert=$ETCD_CERT_FILE \
 --key=$ETCD_KEY_FILE \
 --endpoints 127.0.0.1:2379 snapshot save $OUT_FILE_PATH
