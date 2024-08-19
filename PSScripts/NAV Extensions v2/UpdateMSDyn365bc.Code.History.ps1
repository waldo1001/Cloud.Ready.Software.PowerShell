Set-location "C:\_Source\Microsoft\MSDyn365BC.Code.History" -errorAction SilentlyContinue
Set-location "C:\_Source\MSDyn365BC.Code.History" -errorAction SilentlyContinue

& git checkout -q "master"
& git reset --hard "@{u}"
& git clean -df
& git pull