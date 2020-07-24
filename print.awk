#!/usr/bin/awk -f
BEGIN {
	print "AWK: howdy, lets do the thrill"
} 
{
	command="bash ./printline.sh "$0
	system(command)
}
END {
	print "AWK: thrill is done"
} 
