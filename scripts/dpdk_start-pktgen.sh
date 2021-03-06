#!/bin/bash

PKTGEN_SCRIPT=$CONFIG_DIR/lua_forwarding-rate.lua

cd $RTE_PKTGEN

echo "***************************"
echo "Using pkt_gen: $RTE_PKTGEN"
echo "Pktgen-script: $PKTGEN_SCRIPT"
echo "***************************"

ERRFILE=/tmp/err.out

if [[ $# -eq 0 ]] ; then
    echo 'STARTING PKTGEN WITH DEFAULT PARAMETERS' 
    echo '(cores: 12-16; [LC1P0, port0, rx] [LC1P1, port1, tx] ).' 

	sudo app/app/x86_64-native-linuxapp-gcc/pktgen -l 12,13-16 -n 1 -w $LC1P0 -w $LC1P1 -- -P -T -m "[13-14].0,[15-16].1"
	exit 1
fi

if [ "$1" == "forwarding" ]; then
	sudo app/app/x86_64-native-linuxapp-gcc/pktgen -l 12,13-16 -n 1 -w $LC1P0 -w $LC1P1 -- -P -T -m "[13-14].0,[15-16].1" -f $PKTGEN_SCRIPT
else
	echo "Starting pktgen with a .pkt file"
	######## NOT PATCHED! 03/04/2017, Leos ###########
    #F=`$CONFIG_DIR/dpdk_config-pktgen.sh $1`
	sudo app/app/x86_64-native-linuxapp-gcc/pktgen -l 12,13-16 -n 1 -w $LC0P0 -w $LC0P1 -- -P -T -m "[13-14].0,[15-16].1" -f $1
fi
