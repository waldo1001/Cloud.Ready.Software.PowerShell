#Source: a comment from "olivier" on my blog: http://www.waldo.be/2015/09/23/dynamics-nav-powershell-creating-an-enhanced-get-navserverinstance-function/
#Author: Olivier (from Christiaens (Belgium))
#Original function name: Get-NAVServerConfig
function Get-NAVServerInstance4
 {
     [CmdletBinding()]
     Param
     (
         [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
         $ServerInstance
     )
     Begin
     {
        $ServerConfigs = @()
     }
     Process
     {
         $ServerInstance | Get-NAVServerInstance | ForEach-Object -Process `
         {
         $ServerConfig = New-Object PSObject
         foreach ($Attribute in $_.Attributes)
         {
            $ServerConfig | Add-Member -MemberType NoteProperty -Name $Attribute.Name -Value $Attribute.Value -Force
         }
         foreach ($Node in ($_ | Get-NavServerConfiguration -AsXml).configuration.appSettings.add)
         {
            $ServerConfig | Add-Member -MemberType NoteProperty -Name $Node.key -Value $Node.value -Force
         }
            $ServerConfigs += $ServerConfig
         }
     }
     End
     {
     return $ServerConfigs
     }

}
