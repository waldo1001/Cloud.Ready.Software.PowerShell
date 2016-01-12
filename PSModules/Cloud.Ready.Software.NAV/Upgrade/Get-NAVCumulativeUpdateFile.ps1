#requires -Version 3 -Modules BitsTransfer
#Author: Kamil, based on ideas from waldo (who had it developed in .Net) :-)
<#
    .Synopsis
    Download the Cumulative Update File for specified NAV version and localization
    .DESCRIPTION
    Download the Cumulative Update File for specified NAV version and localization, with possibility to 
    select specific cumulative update
    .EXAMPLE
    Get-NAVCumulativeUpdateFile -CountryCodes 'intl','CSY' -versions '2013 R2','2015','2016'
    .EXAMPLE
    Get-NAVCumulativeUpdateFile -CountryCodes 'CSY' -versions '2013 R2' -CUNo 23
    .OUTPUT
    Objects with info about the downloaded cumulative updates
#>
function Get-NAVCumulativeUpdateFile
{
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        $CountryCodes = 'W1',
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        $versions = '2016',
        [Parameter(ValueFromPipelineByPropertyName)]
        $CUNo = '',
        [Parameter(ValueFromPipelineByPropertyName)]        $DownloadFolder = $env:TEMP
    )

    begin {
        $ie = New-Object -ComObject 'internetExplorer.Application'
        $ie.Visible = $true
    }
    process
    {
        foreach ($CountryCode in $CountryCodes) 
        {
            foreach ($version in $versions) 
            {
                $url = ''
                
                Write-Host -Object "Processing parameters $CountryCode $version $CUNo" -ForegroundColor Cyan
        
                $feedurl = 'https://blogs.msdn.microsoft.com/nav/category/announcements/cu/feed/'
                [regex]$titlepattern = 'Cumulative Update (\d+) .*'

                Write-Host -Object 'Searching for RSS item' -ForegroundColor Green

                $feed = [xml](Invoke-WebRequest -Uri $feedurl)

                if ($CUNo -gt '') 
                {
                    $blogurl = $feed.SelectNodes("/rss/channel/item[./category='NAV $version' and ./category='Cumulative Updates' and contains(./title,'$CUNo')]").link | Select-Object -First 1
                } else 
                {
                    $blogurl = $feed.SelectNodes("/rss/channel/item[./category='NAV $version' and ./category='Cumulative Updates']").link | Select-Object -First 1
                }

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
                
    
                Write-Host -Object 'Searching for KB link' -ForegroundColor Green
                                
                $titlematches = $titlepattern.Matches($ie.Document.title) 
                $updateno = $titlematches.Groups[1]

                #$kblink = $blogarticle.Links | Where-Object -FilterScript {
                $kblink = $ie.Document.links | Where-Object -FilterScript {
                    Write-Verbose "Link: $($_.href) id: $($_.id)"
                    $_.innerText -match 'KB'
                } | Select-Object -First 1

                Write-Host -Object "Opening KB link $($kblink.href)" -ForegroundColor Green
                $null = $ie.Navigate($kblink.href)
                while ($ie.Busy -eq $true)
                {
                    $null = Start-Sleep -Seconds 1
                }

                if ($ie.LocationURL -match 'https://corp.sts.microsoft.com') 
                {
                    Write-Host -Object 'Trying to login' -ForegroundColor Green
                    $loginlink = $ie.Document.IHTMLDocument3_getElementById('CustomHRD_LinkButton_LiveID')
                    Write-Host -Object 'Clicking the link to login' -ForegroundColor Green
                    $loginlink.click()
                    while ($ie.Busy -eq $true)
                    {
                        $null = Start-Sleep -Seconds 1
                    }
                }

                if ($ie.LocationURL -match 'login.live.com') 
                {
                    Write-Host -Object 'Please, login. Script will continue automatically...' -ForegroundColor Magenta
                    while ($ie.LocationURL -match 'login.live.com') 
                    {
                        $null = Start-Sleep -Seconds 1
                    }
                }
                while ($ie.Busy -eq $true)
                {
                    $null = Start-Sleep -Seconds 1
                }   

    
                if ($ie.LocationURL -match 'https://mbs2.microsoft.com/UserInfo/SelectProfile.aspx') 
                {
                    Write-Host -Object 'Searching for identity selection radiobuttons' -ForegroundColor Green
                    $radiobuttons = $ie.Document.body.getElementsByTagName('input') | Where-Object -FilterScript {
                        $_.type -eq 'radio' -and $_.name -eq 'radioGroup' 
                    }
                    Write-Host -Object 'Clicking first radio button' -ForegroundColor Green
                    $null = $radiobuttons[0].setActive()
                    $null = $radiobuttons[0].click()
                    $null = $ie.Document.IHTMLDocument3_getElementsByName('continueButton')[0].click()
                    while ($ie.Busy -eq $true)
                    {
                        $null = Start-Sleep -Seconds 1
                    }
                }

                Write-Host -Object 'Searching for download link' -ForegroundColor Green
                $downloadlink = $ie.Document.links | Where-Object -FilterScript {
                    $_.id -match 'kb_hotfix_link'
                }
                Write-Host -Object "Opening download link $($downloadlink.href)" -ForegroundColor Green
                $null = $ie.Navigate($downloadlink.href)
                while ($ie.Busy -eq $true)
                {
                    $null = Start-Sleep -Seconds 1
                }

                Write-Host -Object 'Searching for Accept button' -ForegroundColor Green

                $button = $ie.Document.IHTMLDocument3_getElementsByName('accept')

                if ($button.id) 
                {
                    Write-Host -Object 'Clicking Accept button' -ForegroundColor Green
                    $null = $button.click()
                    while ($ie.Busy -eq $true)
                    {
                        $null = Start-Sleep -Seconds 1
                    }   
                }

                Write-Host -Object 'Searching for list of updates' -ForegroundColor Green

                [regex]$pattern = 'hfList = (\[.+\}\])'
                $matches = $pattern.Matches($ie.Document.body.innerText) 
                if (!$matches) 
                {
                    Write-Error -Message 'list of hotfixes not found!'
                    return
                } 

                Write-Host -Object 'Converting Json with updates' -ForegroundColor Green
                $hotfixes = $matches.Groups[1].Value.Replace('\x','') | ConvertFrom-Json

                #URL examples:
                #http://hotfixv4.microsoft.com/Dynamics NAV 2016/latest/W1KB3106089/43402/free/488130_intl_i386_zip.exe
                #http://hotfixv4.microsoft.com/Dynamics NAV 2015/latest/CZKB3106088/43389/free/488059_CSY_i386_zip.exe

                Write-Host -Object "Searching for update for language $CountryCode" -ForegroundColor Green

                $hotfix = $hotfixes | Where-Object -FilterScript {
                    $_.filename -like "$($CountryCode)*"
                }

                if (!$hotfix) {
                    $hotfix = $hotfixes | Where-Object -FilterScript {
                        $_.langcode -like "$($CountryCode)*"
                    }
                }
                Write-Host -Object 'Creating hotfix URL' -ForegroundColor Green

                $url = "http://hotfixv4.microsoft.com/$($hotfix.product)/$($hotfix.release)/$($hotfix.filename)/$($hotfix.build)/free/$($hotfix.fixid)_$($hotfix.langcode)_i386_zip.exe"

                Write-Host -Object "Hotfix URL is $url" -ForegroundColor Green

                $filename = (Join-Path -Path $DownloadFolder -ChildPath "$($hotfix.fixid)_$($hotfix.langcode)_i386_zip.exe")
                Write-Host -Object "Downloading hotfix to $filename" -ForegroundColor Green
    
                if (-not (Test-Path $filename)) 
                {
                    $null = Start-BitsTransfer -Source $url -Destination $filename
                }
    
                Write-Host -Object 'Hotfix downloaded' -ForegroundColor Green
                $null = Unblock-File -Path $filename

                $result = New-Object -TypeName System.Object
                $null = $result | Add-Member -MemberType NoteProperty -Name filename -Value "$filename" 
                $null = $result | Add-Member -MemberType NoteProperty -Name version -Value "$version"
                $null = $result | Add-Member -MemberType NoteProperty -Name CUNo -Value "$updateno"
                $null = $result | Add-Member -MemberType NoteProperty -Name CountryCode -Value "$CountryCode"
                $null = $result | Add-Member -MemberType NoteProperty -Name langcode -Value "$($hotfix.langcode)"
                        
                Write-Output -InputObject $result
            }
        }        
    }
    end {
        $null = $ie.Quit()
    }
}
