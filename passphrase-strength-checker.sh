#!/bin/sh

#Developed by Adam Austin of Totem Technologies (totem.tech)
#Tested on Fedora 36
#Convert this file to unix format to run
#Requires the libpwquality, rlwrap, and osd_cat packages
#Configure the /etc/security/pwquality.conf file to reflect the desired number of pw characters (instructions.txt assumes this is to 15)
#Before you kick off the script, shrink the terminal window to three lines tall, and position it about 1/3 down from the top of the screen. Zoom on the terminal to make the input font bigger.

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT #this kills all child processes upon exit
color="green"
entrytext="This is an example passphrase!"

#display basic passphrase checker instructions on screen; edit <user> to the appropriate directory; change the font size in the --font line (26) to fit the screen
osd_cat /home/<user>/Desktop/instructions.txt \
--pos=top \
--offset=50 \
--align=center \
--color=magenta \
--shadow=2 \
--font='-*-liberation sans-*-r-*-*-26-*-*-*-*-*-*-*' \ 
--delay=9000 &

while : #read in the passphrase and do the checks
passphrase=$( rlwrap -S "Type passphrase here (type 'quit' to exit): " -P "$entrytext" -o cat )
do
	if [ "$passphrase" == "quit" ] 
		then exit 1
	fi
	
	score=$( echo $passphrase | pwscore 2>/tmp/pwscore_stderr )
	checkresult=$( cat /tmp/pwscore_stderr )
	
	if [[ $checkresult =~ "dictionary" ]] #some score failure messages are too long for the screen
		then IFS='-'; arrREASON=($checkresult); unset IFS; #split the message into parts
		checkresult="Password quality check failed: ${arrREASON[1]}"
	fi
	
	if [[ $checkresult =~ "consecutively" ]] #some score failure messages are too long for the screen
		then checkresult="Password quality check failed: more than 4 consecutive characters"
	fi
	

	if [ $score ] #if the passphrase has a score
		then #populate variables to display the score on screen
		entrytext=$passphrase #save the current passphrase to repopulate the input dialog
		message="Your passphrase '$passphrase' scores $score out of 100."
		if [ $score -lt 25 ]
			then color="red"
			elif [ $score -ge 25 ] && [ $score -lt 50 ]
			then color="orange"
			elif [ $score -ge 50 ] && [ $score -lt 75 ]
			then color="yellow"
			elif [ $score -ge 75 ]
			then color="green"
		fi

	else #populate variables to display error messages on screen
		color="red"
		message="$checkresult. Try again." 
		entrytext="" #leave the example text blank to save the time of deleting it
	fi

	#display the passphrase score or error message on screen
	osd_cat \
	--pos=middle \
	--align=center \
	--color=$color \
	--shadow=2 \
	--font='-*-liberation sans-*-r-*-*-24-*-*-*-*-*-*-*' \  #change the font size here (24) to fit the screen
	--barmode=percentage \
	--percentage=$score \
	--text="$message" \
	--delay=3

done
