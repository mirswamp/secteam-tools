#!/bin/sh
#--------------------General notes/checks for the script--------------------
#Make sure you have a reliable Internet conection before running this script
wget -q --spider http://google.com
if [ $? -ne 0 ];
then
    echo "You are offline."
    echo "Please make sure that you have a reliable Internet connection before running this script."
    exit
fi
#--------------------



read -p "Hostname of a target: " HOSTNAME
read -p "IP address of a target: " IP



PORTSCAN_RESULT=result_PortScan-$(date +"%m-%d-%Y").txt
> $PORTSCAN_RESULT

echo "---------- Port scan using target IP address ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Port scan using target hostname ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn $HOSTNAME >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan 100 most common ports (Fast) ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -F $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan all 65535 ports ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -p- $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Detect OS and Services ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -A $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Standard service detection ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -sV $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan using TCP connect ----------" | tee -a $PORTSCAN_RESULT
nmap -Pn -sT $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan using TCP SYN scan (default) ---------- " | tee -a $PORTSCAN_RESULT
sudo nmap -Pn -sS $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT

echo "---------- Scan UDP ports ---------- " | tee -a $PORTSCAN_RESULT
sudo nmap -Pn -sU -p 123,161,162 $IP >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT
echo >> $PORTSCAN_RESULT



echo "Open $PORTSCAN_RESULT file to see the result of the port scan." 
