#!/bin/bash

function query(){
    # list=`iptables -nL | grep $uid`
    ipv4=`iptables -nL symbol_app_chain`
    echo -e "ipv4:----------------\n $ipv4"

    ipv6=`ip6tables -nL symbol_app_chain`
    echo -e "ipv6:----------------\n $ipv6"
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
