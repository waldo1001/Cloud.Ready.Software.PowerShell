Set-location "C:\_Source\Microsoft\MSDyn365BC.Code.History"
Set-location "C:\_Source\MSDyn365BC.Code.History"

& git checkout -q "master"
& git reset --hard "@{u}"
& git clean -df
& git pull