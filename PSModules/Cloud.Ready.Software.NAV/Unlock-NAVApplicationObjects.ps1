function Unlock-NAVApplicationObjects
{
   param(
    [String] $ServerInstance
   )

   $ServerInstanceObject = Get-NAVServerInstance4 $ServerInstance -ErrorAction Stop

   if ([string]::IsNullOrEmpty($ServerInstanceObject.DatabaseInstance)){
        $DatabaseServer = $ServerInstanceObject.DatabaseServer + "\" + $ServerInstanceObject.DatabaseInstance
   } Else {
        $DatabaseServer = $ServerInstanceObject.DatabaseServer
   }

   Invoke-SQL `
        -DatabaseServer $DatabaseServer `
        -DatabaseName $ServerInstanceObject.DatabaseName `
        -SQLCommand "UPDATE [$($ServerInstanceObject.DatabaseName)].[dbo].[Object] SET [Locked]=0,[Locked By]=''"
           
}
    
