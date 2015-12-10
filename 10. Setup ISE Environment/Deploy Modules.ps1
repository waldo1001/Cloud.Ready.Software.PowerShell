$PSModulePaths = ($env:PSModulePath).Split(';')

$PSUserModulePath = $PSModulePaths.Where({$_ -Match 'Users'})

if ([string]::IsNullOrEmpty($PSUserModulePath)){
    write-error 'Module Path for Users not found.'
    break
}

$waldoModulePath = join-path $PSUserModulePath 'Microsoft.Dynamics.Nav.waldo'

if (test-path $waldoModulePath) {
    $Overwrite = Read-Host -Prompt "'$waldoModulePath' already exists, overwrite? (y/n)"
    if ($Overwrite -in 'n','N','no','neen'){
        write-warning 'Nothing executed'
        break
    } elseif (-not($overwrite -in 'y','Y','yes','ja')){
        write-error 'Invalid input'
        break
    }
}

$null = Remove-Item -Path $waldoModulePath -Recurse
$null = New-Item -Path $waldoModulePath -ItemType directory -Force 

$CurrentPath = Get-Item $psise.CurrentFile.FullPath
get-childitem (join-path $CurrentPath.Directory 'Modules') | 
    copy-item -Destination $waldoModulePath -Recurse -Force

