#!/bin/bash

#app package names
appNames=("mark.via" "com.joyose")

function getUid(){
    echo 'packag name:' $1
    #adb shell dumpsys package $1 | grep userId=
    uid=`pm list packages -U | grep $1 | awk -F 'uid:' '{print $2}'`
    echo 'uid:'$uid
}

function checkRes(){
    if [ $? -eq 0 ]; then
        echo "exec ok"
    else
        echo "exec failed!!!"
    fi
}

function query(){
    # list=`iptables -nL | grep $uid`
    list=`iptables -nL symbol_app_chain`
    echo 'list:' "$list"
}

function _add(){
    echo 'add' [$table] 'uid: '$uid

    #create custom chain
    iptables -N symbol_app_chain
    #check exist
    iptables -C OUTPUT -j symbol_app_chain
    if [ $? -eq 1 ]; then
        #link custom chain
        iptables -I OUTPUT -j symbol_app_chain
    else
        echo "custom chain is linked"
    fi

    iptables -I symbol_app_chain -m owner --uid-owner $uid -j DROP
}

function clean(){
    echo 'clean'

    #unlink custom chain
    iptables -D OUTPUT -j symbol_app_chain
    #clean custom chain
    iptables -F symbol_app_chain
    #delete custom chain
    iptables -X symbol_app_chain
}

function add(){
    for table in ${appNames[@]};do
        getUid $table

        if [ ! $uid ]; then
            echo "uid is null,skip!!!"
            continue
        fi

        _add
        checkRes
        echo --------------------------------------
    done

    #save
    #iptables-save >/etc/sysconfig/iptables
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

function main(){
    checkRoot

    echo "------------------------"
    echo "android firewall"
    echo "------------------------"

    echo "please input option(1=query,2=add,3=clean):"
    read input
    echo 'input:'$input
    echo --------------------------------------

    case "$input" in
        1)
            query
            ;;
        2)
            add
            ;;
        3)
            clean
            ;;
        *)
            echo "invalid input. please enter 1,2 or 3"
            ;;
    esac
}

main
