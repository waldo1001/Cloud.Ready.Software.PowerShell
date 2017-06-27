function Export-NAVALfromNAVApplicationObject
{
    param (
        [String]$ServerInstance,
        [String]$WorkingFolder,
        [String]$TargetPath,
        [String]$Filter,
        [Switch]$OpenResultFolderInVSCode,
        [int]$extensionStartId = 70000000
          )
 
    #Import NAV Modules - we need the $NAVIde
    Import-NAVModules | Out-Null
    if ([String]::IsNullOrEmpty($NAVIDE)){
        Write-Error "Please make sure the module 'Microsoft.Dynamics.NAV.Model.Tools' is present on this machine"
    }

    #Initialize variables
    $NAVServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance

    $LogFile = "$WorkingFolder\Log_ExportFile.txt"
    $ExportFile = "$WorkingFolder\ExportFile.txt"
    if (Test-Path "$WorkingFolder\navcommandresult.txt") {Remove-Item "$WorkingFolder\navcommandresult.txt"}
    if (test-path $ExportFile) {remove-item $ExportFile}
 
    #Get DatabaseServer
    $Servername = $NAVServerInstanceObject.DatabaseServer
    if (-not([string]::IsNullOrEmpty($NAVServerInstanceObject.DatabaseInstance))){
        $Servername += "\$($NAVServerInstanceObject.DatabaseInstance)"
    }

    $NAVFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\71\RoleTailored Client'
    $exportfinsqlcommand = """$NAVIde"" command=ExportToNewSyntax,file=$ExportFile,servername=""$Servername"",database=""$($NAVServerInstanceObject.DatabaseName)"",Logfile=$LogFile"
    
    if ($Filter -ne "")
        {$exportfinsqlcommand = "$exportfinsqlcommand,filter=$Filter"} 
 
    $Command = $exportfinsqlcommand
 
    Write-Host -ForegroundColor Green "Export Objects with:" 
    Write-host -ForegroundColor Gray "  $Command"
    cmd /c $Command
 
    $ExportFileExists = Test-Path "$ExportFile"
    If (-not $ExportFileExists) 
    {
            write-error "Error on exporting to $ExportFile.  Look at the information below."
            if (Test-Path "$WorkingFolder\navcommandresult.txt"){Type "$WorkingFolder\navcommandresult.txt"}
            if (Test-Path $LogFile) {type $LogFile}
            break
    }
    else
    {
        $NAVObjectFile = Get-ChildItem $ExportFile
        if ($NAVObjectFile.Length -eq 0)
        {
            Remove-Item $NAVObjectFile
        } 
 
        if (Test-Path "$WorkingFolder\navcommandresult.txt")
        {
            Type "$WorkingFolder\navcommandresult.txt"
        }
    }

    #Split
    $SplitDir = "$WorkingFolder\Split"
    Write-Host "Splitting objects to $SplitDir"
    Split-NAVApplicationObjectFile -Source $ExportFile -Destination $SplitDir -Force 

    #Convert
    $NAVFolder = [io.path]::GetDirectoryName($NAVIDE)
    $Convertcommand = """$NAVFolder\txt2al.exe"" --source=""$SplitDir"" --target=""$TargetPath"" --rename --extensionStartId=$extensionStartId"
    $Command = $Convertcommand
 
    Write-Host -ForegroundColor Green "Convert objects with:" 
    Write-host -ForegroundColor Gray "  $Command"
    try{
        cmd /c $Command 
    } catch {
    }
    #Open
    if($OpenResultFolderInVSCode){
        code $TargetPath
    } else {
        start $TargetPath
    }
} 