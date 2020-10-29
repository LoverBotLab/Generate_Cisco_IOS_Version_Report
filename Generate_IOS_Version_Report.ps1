# Below code use to store current date & time in $reportTime variable.
$reportTime = Get-Date -Format "dd-MM-yyyy HHmm"


#Below code is used to test required Folder existance.
if (-Not (Test-Path .\Log\$reportTime)){
    mkdir .\Log\$reportTime
}

if (-Not (Test-Path .\Reports)){
    mkdir .\Reports
}

cls

Write-Host '

----------------------Disclaimer-----------------------------

 Hello Users, I have created this script for getting detailed
 IOS version of Cisco devices. Feel free to modify it but dont
 use this script for malisious activity & use it on your own risk
 I have tested this script against various types of Cisco Routers
 & Switches so if you observed any issue, then feel free to
 contact me.

-------------------------------------------------------------

Author      :- Preetam Patankar
Email-ID    :- web.preetam@gmail.com

-------------------------------------------------------------'



#Below code use to store input like username, password, iplist & log directory path
$username = Read-Host -Prompt 'Input your username'
Write-Host "Welcome '$username', please enter your password"
$password = Read-Host -Prompt 'Input your password'
$deviceList = '.\ipList.txt'
$logPath = '.\Log\'+$reportTime


#With the help of commandline Putty 'plink.exe' below for-loop extract 'show version' result from given ip list
# And store it into respective path with IP_ADDRESS.txt file name.
ForEach ($targetComputer in (Get-Content $deviceList)) {
plink -ssh $username@$targetComputer -pw $password -batch -m .\cmd.txt >> $logPath\$targetComputer.txt
}
#-----End


#Below code generates blank report template
$Tab = [char]9
$report_column_heading = "Hostname" + $Tab + "IP Address"  + $Tab + "IOS File" + $Tab + "IOS Version" + $Tab + "Hardware" + $Tab + "Device Up Time"
$report_column_heading>>.\Reports\Report_$reportTime.csv



#Below for-loop extract required details from previous taken results
# And store it into respective reports path with 'Report_$reportTime.csv' file name.
ForEach ($targetComputer in (Get-Content $deviceList)) {

$output = Get-Content $logPath\$targetComputer.txt -Raw

$iosFile = [regex]::match($output ,':(.*)\"').Groups[1].Value
$IosVer_full = [regex]::match($output ,'Cisco IOS Software(.*)').Groups[1].Value
$IosVer = [regex]::match($IosVer_full ,', Version (.*)\)').Groups[1].Value
$hostname = [regex]::match($output ,'(.*) uptime').Groups[1].Value
$hardware = [regex]::match($output ,'isco (.*) with').Groups[1].Value
$deviceUpTime = [regex]::match($output ,'uptime is (.*)s').Groups[1].Value

$result =  $hostname + $Tab + $targetComputer + $Tab + $iosFile + $Tab + $IosVer+')'+ $Tab + $hardware + $Tab + $deviceUpTime+'s'
$result>>.\Reports\Report_$reportTime.csv


#If any ip address has some issue while logging into device or extracting specific information,
#then below code will make note 'Something Error' in specific cell
$hostname = 'Something Error'
$iosFile = 'Something Error'
$IosVer_full = 'Something Error'
$IosVer = 'Something Error'
$hardware = 'Something Error'
$deviceUpTime = 'Something Error'

}