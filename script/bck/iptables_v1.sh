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
    list=`iptables -nL | grep $uid`
    echo 'list:' $list
}

function add(){
    echo 'add' [$table] 'uid: '$uid
    iptables -I OUTPUT -m owner --uid-owner $uid -j DROP
}

function remove(){
    echo 'remove' [$table] 'uid: '$uid
    iptables -D OUTPUT -m owner --uid-owner $uid -j DROP
}

function handler(){
    for table in ${appNames[@]};do
        echo --------------------------------------
        getUid $table

        if [ ! $uid ]; then
            echo "uid is null,skip!!!"
            continue
        fi

        case "$input" in
            1)
                query $table
                ;;
            2)
                add $table
                ;;
            3)
                remove $table
                ;;
        esac

        checkRes
    done
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

    echo "please input option(1=query,2=add,3=remove):"
    read input
    echo 'input:'$input

    case "$input" in
        1|2|3)
            handler $input
            ;;
        *)
            echo "invalid input. please enter 1,2 or 3"
            ;;
    esac
}

main
