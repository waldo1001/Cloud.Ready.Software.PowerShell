# Import settings
. (Join-Path $PSScriptRoot '_Settings.ps1')

$WebServiceObjects = Invoke-NAVSQL -ServerInstance $ModifiedServerInstance -SQLCommand "Select * From Object where Name like '%$WebServicePrefix%'" | Select Type, ID, Name

foreach ($WebServiceObject in $WebServiceObjects){
    switch ($WebServiceObject.Type)
    {
        '8' {$ObjectType = 'Page'}
        '5' {$ObjectType = 'CodeUnit'}
        Default {$ObjectType = $null}        
    }

    #if (!([string]::IsNullOrEmpty($ObjectType))){
        if (Get-NAVWebService -ServerInstance $ModifiedServerInstance | where ServiceName -eq $WebServiceObject.Name | where ObjectType -like $ObjectType){
            Remove-NAVWebService -ServerInstance $ModifiedServerInstance -ServiceName $WebServiceObject.Name -ObjectType $ObjectType -Force
        }
        New-NAVWebService -ServerInstance $ModifiedServerInstance -ObjectType $ObjectType -ObjectId $WebServiceObject.ID -ServiceName $WebServiceObject.Name -Published $true
    #}
}

#start web services page to uncheck the "All Tenants"
Start-NAVApplicationObjectInWindowsClient -ServerInstance $ModifiedServerInstance -ObjectType Page -ObjectID 810

