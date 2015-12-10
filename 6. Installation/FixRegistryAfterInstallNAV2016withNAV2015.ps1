$BaseReg90 = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', [net.dns]::GetHostName())
$RegKey90  = $BaseReg90.OpenSubKey('SOFTWARE\Microsoft\MMC\SnapIns\FX:{BA484C42-ED9A-4bc1-925F-23E64E686FCE}')

$BaseReg80 = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', [net.dns]::GetHostName())
$RegKey80 = $basereg80.CreateSubKey('SOFTWARE\Microsoft\MMC\SnapIns\FX:{BA484C41-ED9A-4bc1-925F-23E64E686FCE}')

foreach($RegKeyValue90 in $RegKey90.GetValueNames()){  
    $value80 = $RegKey90.GetValue($RegKeyValue90)

    if ($value80 -match '\\90\\'){
        $value80 = $value80 -replace '\\90\\','\80\'
    }
    if ($value80 -match 'ManagementUI, Version=9.0.0.0'){
        $value80 = $value80 -replace 'ManagementUI, Version=9.0.0.0','ManagementUI, Version=8.0.0.0'
    }
    if ($value80 -match 'BA484C42-ED9A-4bc1-925F-23E64E686FCE'){
        $value80 = $value80 -replace 'BA484C42-ED9A-4bc1-925F-23E64E686FCE','BA484C41-ED9A-4bc1-925F-23E64E686FCE'
    }

    $regkey80.SetValue($RegKeyValue90, $value80)
}

foreach($RegKeySubKey90 in $RegKey90.GetSubKeyNames()){
    write-host $RegKeySubKey90

    $RegKey80.CreateSubKey($RegKeySubKey90)
}

$msc80file = "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft Dynamics NAV Server.msc"
(get-content $msc80file).Replace('ba484c42-ed9a-4bc1-925f-23e64e686fce','ba484c41-ed9a-4bc1-925f-23e64e686fce') | Set-Content $msc80file
