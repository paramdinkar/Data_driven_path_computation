# Data_driven_path_computation

This is the code to run BaseCase and Non-SDN case.
For the base case we need to run initscripts on each router
For non-SDN case we need to run initscripts on each router and also run scripts in SDN Folder

#################################################################################################
#                                                                                               #
#                                   Base Case                                                   #
#                                                                                               #
#################################################################################################
Initscripts are to install Quagga and Run quagga on the routers
If Quagga is not installed run the following commands:
apt-get update
apt-get install quagga quagga-doc traceroute 

Run Initscript on each Router 
eg. If you want to run it on Router1 you will use the command
sh Router1.sh


#################################################################################################
#                                                                                               #
#                                   Non SDN Case                                                #
#                                                                                               #
#################################################################################################
Initscripts are to install Quagga and Run quagga on the routers
If Quagga is not installed run the following commands:
apt-get update
apt-get install quagga quagga-doc traceroute 

Run Initscript on each Router 
eg. If you want to run it on Router1 you will use the command
sh Router1.sh

After this is done. Go to SDN folder
1) Go to reference/configs.conf
Modify the ethernet interface names and bandwidth as needed. You also need to modify the constant parameters.
2) Run startup.sh on each router
Command : sh startup.sh
3) Run collectinfo.sh in crontab
Command : crontab -e
Add the below line
* * * * * /root/smart-ospf/SDN/collectinfo.sh >> /root/smart-ospf/SDN/linkcost.log 2>&1

Your setup is ready
