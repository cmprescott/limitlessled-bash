#!/bin/bash

if [ -z $1 ]
then
    echo "You must enter a parameter:"
    echo "e.g. 'led.sh' c 1 on #turns colour zone 1 one"
    exit "1"
fi
# Wifi controller information
ipaddress="10.1.1.23"
portnum="8899"

# Script parameters
type="$1"
zone="$2"
command="$3"
param="$4"

#Colour array
declare -A colours=( ["purple"]="\x40\x00\x55" ["blue"]="\x40\x20\x55" ["red"]="\x40\xb0\x55" ["green"]="\x40\x60\x55" ["yellow"]="\x40\x80\x55" ["pink"]="\x40\xC0\x55" ["orange"]="\x40\xA0\x55" )

function colour {
	#RGBW bulb Commands
	onarray=("\x42\00\x55" "\x45\00\x55" "\x47\00\x55" "\x49\00\x55" "\x4B\00\x55")
	offarray=("\x41\00\x55" "\x46\00\x55" "\x48\00\x55" "\x4A\00\x55" "\x4C\00\x55")
	# Array for white commands
	whitearray=("\xC2\00\x55" "\xC5\00\x55" "\xC7\00\x55" "\xC9\00\x55" "\xC9\00\x55")
	brightarray=("\x4E\x02\x55" "\x4E\x04\x55" "\x4E\x08\x55" "\x4E\x0A\x55" "\x4E\x0B\x55" "\x4E\xD0\x55" "\x4E\x10\x55" "\x4E\x13\x55" "\x4E\x16\x55" "\x4E\x19\x55" "\x4E\x1B\x55")
	#TODO add brightness

        if [ $command = "b" ] || [ $command = "B" ]
        then
                echo "brightness"
		if [ $param = "full" ]
		then
			cmd="\x4E\x3B\x55"
			echo "You turned colour bulbs in zone $zone to full brightness"
			echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                        sleep 0.01
                        echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
		elif [ $param -ge 0 -a $param -le 10 ]
		then
	                echo "You turned colour bulbs in zone $zone to $param"
                        echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                        sleep 0.01
                        echo -n -e "${brightarray[$param]}" >/dev/udp/$ipaddress/$portnum
		else
			echo "You've done something wrong"
		fi
	elif [ $command = "c" ] || [ $command = "C" ]
	then
		# Check to make sure that the colour specified in the array before trying
		isin=1
                if [ $param = "white" ]
                then
                        echo "You just turned colour bulbs in zone $zone back to white"
                        echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                        sleep 0.01
                        echo -n -e "${whitearray[$zone]}" >/dev/udp/$ipaddress/$portnum
		else
			for i in "${!colours[@]}"
			do
        			if [ "$i" = "$param" ]
        			then
                			isin=0
	        		fi
  			done

			if [ "$isin" -eq "0" ]
			then
				echo "You just changed colour bulbs in zone $zone to $param"
				echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
				sleep 0.01
				echo -n -e "${colours[$param]}" >/dev/udp/$ipaddress/$portnum
			else
				echo "Colour $param isn't configured"
			fi
		fi
        elif [ $command = "on" ] || [ $command = "ON" ]
        then
                echo "You just turned colour bulbs in zone $zone on" 
                echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
        elif [ $command = "off" ] || [ $command = "OFF" ]
        then
                echo "You just turned colour bulbs in zone $zone off"
                echo -n -e "${offarray[$zone]}" >/dev/udp/$ipaddress/$portnum
	else
		echo "You've done something wrong"
        fi
}

function white {
	#white commands
	onarray=("\x35\00\x55" "\x38\00\x55" "\x3D\00\x55" "\x37\00\x55" "\x32\00\x55")
	offarray=("\x39\00\x55" "\x3B\00\x55" "\x33\00\x55" "\x3A\00\x55" "\x36\00\x55")
	fullbrightarray=("\xB5\00\x55" "\xB8\00\x55" "\xBD\00\x55" "\xB7\00\x55" "\xB2\00\x55")
	nightarray=("\xB9\00\x55" "\xBB\00\x55" "\xB3\00\x55" "\xBA\00\x55" "\xB6\00\x55")
	#TODO add brightness commands for white

	if [ $command = "b" ] || [ $command = "B" ]
	then
		echo "brightness"
		if [ $param = "night" ]
		then
			echo "You turned white bulbs in zone $zone to night-mode"
			echo -n -e "${offarray[$zone]}" >/dev/udp/$ipaddress/$portnum
			sleep 0.01
			echo -n -e "${nightarray[$zone]}" >/dev/udp/$ipaddress/$portnum
		elif [ $param = "full" ]
		then
			echo "You turned white bulbs in zone $zone to full brightness"
                        echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                        sleep 0.01
                        echo -n -e "${nightarray[$zone]}" >/dev/udp/$ipaddress/$portnum
		elif [ $param = "up" ]
		then
			cmd="\x3C\00\x55"
			echo "You turned white bulbs in zone $zone up 1 brightness"
			echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
			sleep 0.01
			echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
		elif [ $param = "down" ]
		then
                        cmd="\x34\00\x55"
                        echo "You turned white bulbs in zone $zone down 1 brightness"
                        echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                        sleep 0.01
                        echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
                elif [ $param = "cool" ]
		then
                        cmd="\x3f\00\x55"
                        echo "You cooled down white bulbs in zone $zone"
                        echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                        sleep 0.01
                        echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
                elif [ $param = "warm" ]
		then
                        cmd="\x3e\00\x55"
                        echo "You warmed up white bulbs in zone $zone"
                        echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                        sleep 0.01
                        echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
		elif [ $param = "i" ]
		then
			echo "Press CTRL+C to exit interactive mode"
			echo "Make sure you have numlock OFF when using numpad"
			for (( ; ; ))
			do
				read -s -n 1 var
				case $var in
				8)
					cmd="\x3C\00\x55"
		                        echo "You turned white bulbs in zone $zone up 1 brightness"
                		        echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
		                        sleep 0.01
                		        echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
					;;
				2)
					cmd="\x34\00\x55"
		                        echo "You turned white bulbs in zone $zone down 1 brightness"
        		                echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                		        sleep 0.01
                        		echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
					;;
				4)
					cmd="\x3f\00\x55"
		                        echo "You cooled down white bulbs in zone $zone"
        		                echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                		        sleep 0.01
                        		echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
					;;
				6)
					cmd="\x3e\00\x55"
		                        echo "You warmed up white bulbs in zone $zone"
        		                echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
                		        sleep 0.01
                        		echo -n -e "$cmd" >/dev/udp/$ipaddress/$portnum
					;;
				*)
					echo "wrong key pressed"
				esac
			done
		else
			echo "You've done something wrong"
		fi
	elif [ $command = "on" ] || [ $command = "ON" ]
	then
		echo "You just turned white bulbs in zone $zone on"
		echo -n -e "${onarray[$zone]}" >/dev/udp/$ipaddress/$portnum
	elif [ $command = "off" ] || [ $command = "OFF" ]
	then
		echo "You just turned white bulbs in zone $zone off"
		echo -n -e "${offarray[$zone]}" >/dev/udp/$ipaddress/$portnum
	else
		echo "You've done something wrong"
	fi
}

if [ $type = "c" ] || [ $type = "C" ]
then
	colour
elif [ $type = "w" ] || [ $type = "W" ]
then
	white
else
	echo "You've done something wrong"
fi
