#Install Git
$GitExec = 'C:\DOWNLOAD\Git.exe'
$GitDownloadURL = 'https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.3/Git-2.11.0.3-64-bit.exe'

Invoke-WebRequest $GitDownloadURL -OutFile $GitExec
Start-Process -FilePath $GitExec -ArgumentList "/VERYSILENT"


#CopyDropboxFolder
$ALSamplesOnDropbox = 'https://dl-web.dropbox.com/installer?authenticode_sign=True&build_no=18.4.32&juno=True&juno_use_program_files=True&plat=win&tag=eyJUQUdTIjoiREJQUkVBVVRIOjptc2llOjplSndOeThFS2drQVFBTkJma1RsSHpPek83RXpkbzhKQUNJeHVJcmpRR21td2R0RG8zX1AtM2hmYXpfUm9wdkVaQjlnWFVNMzNLcjNyVjMyODNsbzd4ZEtsODZGY3VNT0wwdExQVzJJVFZRMUJZRk5BamptbmNXaFN0MlpDSmxYeEVsZ0M3dGlSOTJhQ3F6WW5HSlNkaU5qdkR3OXpJQkV-QE1FVEEifQ&tag_token=AFwGRXyc0r87R2jXxKHV74_pLsMkSRfyOO1l6k8V--vw0A'
$DropboxExec = 'C:\DOWNLOAD\Dropbox.exe'
Invoke-WebRequest $ALSamplesOnDropbox -OutFile $DropboxExec
Start-Process -FilePath $DropboxExec
 

#Install waldo's modules
Find-Module | where author -eq 'waldo' | Install-Module