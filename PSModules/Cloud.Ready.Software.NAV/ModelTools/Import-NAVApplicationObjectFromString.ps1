Function Import-NAVApplicationObjectFromString {
    param(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String] $ObjectString,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$false)]
        [String] $LogPath,
        [Parameter(Mandatory=$false)]
        [String] $Filter,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Default','Overwrite','Skip')]
        [String] $ImportAction = 'Default',
        [Parameter(Mandatory=$false)]
        [ValidateSet('Force','No','Yes')]
        [String] $SynchronizeSchemaChanges = 'Yes',
        [Parameter(Mandatory=$false)]
        [String] $NavServerName = ([net.dns]::GetHostName()),
        [Parameter(Mandatory=$false)]
        [Switch] $Confirm = $false
    )

    $Path = join-path $env:TEMP 'TempObjectFile.txt'
    Set-Content -Value $ObjectString -Path $Path -Force

    Import-NAVApplicationObject2 `        -Path $Path `        -ServerInstance $ServerInstance `        -LogPath $LogPath `        -ImportAction $ImportAction `        -SynchronizeSchemaChanges $SynchronizeSchemaChanges `        -Confirm:$Confirm `        -Filter $Filter `        -NavServerName $NavServerName 

    Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
}