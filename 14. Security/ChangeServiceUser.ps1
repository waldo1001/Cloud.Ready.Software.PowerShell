$NewUser = 'NAVServiceUser'
$FullUserName = "$([net.dns]::GetHostName())\$NewUser"
$Password = 'P@ssword1'
$ServerInstance = 'DynamicsNAV90'

$null = Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1' -WarningAction SilentlyContinue 

#Create user
$Computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"

$CreateNewUser = $Computer.Create("User", $NewUser)
$CreateNewUser.SetPassword($Password)
$CreateNewUser.SetInfo()
$CreateNewUser.FullName = "New user by Powershell"
$CreateNewUser.SetInfo()
$CreateNewUser.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD
$CreateNewUser.SetInfo()

$NewUserSID = ([wmi] "Win32_userAccount.Domain='$([Net.dns]::GetHostName())',Name='$NewUser'").sid

#Grant seLogonRights
$computerName = [net.dns]::GetHostName()
$username = $NewUser
Invoke-Command -ComputerName $computerName -Script {
  param([string] $username)
  $tempPath = [System.IO.Path]::GetTempPath()
  $import = Join-Path -Path $tempPath -ChildPath "import.inf"
  if(Test-Path $import) { Remove-Item -Path $import -Force }
  $export = Join-Path -Path $tempPath -ChildPath "export.inf"
  if(Test-Path $export) { Remove-Item -Path $export -Force }
  $secedt = Join-Path -Path $tempPath -ChildPath "secedt.sdb"
  if(Test-Path $secedt) { Remove-Item -Path $secedt -Force }
  try {
    Write-Host ("Granting SeServiceLogonRight to user account: {0} on host: {1}." -f $username, $computerName)
    $sid = ((New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier])).Value
    secedit /export /cfg $export
    $sids = (Select-String $export -Pattern "SeServiceLogonRight").Line
    foreach ($line in @("[Unicode]", "Unicode=yes", "[System Access]", "[Event Audit]", "[Registry Values]", "[Version]", "signature=`"`$CHICAGO$`"", "Revision=1", "[Profile Description]", "Description=GrantLogOnAsAService security template", "[Privilege Rights]", "SeServiceLogonRight = *$sids,*$sid")){
      Add-Content $import $line
    }
    secedit /import /db $secedt /cfg $import
    secedit /configure /db $secedt
    gpupdate /force
    Remove-Item -Path $import -Force
    Remove-Item -Path $export -Force
    Remove-Item -Path $secedt -Force
  } catch {
    Write-Host ("Failed to grant SeServiceLogonRight to user account: {0} on host: {1}." -f $username, $computerName)
    $error[0]
  }
} -ArgumentList $username


#Rights on ProgramData directory
#download: https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85
#be sure to unblock the zipfile before you unzip!!
Import-Module ntfssecurity
Add-NTFSAccess -Path 'C:\ProgramData\Microsoft\Microsoft Dynamics NAV' `
    -Account $FullUserName `
    -AccessRights FullControl 

#Rights on SQL Server
$ServerInstanceObject = Get-NAVServerInstance4 -ServerInstance $ServerInstance

Invoke-SQL -SQLCommand "CREATE LOGIN [$FullUserName] FROM WINDOWS WITH DEFAULT_DATABASE=[master]"
Invoke-SQL -SQLCommand "CREATE USER [$FullUserName] FOR LOGIN [$FullUserName]"
Invoke-SQL -SQLCommand "CREATE USER [$FullUserName] FOR LOGIN [$FullUserName]" -DatabaseName $ServerInstanceObject.DatabaseName
Invoke-SQL -SQLCommand "ALTER ROLE [db_owner] ADD MEMBER [$FullUserName]" -DatabaseName $ServerInstanceObject.DatabaseName

#Change NetTCPPortSharing - allowed user
$NetTCPPortSharingConfigFile = "$((Get-WmiObject win32_service | ?{$_.Name -like 'NetTcpPortSharing'}).PathName).config"
$NetTCPPortSharingConfig = Get-Content $NetTCPPortSharingConfigFile | Out-String
$NetTCPPortSharingConfig = $NetTCPPortSharingConfig.Replace('<!-- Below are some sample config settings: ','')
$NetTCPPortSharingConfig = $NetTCPPortSharingConfig.Replace('    -->','')
$NetTCPPortSharingConfig = $NetTCPPortSharingConfig.Replace('                // LocalSystem account','')
$NetTCPPortSharingConfig = $NetTCPPortSharingConfig.Replace('                // LocalService account','')
$NetTCPPortSharingConfig = $NetTCPPortSharingConfig.Replace('                // Administrators account','')
$NetTCPPortSharingConfig = $NetTCPPortSharingConfig.Replace('                // Network Service account','')
$NetTCPPortSharingConfig = $NetTCPPortSharingConfig.Replace('                // IIS_IUSRS account (Vista only)','')
[xml]$MyNetTcpPortSharingConfigXML = $NetTCPPortSharingConfig

#todo: if element exists: don't add it
$newElement = $MyNetTcpPortSharingConfigXML.CreateElement("add")
$NewAttribute = $MyNetTcpPortSharingConfigXML.CreateAttribute("securityIdentifier")
$NewAttribute.Value = $NewUserSID
$newElement.Attributes.Append($NewAttribute)
$MyNetTcpPortSharingConfigXML.configuration.'system.serviceModel.activation'.'net.tcp'.allowAccounts.AppendChild($newElement)

$newElement = $MyNetTcpPortSharingConfigXML.CreateElement("add")
$NewAttribute = $MyNetTcpPortSharingConfigXML.CreateAttribute("securityIdentifier")
$NewAttribute.Value = $NewUserSID
$newElement.Attributes.Append($NewAttribute)
$MyNetTcpPortSharingConfigXML.configuration.'system.serviceModel.activation'.'net.pipe'.allowAccounts.AppendChild($newElement)
$MyNetTcpPortSharingConfigXML.OuterXml

$MyNetTcpPortSharingConfigXML.Save($NetTCPPortSharingConfigFile)
#notepad $NetTCPPortSharingConfigFile

#restart service
#Get-NAVServerInstance | Set-NAVServerInstance -Stop
get-service NetTcpPortSharing | Restart-Service -Force

#Change ServiceAccount
$EncryptedPassword = ConvertTo-SecureString –String $Password –AsPlainText -Force
$Credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $NewUser, $EncryptedPassword

$CurrentServerInstance = get-NAVServerInstance -ServerInstance 'DynamicsNAV90'
$CurrentServerInstance | Set-NAVServerInstance -Stop 
$CurrentServerInstance | Set-NAVServerInstance -ServiceAccount User -ServiceAccountCredential $Credential 
$CurrentServerInstance | Set-NAVServerInstance -start