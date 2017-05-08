#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
basepath=/root/SDNCase/

for rou in $(cat $basepath/reference/configs.conf | grep ^routers= | cut -d= -f2 | sed 's/,/ /g')
do
	dpid=`cat $basepath/reference/configs.conf | grep $rou"_dpid" | cut -d= -f2`
	curlcommand="curl -X GET http://localhost:8080/stats/port/$dpid"
	#echo $curlcommand
	stats=`eval "$curlcommand"`
	#stats='{ "1": [ { "port_no": 1, "rx_packets": 9, "tx_packets": 6, "rx_bytes": 738, "tx_bytes": 252, "rx_dropped": 0, "tx_dropped": 0, "rx_errors": 0, "tx_errors": 0, "rx_frame_err": 0, "rx_over_err": 0, "rx_crc_err": 0, "collisions": 0, "duration_sec": 12, "duration_nsec": 9.76e+08 }, { : : } ] , "2": [ { "port_no": 1, "rx_packets": 9, "tx_packets": 6, "rx_bytes": 1234, "tx_bytes":4321, "rx_dropped": 0, "tx_dropped": 0, "rx_errors": 0, "tx_errors": 0, "rx_frame_err": 0, "rx_over_err": 0, "rx_crc_err": 0, "collisions": 0, "duration_sec": 12, "duration_nsec": 9.76e+08 }, { : : } ] }'
	cat $basepath/reference/configs.conf | grep $rou"_interface" | while read line
	do
		rou_interface=$rou"_interface"
		int=`echo $line | cut -d= -f1 | sed "s/$rou_interface//g"`
		inteth=`echo $line | cut -d= -f2`
		#echo "$rou $int $inteth"
		#current_rx=`echo $stats | perl -pe "s|.*\"$int\": \[ (.*?\]).*|\1|" | perl -pe 's|.*(rx_bytes.*?,).*|\1|' | sed 's/[^0-9]*//g'`
		current_rx=`echo $stats | perl -pe "s|.*({.*\"port_no\": $int,.*?}).*|\1|" | perl -pe "s|.*\"rx_bytes\": ([0-9]+).*|\1|"`
		#current_tx=`echo $stats | perl -pe "s|.*\"$int\": \[ (.*?\]).*|\1|" | perl -pe 's|.*(tx_bytes.*?,).*|\1|' | sed 's/[^0-9]*//g'`
		current_tx=`echo $stats | perl -pe "s|.*({.*\"port_no\": $int,.*?}).*|\1|" | perl -pe "s|.*\"tx_bytes\": ([0-9]+).*|\1|"`
		sed -i "s/RX:.*/RX:$current_rx/g" $basepath/received/current_bytes.$rou.$inteth
		sed -i "s/TX:.*/TX:$current_tx/g" $basepath/received/current_bytes.$rou.$inteth
	done
done

