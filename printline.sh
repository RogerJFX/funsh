#!/bin/bash
text=""
secCharSleep=0
secLineSleep=0
doLineBreak=0
secSleepBeforeType=0
animating=0

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

#ôrootá@roger-Corsair:à/pubâ$
INDICATOR_RED_BOLD="ô"
INDICATOR_GREEN_BOLD="á"
INDICATOR_BLUE="à"
INDICATOR_NORMAL="â"

getChar() {
	a=$1
	local char
	char=${text:a:1}
	if [ "_" == "$char" ]
	then
		char=" "
	fi
	echo "$char"
}

animate() {
	c=0
	x=0
	printf "|"
	while [ $x -ne 4 ]; do
		if [ $c -eq 0 -o "$c" -eq 4 ]; then
			printf "\b|"
		elif [ $c -eq 1 -o "$c" -eq 5 ]; then
			printf "\b/"
		elif [ $c -eq 2 -o "$c" -eq 6 ]; then
			printf "\b-"
		elif [ $c -eq 3 -o "$c" -eq 7 ]; then
			printf "\b\\"
		fi
		if [ $c -eq 7 ]; then
			c=-1
			x=$((x+1))
		fi 
		c=$((c+1))
		sleep 0.2
	done
	printf "\b"
}

parseLine() {
	c=0
	for token in "$@"; do
		if [ $c -eq 0 ]; then
			secCharSleep=$token
		elif [ $c -eq 1 ]; then
			secLineSleep=$token
		elif [ $c -eq 2 ]; then
			doLineBreak=$token
		elif [ $c -eq 3 ]; then
			secSleepBeforeType=$token
		else
			if [ "_animate_" == "$token" ];	then
				animating=1;
			else
				text=$text$token" "
			fi
		fi
		c=$((c+1))
	done
}

printline() {
	if [ $animating -eq 1 ]
	then 
		animate
	fi 
	sleep $secSleepBeforeType
	len=${#text}
	len=$((len-1))
	c=0
	#printf "${RED}"
	while [ $c -lt $len ]; do
		char=$(getChar c)
		if [ "$INDICATOR_GREEN_BOLD" == "$char" ]; then
			printf "${BOLD}${GREEN}"
		elif [ "$INDICATOR_RED_BOLD" == "$char" ]; then
			printf "${BOLD}${RED}"
		elif [ "$INDICATOR_BLUE" == "$char" ]; then
			printf "${BLUE}"
		elif [ "$INDICATOR_NORMAL" == "$char" ]; then
			printf "${NORMAL}${NC}"
		elif [ " " == "$char" ]; then
			printf " "
		else 
			printf "%s" $char
		fi
		c=$((c+1))
		sleep $secCharSleep
	done
}

parseLine $@
printline

if [ $doLineBreak == "1" ] 
then
	echo ""
else 
	printf " "
fi

sleep $secLineSleep
