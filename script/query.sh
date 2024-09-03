#!/bin/bash

function query(){
    # list=`iptables -nL | grep $uid`
    list=`iptables -nL symbol_app_chain`
    echo 'list:' "$list"
}

function checkRoot(){
    if [ "$(id -u)" -ne 0 ]; then
        echo "not running as root. attempting to gain root privileges..."
        #use root to run this srcipt
        sudo bash "$0" "$@"
        exit $?
    fi

    echo "running as root."
}

checkRoot
query
