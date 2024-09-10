#!/bin/bash

function queryTotal(){
    #dmesg | grep "AFLOG=" | wc -l
    dmesg -t | grep "AFLOG=" | awk -F 'AFLOG=' '{print $2}' | awk '{print $1}' | sort | uniq -c
}

function queryWatch(){
    #dmesg -tw | grep "AFLOG="
    watch -n 1 "dmesg -T | grep AFLOG= | tail -10"
}

function queryRule(){
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
    #echo "running as root."
}

function handler(){
    echo "请输入参数(1=拦截规则,2=拦截数量,3=拦截实时查看,0=退出):"
    read input
    #echo 'input:'$input

    case "$input" in
        1)
            queryRule
            ;;
        2)
            queryTotal
            ;;
        3)
            queryWatch
            ;;
        0)
            exit 0
            ;;
        *)
            echo "参数不合法,请输入 1,2,3 或 0"
            ;;
    esac

    echo ''
    handler
}

function main(){
    checkRoot

    echo "------------------------"
    echo "android firewall"
    echo "------------------------"

    handler
}

main
