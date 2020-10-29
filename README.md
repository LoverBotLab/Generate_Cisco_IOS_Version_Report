# Generate_Cisco_IOS_Version_Report
This is a PowerShell script for generating report of Cisco IOS Version &amp; basic device details like hostname, hardware details &amp; device up time. I'm using command line putty tool called plink.exe for SSH connection.

You can download plink from (_https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html Or https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe_)

### Working
1 - In a first place this PowerShell script run "show version" command on given device list & saves it in text file.

2 - Then PowerShell script access those newly generated text file & extract info into _.csv_ format.

### Other Usage
You can edit this code in any way you want. By doing simple changes in this script you can also do below activities on your Network device.

Change command in _cmd.txt_ to "*Show running-config*" so that you can get current running configuration of all devices. Then you can check any Vulnerable Configuration / command within that backup file & export list of vulnerable device with their command or appropriate result. 
