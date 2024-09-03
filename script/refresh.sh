#!/bin/bash

#script relative path
# MODDIR=${0%/*}

#script absolute path of grandparent
MODDIR=$(dirname $(cd $(dirname $0); pwd))

function clean(){
    echo 'clean...'
    iptables -F symbol_app_chain
    echo 'clean...ok'
}

function main(){
    echo 'work dir:'$MODDIR
    clean

    echo 'start...'
    $MODDIR/script/add.sh >$MODDIR/debug.log
    echo 'start...ok'

    echo 'start log:' $MODDIR/debug.log
}

main