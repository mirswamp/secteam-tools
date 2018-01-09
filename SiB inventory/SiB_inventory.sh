#!/bin/sh
INVENTORY_FILE=SiB_inventory-$(date +"%m-%d-%Y").txt
> $INVENTORY_FILE



#Spin up CentOS6-minimal install and make a list of installed packages 
#rpm -qa | sort > installed_packages_CentOS6_minimal.txt
#Copy the list of packages installed in CentOS6-minimal to the main inventory file
echo "#########################################" >> $INVENTORY_FILE
echo "  Packages installed in CentOS6-minimal  " >> $INVENTORY_FILE
echo "#########################################" >> $INVENTORY_FILE
cat installed_packages_CentOS6_minimal.txt >> $INVENTORY_FILE
echo >> $INVENTORY_FILE



#Spin up CentOS7-minimal install and make a list of installed packages
#rpm -qa | sort > installed_packages_CentOS7_minimal.txt
#Copy the list of packages installed in CentOS7-minimal	to the main inventory file
echo "#########################################" >> $INVENTORY_FILE
echo "  Packages installed in CentOS7-minimal  " >> $INVENTORY_FILE
echo "#########################################" >> $INVENTORY_FILE
cat installed_packages_CentOS7_minimal.txt >> $INVENTORY_FILE
echo >>	$INVENTORY_FILE



#Set up scripts and .spec files for SWAMP-in-a-Box RPMs that install packages
#from "deployment" repository (mentioned in CYB-515 ticket)
mkdir files_with_yum_installs
wget --quiet https://raw.githubusercontent.com/mirswamp/deployment/master/swampinabox/distribution/repos/set-up-swampcs.bash -P files_with_yum_installs
wget --quiet https://raw.githubusercontent.com/mirswamp/deployment/master/swamp/installer/SPECS/swampinabox-backend.spec -P files_with_yum_installs
wget --quiet https://raw.githubusercontent.com/mirswamp/deployment/master/swamp/runtime-installer/SPECS/swamp-rt-perl.spec -P files_with_yum_installs
wget --quiet https://raw.githubusercontent.com/mirswamp/deployment/master/swamp/swamp-web-server-installer/SPECS/swamp-web-server.spec -P files_with_yum_installs
wget --quiet https://raw.githubusercontent.com/mirswamp/deployment/master/swampinabox/singleserver/sbin/yum_install.bash -P files_with_yum_installs

#grep 'yum install' and 'yum_install' from the above files
#remove duplicate occurrences and remove extra white splace & blank lines  
echo "#############################################################" >> $INVENTORY_FILE
echo "  Packages from set up scripts and .spec files for SiB RPMs  " >> $INVENTORY_FILE
echo "#############################################################" >> $INVENTORY_FILE
> temp_inventory.txt
grep -rw files_with_yum_installs -e 'yum -y install' | awk '{ $1="";$2="";$3="";$4="";print}' | sed 's/\s/\n/g' >> temp_inventory.txt
grep -rw files_with_yum_installs -e 'yum_install' | awk '{ $1="";print}' | sed 's/\s/\n/g' >> temp_inventory.txt
cat temp_inventory.txt | sed 's/yum_install()//g' | sed 's/--nogpgcheck//g' | sed 's/{//g' | sed 's/$*//g' | sed 's/\*//g' | sort -u >> $INVENTORY_FILE
echo >>	$INVENTORY_FILE



#Refer Appendix A from SiB administrator manual for high-level description of SWAMP-in-a-Box's dependencies 
#https://platform.swampinabox.org/siab-latest-release/administrator_manual.pdf
echo "#################################################" >> $INVENTORY_FILE
echo "  Dependencies from SiB Admin Manual-Appendix A  " >> $INVENTORY_FILE
echo "#################################################" >> $INVENTORY_FILE 
sort -u dependencies_SiB_admin_manual.txt >> $INVENTORY_FILE
echo >>	$INVENTORY_FILE



#For "singleserver" SWAMP-in-a-Box installs, additional dependencies include
echo "##########################################################" >> $INVENTORY_FILE
echo "  Additional dependencies for "singleserver" SiB install  " >> $INVENTORY_FILE
echo "##########################################################" >> $INVENTORY_FILE
sort -u additional_dependencies_singleserver_SiB.txt >> $INVENTORY_FILE
echo >>	$INVENTORY_FILE



#Remove temporary directory i.e. files_with_yum_installs and a temorary inventory file i.e. temp_inventory.txt
rm -rf files_with_yum_installs temp_inventory.txt



#Display a complete list of dependency
cat $INVENTORY_FILE
