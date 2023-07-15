#!/bin/bash

echo "This scanner currently works with /24 networks only. Enter the first three octets of the network."
echo "Example: 10.10.10"
read subnet
octets="$(echo $subnet | cut --output-delimiter=" " -d "." -f 1-4 | wc -w)"
if [ $octets -eq "3" ]; then
	for i in {1..254}
	do
		ping -c 3 "$subnet"".""$i" 2>/dev/null | grep "ttl" | grep -E -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | uniq &
	done
elif [ $octets -eq "2" ]; then
	for i in {1..254}
	do
		#echo "Scanning subnet" $subnet"."$i".0/24"
		for x in {1..254}
		do
			ping -c 3 "$subnet"".""$i"".""$x" 2>/dev/null | grep "ttl" | grep -E -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | uniq &	
		done
		sleep 5
	done
elif [ $octets -eq "1" ]; then
	for i in {1..254}
	do
		for x in {1..254}
		do
			#echo "Scanning subnet" $subnet"."$i"."$x".0/24"
			for y in {1..254}
			do
				ping -c 3 "$subnet"".""$i"".""$x"".""$y" 2>/dev/null | grep "ttl" | grep -E -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | uniq &
			done
			sleep 3
		done
		sleep 3
	done
else
	echo "No input provided"
	exit
fi


while [ "$(jobs -r | wc -l)" -gt 0 ]
do
	sleep 5
	echo "Jobs still running..."
done

echo "Done"
