#!/bin/bash

#script relative path
# MODDIR=${0%/*}

#script absolute parent path
MODDIR=$(cd $(dirname $0); pwd)

function clean(){
    echo 'clean...'
    iptables -F symbol_app_chain
    ip6tables -F symbol_app_chain_v6
    echo 'clean...ok'
}

function main(){
    echo 'work dir:'$MODDIR
    clean

    echo 'start...'
    $MODDIR/add.sh >$MODDIR/start.log
    echo 'start...ok'

    echo 'start log:' $MODDIR/start.log
}

main