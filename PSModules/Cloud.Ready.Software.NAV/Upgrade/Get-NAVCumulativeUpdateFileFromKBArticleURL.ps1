function Get-NAVCumulativeUpdateFileFromKBArticleURL
{
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        $KBArticleURL,
        [Parameter(ValueFromPipelineByPropertyName)]        $DownloadFolder = $env:TEMP,
        [Parameter(ValueFromPipelineByPropertyName)]
        $CountryCodes = 'W1'
        )
    begin {
        $ie = New-Object -ComObject 'internetExplorer.Application'
        $ie.Visible = $true
    }
    process {
        $null = $ie.Navigate($KBArticleURL)    
        while ($ie.Busy -eq $true)
        {
            $null = Start-Sleep -Seconds 1
        }

        Write-Host -Object 'Searching for download link' -ForegroundColor Green
        $downloadlink = $ie.Document.links | Where-Object -FilterScript { 
            $_.id -match 'kb_hotfix_link'
        } | Select-Object -First 1 
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
