#!/bin/bash

function query(){
    dmesg -Tw | grep "AFLOG="
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
