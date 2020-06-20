$localization = 'be'

$bcArtifactsCtx = New-AzStorageContext -StorageAccountName bcartifacts -Anonymous

$onpremArtifacts = Get-AzStorageBlob -Context $bcArtifactsCtx -Container onprem

#OnPrem
$onpremArtifacts |
Where-Object { $_.Name.EndsWith("/$localization") } |
Sort-Object { [Version]($_.name.Split('/')[0]) }

#Sandbox
$sandboxArtifacts = Get-AzStorageBlob -Context $bcArtifactsCtx -Container sandbox
$sandboxArtifacts |
Where-Object { $_.Name.EndsWith("/$localization") } |
Sort-Object { [Version]($_.name.Split('/')[0]) }

#GetLatestBE
$onpremArtifacts | 
Where-Object { $_.Name.EndsWith("/$localization") } | 
Sort-Object { [Version]($_.name.Split('/')[0]) } | 
Select-Object -Last 1


$insiderSasToken = "?sv=2019-07-07&ss=b&srt=sco&st=2020-06-08T17%3A10%3A16Z&se=2020-07-08T17%3A10%3A00Z&sp=rl&sig=WUdHPCjdFNuhX94d%2F5BdJzRMTOlRuqIzC0mIPT36dc4%3D"
$insiderContext = New-AzStorageContext -StorageAccountName bcinsider -SasToken $insiderSasToken

$bcArtifacts = Get-AzStorageBlob -Context $insiderContext -Container sandbox


# $insiderSasToken = "?sv=2019-07-07&ss=b&srt=sco&st=2020-06-08T17%3A10%3A16Z&se=2020-07-08T17%3A10%3A00Z&sp=rl&sig=WUdHPCjdFNuhX94d%2F5BdJzRMTOlRuqIzC0mIPT36dc4%3D"
# $insiderContext = New-AzStorageContext -StorageAccountName bcinsider -SasToken $insiderSasToken
