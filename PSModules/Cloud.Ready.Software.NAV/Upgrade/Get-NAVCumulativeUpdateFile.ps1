<#
    .Synopsis
        Downloads a Cumulative Update from the Microsoft Download Center
    .DESCRIPTION
        Based on the Microsoft Dynamics NAV Team Blog, this function is going to download a cumulative update to a download folder.
        The function uses the download helper (Load-NAVCumulativeUpdateHelper)
    .EXAMPLE
        Get-NAVCumulativeUpdateFile -versions 2018 -Locale fr-FR -CountryCode BE -DownloadFolder C:\_Download
    .EXAMPLE
        Get-NAVCumulativeUpdateFile -versions 2018 -CountryCode BE
    .OUTPUT
        - Objects with info about the downloaded cumulative updates
        - the downloaded CU update
        - a JSON file with details about the download
#>
function Get-NAVCumulativeUpdateFile
{
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [String]$CountryCode,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
        [ValidateSet('2013','2013 R2','2015','2016','2017','2018')]
        [String]$version = '2017',
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [String]$CUNo,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [String]$DownloadFolder = $env:TEMP,        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [Switch]$ShowDownloadFolder,
        [Parameter(Mandatory=$false)]        
        [Switch]$GetInfoOnly
    )

    begin {
        $ie = New-Object -ComObject 'internetExplorer.Application'
        $ie.Visible = $true
    }
    process
    {
            
        $url = ''
                
        Write-Verbose "Processing parameters $CountryCode $version $CUNo"
        
        # $feedurl = 'https://blogs.msdn.microsoft.com/nav/category/announcements/cu/feed/'
        $feedurl = 'https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/dea12e4a-4dd3-35e1-2577-45df252a2b9c/rss'
        [regex]$titlepattern = 'Cumulative Update (\d+) .*'
                
        Write-Verbose 'Searching for RSS item' 

        $feed = (Invoke-WebRequest -Uri $feedurl)
        $FeedXML = New-Object -TypeName System.Xml.XmlDocument
        $feedContent = $feed.Content.Substring(1) # for me at least some broken first character in the XML Content
        $FeedXML.LoadXml($feedContent)
        $blogurl = ($feed.SelectNodes("/rss/channel/item") | where title -like "*Cumulative Update*$CUNo*NAV $version*(Build*" | Select-Object -First 1).link
        #{
        #if (!($blogurl)){
        #    $blogurl = $feed.SelectNodes("/rss/channel/item[./category='NAV $version' and ./category='Cumulative Updates']").link | Select-Object -First 1
        #}

        if (!$blogurl) 
        {
            Write-Error -Message 'Blog url not found!'
            return
        }
                
        Write-Verbose "Reading blog page $blogurl"
        $blogarticle = ''
        #$blogarticle = Invoke-WebRequest -Uri $blogurl
        $null = $ie.Navigate($blogurl)
        while ($ie.Busy -eq $true)
        {
            $null = Start-Sleep -Seconds 1
        }
                
        $titlematches = $titlepattern.Matches($ie.Document.title) 
        $updateno = $titlematches.Groups[1]

        Write-Verbose 'Searching KB Url'
        $titlematches = $titlepattern.Matches($ie.Document.title) 
        $updateno = $titlematches.Groups[1]
        $kblink = $ie.Document.links | Where-Object -FilterScript {
            Write-Verbose "Link: $($_.href) id: $($_.id)"
            $_.innerText -match 'KB'
        } | Select-Object -First 1
        $KbHref = $kblink.href

        if (!($KbHref)) {
            $KbHref = $blogurl
        }
        
        Write-Verbose 'Microsoft Download Center link' 
        #$kblink = $blogarticle.Links | Where-Object -FilterScript {
        $kblink = $ie.Document.links | Where-Object -FilterScript {
            Write-Verbose "Link: $($_.href) id: $($_.id)"
            $_.href -match 'download/details.aspx'
        } | Select-Object -First 1

        if (!($kblink)){
            Write-Warning 'No link to Download Center found.. .'
            break
        }

        if ($kblink.search.Contains('familyid=')) {
            $ieX = New-Object -ComObject 'internetExplorer.Application'
            $ieX.Visible = $false
            $null = $iex.Navigate($kblink.href)
            while ($iex.Busy -eq $true) {
                $null = Start-Sleep -Seconds 1
            }

            $ProductID = $iex.LocationURL;
            $ProductID = $ProductID.Substring($ProductID.IndexOf('=') + 1);
            $null = $iex.Quit()
        }
        else {
            $ProductID = $kblink.search.Substring(4)
        }
        
        Write-Verbose "Found Product ID $ProductID"


        Write-Verbose "Loading NAVCumulativeUpdateHelper"
        Load-NAVCumulativeUpdateHelper

        if ($Locale){
            $DownloadLinks = [MicrosoftDownload.MicrosoftDownloadParser]::GetDownloadDetail($ProductID,$Locale) | Select *
        } else {
            $DownloadLinks = [MicrosoftDownload.MicrosoftDownloadParser]::GetDownloadLocales($ProductID) | Select *
        }
        if ($CountryCode){
            $DownloadLinks = $DownloadLinks | where Code -eq $CountryCode
        }

        $BuildSearchString = '(BUILD '
        $BuildStartPos = $ie.Document.body.innerHTML.ToUpper().IndexOf($BuildSearchString) 
        if ($BuildStartPos -gt -1){
            $BuildStartPos = $BuildStartPos + $BuildSearchString.Length
            $BuildEndPos = $ie.Document.body.innerHTML.ToUpper().IndexOf(')',$BuildStartPos)
            $Build = $ie.Document.body.innerHTML.ToUpper().Substring($BuildStartPos,$BuildEndPos - $BuildStartPos)
        } else {
            $build = 'UnknownBuildNo'    
        }

        $null = $ie.Quit()

        foreach ($DownloadLink in $DownloadLinks){

            #Filename        
            switch ($version)
            {
                '2013'   {$Edition = '7.0'}
                '2013 R2' {$Edition = '7.1'}
                '2015'   {$Edition = '8.0'}
                '2016'   {$Edition = '9.0'}
                '2017'   {$Edition = '10.0'}
                '2018'   {$Edition = '11.0'}
                Default  {$Edition = $version}
            }
            $filename = (Join-Path -Path $DownloadFolder -ChildPath ("NAV.$($Edition).$($Build).$($CountryCode).DVD.CU$($updateno.Value)$([io.path]::GetExtension($DownloadLink.DownloadUrl))"))
            $filenameJSON = ([io.path]::ChangeExtension($filename,'json'))
                    
            #set-content -Value 'Just to debug the process - set this line in comment if you don''t want to debug' -Path $filename
            
            if (!($GetInfoOnly)){
                if (-not(Test-Path $filenameJSON)){
                    Write-Verbose "Downloading $($DownloadLink.Code) to $filename" 
                    $null = Start-BitsTransfer -Source $DownloadLink.DownloadUrl -Destination $filename 
                    Write-Verbose 'Hotfix downloaded' 
                } Else {
                    write-warning "File $([io.path]::GetFileName($filenameJSON)) already exists.  Nothing downloaded!"
                }                                           
            }

            if (Test-Path $filename){
                $null = Unblock-File -Path $filename
            }

            $result = New-Object -TypeName System.Object
            $null = $result | Add-Member -MemberType NoteProperty -Name NAVVersion -Value $version
            $null = $result | Add-Member -MemberType NoteProperty -Name CountryCode -Value $DownloadLink.Code
            $null = $result | Add-Member -MemberType NoteProperty -Name CUNo -Value "$updateno"
            $null = $result | Add-Member -MemberType NoteProperty -Name Build -Value $Build
            $null = $result | Add-Member -MemberType NoteProperty -Name KBUrl -Value "$KbHref"
            $null = $result | Add-Member -MemberType NoteProperty -Name ProductID -Value "$ProductID"
            $null = $result | Add-Member -MemberType NoteProperty -Name DownloadURL -Value $DownloadLink.DownloadUrl
            $null = $result | Add-Member -MemberType NoteProperty -Name filename -Value "$filename"
            
            if (!($GetInfoOnly)){        
                $result | ConvertTo-Json | Set-Content -Path $filenameJSON
            }

            Write-Output -InputObject $result
        }                        
    }
    end 
    {
        if ($ShowDownloadFolder){start $DownloadFolder}
    }
}
