$Object = 'TAB37.txt'
$Encoding = 'ASCII'
$Encoding = 'BigEndianUnicode'
$Encoding = 'Default'
$Encoding = 'OEM'
$Encoding = 'Unicode'
$Encoding = 'UTF32'
$Encoding = 'UTF7'
$Encoding = 'UTF8'
$Encoding = 'NoEncodingParam'

if (-not(Test-path "C:\_Workingfolder\TestLanguages\$Encoding\")){
    New-Item "C:\_Workingfolder\TestLanguages\$Encoding\" -ItemType directory
}

Export-NAVApplicationObjectLanguage `    -Source (join-path 'C:\_Workingfolder\TestLanguages\Distri93\' $Object) `    -Destination "C:\_Workingfolder\TestLanguages\$Encoding\Distri93_Languages.txt" `    -LanguageId ENU,NLB,FRB `    -Force `    #-Encoding $Encoding

Export-NAVApplicationObjectLanguage `    -Source (join-path 'C:\_Workingfolder\TestLanguages\NAV_9_46290_BE\' $Object) `    -Destination "C:\_Workingfolder\TestLanguages\$Encoding\NAV_9_46290_BE_Languages.txt" `    -LanguageId ENU,NLB,FRB `    -Force `    #-Encoding $Encoding

Export-NAVApplicationObjectLanguage `    -Source (join-path 'C:\_Workingfolder\TestLanguages\NAV_10_RTM_BE\' $Object) `    -Destination "C:\_Workingfolder\TestLanguages\$Encoding\NAV_10_RTM_BE_Languages.txt" `    -LanguageId ENU,NLB,FRB `    -Force `    #-Encoding $Encoding

Export-NAVApplicationObjectLanguage `    -Source (join-path 'C:\_Workingfolder\TestLanguages\MergeResult\' $Object) `    -Destination "C:\_Workingfolder\TestLanguages\Encoding_$Encoding\MergeResult_Languages.txt" `    -LanguageId ENU,NLB,FRB `    -Force `    -Encoding $Encoding

#& 'C:\Program Files\Araxis\Araxis Merge\Merge.exe' "C:\_Workingfolder\TestLanguages\$Encoding\NAV_9_46290_BE_Languages.txt" "c:\_Workingfolder\TestLanguages\$Encoding\Distri93_Languages.txt" "C:\_Workingfolder\TestLanguages\$Encoding\NAV_10_RTM_BE_Languages.txt"

