$from = "C:\Users\ericw\Dropbox (Personal)\GitHub\Cloud.Ready.Software.PowerShell\PSModules\Cloud.Ready.Software.NAV\Import-NAVModules.ps1"

$pssession = Get-NavContainerSession navserver

copy-item -Path $from -ToSession $pssession -Destination 'c:\program files\windowspowershell\modules\Cloud.Ready.Software.NAV\1.0.3.4\' -force