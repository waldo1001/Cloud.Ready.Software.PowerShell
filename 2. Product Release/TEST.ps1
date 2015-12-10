


$objectfile     = 'C:\_PowerShell\Scripts\Product Release\Rental\Rental.txt'
$ProductVersion = 'IRM 4.0'
$VersionPrefix  = 'NAVW1','NAVBE','I7','I8','IB','EQM','IRM'


$VersionLIst = 'I7.1,IRM 3.1,M18567'
Release-NAVVersionList -VersionList $VersionLIst -ProductVersion $ProductVersion -Versionprefix $VersionPrefix
$VersionLIst = 'EQM1'
Release-NAVVersionList -VersionList $VersionLIst -ProductVersion $ProductVersion -Versionprefix $VersionPrefix
$VersionLIst = 'I7.3,IB1.0,M18722'
Release-NAVVersionList -VersionList $VersionLIst -ProductVersion $ProductVersion -Versionprefix $VersionPrefix
$VersionLIst = 'M18722'
Release-NAVVersionList -VersionList $VersionLIst -ProductVersion $ProductVersion -Versionprefix $VersionPrefix
