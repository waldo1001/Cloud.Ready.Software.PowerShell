$StorageDirectory = 'c:\Temp'

$WebSite = Invoke-WebRequest -Uri http://directionsemea.com/media/mannheim-2015/presentations-from-directions-emea-2015-in-mannheim/

$WebSite.Links | 
    where href -like '*/media/*' | 
        where {-not($_.href -like '*/')} |
            select href | foreach {
                $url = 'http://www.directionsemea.com' + $_.href
                
                $Filename = [io.path]::GetFileName($url)
                              
                $webclient = New-Object System.Net.WebClient
                $file = "$StorageDirectory\$Filename"

                $webclient.DownloadFile($url,$file)
                
            }


