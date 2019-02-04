#!/bin/sh
#--------------------General notes/checks for the script--------------------
#Make sure you have a reliable Internet connection before running this script
wget -q --spider http://google.com
if [ $? -ne 0 ];
then
    echo "You are offline."
    echo "Please make sure that you have a reliable Internet connection before running this script."
    exit
fi
#--------------------



read -p "Do you know the hostname of a target? Enter 'yes' or 'no': " KNOWN
if [ "$KNOWN" = "yes" ];
then
    	read -p "Hostname of a target: " HOSTNAME
        TARGET=$HOSTNAME
else
        read -p "IP address of a target: " IP
        TARGET=$IP
fi



PORTSCAN_RESULT=portscan-$TARGET-$(date +"%m-%d-%Y-%T").txt
> $PORTSCAN_RESULT

echo "---------- Port scan without host discovery ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan 100 most common ports (Fast) ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -F $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan all 65535 ports ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -p- $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Detect OS and Services ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -A $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Standard service detection ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -sV $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan using TCP connect ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -sT $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan using TCP SYN scan (default) ---------- " | tee -a $PORTSCAN_RESULT
sudo nmap -Pn -sS $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan UDP ports ---------- " | tee -a $PORTSCAN_RESULT
sudo nmap -Pn -sU -p 123,161,162 $TARGET >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT



echo "Open $PORTSCAN_RESULT file to see the result of the port scan." 
