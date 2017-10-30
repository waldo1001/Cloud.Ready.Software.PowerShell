$imageNameTag = "navdocker.azurecr.io/dynamics-nav:devpreview"
$password = "P@ssword1"
$locale = "en-US"
$licensefile = "mylicense.flf"
$DockerDir = "C:\_Docker"
$MyDir = "C:\_Docker\myfolder"

docker login navdocker.azurecr.io `
       -u 7cc3c660-fc3d-41c6-b7dd-dd260148fff7 `
       -p G/7gwmfohn5bacdf4ooPUjpDOwHIxXspLIFrUsGN+sU=

if (!(Test-Path "$MyDir\$licensefile")) {
    throw "You need to place a license file called $licensefile in the folder"
}

if (Get-Container navserver) {
    Write-Host "Remove old container"
    docker rm navserver -f | Out-Null
}

Write-Host "Pull new container image for $imageNameTag"
docker pull $imageNameTag

Write-Host "Run container"
$containerid = docker run `
                      --name navserver `
                      --hostname navserver `
                      --memory 3G `
                      --env accept_eula=Y `
                      --env useSSL=N `
                      --env username="admin" `
                      --env password=$password `
                      --env ExitOnerror=N `
                      --env locale=$locale `
                      --env LicenseFile="c:\run\my\$licensefile" `
                      --volume ${DockerDir}:c:\appvalidation `
                      --volume ${MyDir}:c:\run\my `
                      --detach `
                      $imageNameTag
if ($LastExitCode -ne 0) {
    throw "Docker run error"
}

Write-Host "Waiting for container to become healthy"
while (!(Get-Container navserver).Status.Contains('healthy')) {
    Start-Sleep -Seconds 2
}

Write-Host "Start Web Client"
Start-Process -FilePath "http://navserver/NAV/WebClient"

Write-Host "Start NAV Container prompt"
$prog="cmd.exe"
$params=@("/C";"docker exec -it navserver powershell -noexit c:\run\my\prompt.ps1")
Start-Process $prog $params 

Write-Host "Container Output:"
docker logs navserver | % { Write-Host $_ }
