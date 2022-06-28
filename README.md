# passphrase-strength-checker
A simple passphrase (or password) strength checker, written in bash, meant to be run on a standalone linux VM or bare metal machine, kiosk style.  Many password strength checkers are online, and many of us will be hesitant to submit passwords to online sources.  This was written to demonstrate principles of strong passphrases at a STEM event.

This has been tested in Fedora 36.  

Convert the .sh file to unix format to run

Requires the libpwquality, rlwrap, and osd_cat packages

Configure the /etc/security/pwquality.conf file to reflect the desired number of pw characters (instructions.txt assumes this is to 15)

Place the .sh script and the instructions.txt files on the user's desktop, and change the line in the .sh script to reflect the user's directory name.

Before you kick off the script, shrink the terminal window to three lines tall, and position it about 1/3 down from the top of the screen. Zoom on the terminal to make the input font bigger.
