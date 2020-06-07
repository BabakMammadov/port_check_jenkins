#!/bin/bash
srcAddress=$1
dstAddressPorts=$2

## Check argument count
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters, you must use as below"
    echo "Usage01: ./script.sh  src1 dst1:port1"
    echo "Usage02: ./script.sh  src1 dst1:port1:port2:port3"
    echo "Usage03: ./script.sh  src1,src2 dst1:port1:port2:port3,dst2:port1:port2:port3"
    exit 0
fi

### if dest hostname not resolved pls continue next dest address in loop, not used here.
function  resolve() {    
    ipaddr=$1
    reason=$2
    result=$(getent hosts $ipaddr | awk '{ print $1 }')
    if [ -z "$result" ]
    then
        echo "$ipaddr is not resolved ip addr therefore it won't $reason"
    fi
}

### iterate src address and connect them then check dest ip and port
IFS=','; for src in $srcAddress;
do  
    IFS=','; for dstport in $dstAddressPorts;
    do
        firstDstAddr=$(echo $dstport | awk -F:  '{print $1}')
        ports=$(echo $dstport |  awk -F:   '{for (i=2; i<NF; i++) printf $i " "; print $NF}')
        echo  "###############  Login to $src server and  check ip  $firstDstAddr and ports $ports  ###############"
        IFS=' ';for p in $ports;
        do
            result=$(ssh ansible@$src "timeout 1 bash -c 'cat < /dev/null > /dev/tcp/$firstDstAddr/$p' 2> /dev/null && echo $?")
            if [ "$result" == "0" ];
            then
                echo "Access is OK. from $src server to $firstDstAddr with $p port"
            else
                echo "Access is Not OK or network address not resolved. from $src server to $firstDstAddr with $p port"
            fi
        done
        echo -e "\n"
    done
done