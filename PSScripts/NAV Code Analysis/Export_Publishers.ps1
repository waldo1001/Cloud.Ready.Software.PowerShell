$ObjectFile = "C:\temp\13.0.24012.0-W1.txt"
$ExportTo = "C:\temp\Publishers"

$ModuleToolAPIPath = "$env:USERPROFILE\Dropbox\GitHub\Waldo.Model.Tools\Revision.Model.Tools.Library - NoLicense"
#import-module (join-path $ModuleToolAPIPath NavModelToolsAPI.dll) -WarningAction SilentlyContinue -ErrorAction Stop

if (!(Test-Path $ExportTo)){
    New-Item -Path $ExportTo -ItemType Directory
}

Export-NAVEventPublishers `
    -ModuleToolAPIPath $ModuleToolAPIPath `
    -SourceFile $ObjectFile `
    -DestinationFolder $ExportTo `
    -Verbose

start $ExportTo 