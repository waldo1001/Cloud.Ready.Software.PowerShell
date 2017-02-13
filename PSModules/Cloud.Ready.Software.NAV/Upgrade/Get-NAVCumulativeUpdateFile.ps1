<#
    .Synopsis
        Downloads a Cumulative Update from the Microsoft Download Center
    .DESCRIPTION
        Based on the Microsoft Dynamics NAV Team Blog, this function is going to download a cumulative update to a download folder.
        The function uses the download helper (Load-NAVCumulativeUpdateHelper)
    .EXAMPLE
        Get-NAVCumulativeUpdateFile -versions 2017 -Locale fr-FR -CountryCode BE -DownloadFolder C:\_Download
    .EXAMPLE
        Get-NAVCumulativeUpdateFile -versions 2017 -CountryCode BE
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
        [ValidateSet('2013','2013 R2','2015','2016','2017')]
        [String]$version = '2017',
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [String]$CUNo,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]        [String]$DownloadFolder = $env:TEMP,                [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName)]
        [Switch]$ShowDownloadFolder
    )

    begin {
        $ie = New-Object -ComObject 'internetExplorer.Application'
        $ie.Visible = $true
    }
    process
    {
            
        $url = ''
                
        Write-Host -Object "Processing parameters $CountryCode $version $CUNo" -ForegroundColor Cyan
        
        $feedurl = 'https://blogs.msdn.microsoft.com/nav/category/announcements/cu/feed/'
        [regex]$titlepattern = 'Cumulative Update (\d+) .*'
                
        Write-Host -Object 'Searching for RSS item' -ForegroundColor Green

        $feed = [xml](Invoke-WebRequest -Uri $feedurl)

        $blogurl = ($feed.SelectNodes("/rss/channel/item[./category='Cumulative Updates']") | where title -like "*Cumulative Update*$CUNo*NAV $version*" | Select-Object -First 1).link
        #{
        #if (!($blogurl)){
        #    $blogurl = $feed.SelectNodes("/rss/channel/item[./category='NAV $version' and ./category='Cumulative Updates']").link | Select-Object -First 1
        #}

        if (!$blogurl) 
        {
            Write-Error -Message 'Blog url not found!'
            return
        }
                
        Write-Host -Object "Reading blog page $blogurl" -ForegroundColor Green                
        $blogarticle = ''
        #$blogarticle = Invoke-WebRequest -Uri $blogurl
        $null = $ie.Navigate($blogurl)
        while ($ie.Busy -eq $true)
        {
            $null = Start-Sleep -Seconds 1
        }
                
        $titlematches = $titlepattern.Matches($ie.Document.title) 
        $updateno = $titlematches.Groups[1]

        Write-Host -Object 'Searching KB Url' -ForegroundColor Green                
        $titlematches = $titlepattern.Matches($ie.Document.title) 
        $updateno = $titlematches.Groups[1]
        $kblink = $ie.Document.links | Where-Object -FilterScript {
            Write-Verbose "Link: $($_.href) id: $($_.id)"
            $_.innerText -match 'KB'
        } | Select-Object -First 1
        $KbHref = $kblink.href

        Write-Host -Object 'Microsoft Download Center link' -ForegroundColor Green                                
        #$kblink = $blogarticle.Links | Where-Object -FilterScript {
        $kblink = $ie.Document.links | Where-Object -FilterScript {
            Write-Verbose "Link: $($_.href) id: $($_.id)"
            $_.innerText -match 'Download'
        } | Select-Object -First 1

        if (!($kblink)){
            Write-Warning 'No link to Download Center found.. .'
            break
        }

        $ProductID = $kblink.search.Substring(4)
        Write-Host -ForegroundColor Gray "Found Product ID $ProductID"


        Write-Host -ForegroundColor Green "Loading NAVCumulativeUpdateHelper"
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
        $BuildStartPos = $ie.Document.body.innerHTML.ToUpper().IndexOf($BuildSearchString) + $BuildSearchString.Length
        $BuildEndPos = $ie.Document.body.innerHTML.ToUpper().IndexOf(')',$BuildStartPos)
        $Build = $ie.Document.body.innerHTML.ToUpper().Substring($BuildStartPos,$BuildEndPos - $BuildStartPos)

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
                Default  {$Edition = $version}
            }
            $filename = (Join-Path -Path $DownloadFolder -ChildPath ("NAV.$($Edition).$($Build).$($CountryCode).DVD.CU$($updateno.Value)$([io.path]::GetExtension($DownloadLink.DownloadUrl))"))
                    
            #set-content -Value 'Just to debug the process - set this line in comment if you don''t want to debug' -Path $filename
            if (-not(Test-Path $filename)){
                Write-Host -Object "Downloading $($DownloadLink.Code) to $filename" -ForegroundColor Green
                $null = Start-BitsTransfer -Source $DownloadLink.DownloadUrl -Destination $filename 
                Write-Host -Object 'Hotfix downloaded' -ForegroundColor Green
            } Else {
                write-warning "File $([io.path]::GetFileName($filename)) already exists.  Nothing downloaded!"
            }                                           
    
            $null = Unblock-File -Path $filename

            $result = New-Object -TypeName System.Object
            $null = $result | Add-Member -MemberType NoteProperty -Name NAVVersion -Value $version
            $null = $result | Add-Member -MemberType NoteProperty -Name CountryCode -Value $DownloadLink.Code
            $null = $result | Add-Member -MemberType NoteProperty -Name CUNo -Value "$updateno"
            $null = $result | Add-Member -MemberType NoteProperty -Name Build -Value $Build
            $null = $result | Add-Member -MemberType NoteProperty -Name KBUrl -Value "$KbHref"
            $null = $result | Add-Member -MemberType NoteProperty -Name ProductID -Value "$ProductID"
            $null = $result | Add-Member -MemberType NoteProperty -Name DownloadURL -Value $DownloadLink.DownloadUrl
            $null = $result | Add-Member -MemberType NoteProperty -Name filename -Value "$filename"
                    
            $result | ConvertTo-Json | Set-Content -Path ([io.path]::ChangeExtension($filename,'json'))

            Write-Output -InputObject $result
        }                        
    }
    end 
    {
        if ($ShowDownloadFolder){start $DownloadFolder}
    }
}
