#!/system/bin/sh
MODDIR=${0%/*}

function getApps(){
    #appNames=("mark.via" "com.joyose")
    appNames=$(cat $MODDIR/conf.json | grep -v [][#] | sed 's/[," \r\n]//g')
    #appNames=$(cat $MODDIR/conf.json | sed 's/[][," \r\n]//g')
    echo 'apps:' $appNames
}

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

function addChain(){
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

    #create custom chain
    ip6tables -N symbol_app_chain_v6
    #check exist
    ip6tables -C OUTPUT -j symbol_app_chain_v6
    if [ $? -eq 1 ]; then
        #link custom chain
        ip6tables -I OUTPUT -j symbol_app_chain_v6
    else
        echo "custom chain v6 is linked"
    fi
}

function addRule(){
    echo 'ipv4 add' [$table] 'uid: '$uid
    iptables -I symbol_app_chain -m owner --uid-owner $uid -j DROP

    echo 'ipv6 add' [$table] 'uid: '$uid
    ip6tables -I symbol_app_chain_v6 -m owner --uid-owner $uid -j DROP
}

function main(){
    echo `date '+%Y-%m-%d %H:%M:%S'`
    echo 'work dir:' $MODDIR

    getApps
    addChain

    for table in ${appNames[@]};do
        echo --------------------------------------
        getUid $table

        if [ ! $uid ]; then
            echo "uid is null,skip!!!"
            continue
        fi

        addRule
        checkRes
    done
}

main
