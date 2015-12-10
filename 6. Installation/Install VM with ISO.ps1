#Run this script as administrator!!
$VMName     = 'Win2012R2+SQL2014+Office2013'
$VMSnapshot = 'Win2012R2+SQL2014+Office2013'
$ISOPath    = 'C:\$Installs\NAVCorfuCTP12.iso'


#Checkpoint-VM -Name $VMName
#Get-VMSnapshot -VMName $VMName -Name $VMSnapshot | Restore-VMSnapshot -Confirm:$true 

#Set-VMDvdDrive -VMName $VMName -Path $ISOPath

Start-VM -Name $VMName
