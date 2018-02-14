function Get-RDHHelp {
    <#
    .SYNOPSIS
    Gets help from this module
        
    .PARAMETER Examples
    Show examples
    
    .PARAMETER Passthru
    Return the "help" object to be able to tranfrom or manipulate the object yourself    
    #>
    param(
        [Switch] $Examples,
        [Switch] $Passthru
    )
    
    if ($Passthru){
        get-command -module crs.RemoteNAVDockerhostHelper | Get-Help -Examples:$Examples
    } else {
        get-command -module crs.RemoteNAVDockerhostHelper | Sort-Object Noun | Get-Help | select Name, Synopsis, examples | ForEach-Object {            
            Write-Host -ForegroundColor Green -Object "$($_.Name)"
            if ($Examples){
                Get-Help $_.Name -Examples
            } else {
                Write-Host -ForegroundColor Gray "  $($_.Synopsis)"
            }            
        }
    }  
}