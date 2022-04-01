Set-location "C:\_Source\Microsoft\MSDyn365BC.Code.History"

& git reset --hard "@{u}"
& git clean -df
& git pull