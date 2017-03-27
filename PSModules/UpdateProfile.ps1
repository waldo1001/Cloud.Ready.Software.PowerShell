if (!(Test-Path $PROFILE)) {
   New-Item -Path $PROFILE -Type File -Force
}

if (!(Get-Content $PROFILE | %{$_ -match 'Cloud.Ready.Software.PowerShell.Start-NAVVersionModuleSearch'})) {

"# Cloud.Ready.Software.PowerShell.Start-NAVVersionModuleSearch
if (Get-Command Start-NAVVersionModuleSearch -errorAction SilentlyContinue)
{
   Start-NAVVersionModuleSearch
}" >> $PROFILE

}