<#
    .Synopsis
        Downloads a Cumulative Update from the Microsoft Download Center
    .DESCRIPTION
        Based on the Microsoft Dynamics NAV Team Blog, this function is going to download a cumulative update to a download folder.
        The function uses the download helper (Load-NAVCumulativeUpdateHelper)
    .PARAMETER CountryCode
        Optional, default is <blank> otherwise a NAV/BC supported country code
    .PARAMETER Version
        Required.  A NAV/BC version.  Acceptable values are 2013, 2013 R2, 2015, 2016, 2017, 2018, BC13, BC14, BC15.
        This uses pattern matching so there are no defaults, so future versions (e.g. BC17, BC20) are supported and can be used once the version is available and set up in the Versions.json (see SettingsFile)
    .PARAMETER CUNo
        Optional, default is <blank> otherwise a valid (cumulative) update number.  If blank the latest update is downloaded
        If the update does not exist for the version specified then an warning is issued
    .PARAMETER Locale
        Optional, default is <blank> otherwise a valid NAV/BC supported locale
    .PARAMETER DownloadFolder
        Optional, default is $env:TEMP otherwise an existing folder where the downloaded file will be placed.
    .PARAMETER SettingsFile
        Optional, default is versions.json located in the same folder as the script.
            versions.json entries
            DefaultDownloadURL : the base url used for each update specific web page, 
                "https://support.microsoft.com/help/"
            BuildRegex : the regular expression used to parse the build number from the update page title 
                "Build (([\\d\\.]+))"
            ArticleIDRegex : the regular expression used to identify the script wherein the download link is located.  The article number is appended to this, 
                "\/"
            CountryCodeRegex : the regular expression used to parse the country code from the download file name from downloads link, 
                "\\.([A-Z]{2}|W1).DVD|(?:\\.)?([A-Z]{2}|W1)\\.ZIP"
            CULinkRegex : the regular expression used to parse the links for the specific update pages from the main released updates page 
                "<a.+?(?:data-content-id=\\\\\"(\\d+)\\\\\"|https?:\\\/\\\/support\\.microsoft\\.com\\\/(?:help|[a-z]{2}-[a-z]{2}\\\/)?help\\\/(\\d+)|\\\\\"\\\/[a-z]{2}-[a-z]{2}\\\/help\\\/(\\d+))+.+?(?:Cumulative )?Update (\\d\\d?\\.?\\d?) .+? "
            downloadLinkRegex : the regular expression used to parse the download link information from the specific update page 
                "(https?\\:\\\/\\\/www\\.microsoft\\.com\\\/(?:[a-z]{2}-[a-z]{2}\\\/)?download\\\/details.aspx\\?(?:familyid=[\\da-zA-Z]{8}-(?:[\\da-zA-Z]{4}-){3}[\\da-zA-Z]{12}|id(?:%3d|=)?(\\d+)))(?:.+?)?(?:>)?.+?(?:Cumulative )?update(?:&nbsp;| )?(?:CU)?(?: )?(\\d\\d?\\.?\\d?)"
            versions : Array of version objects, one object is required for each version to be downloaded
            version object 
			    version: required, the version number, must match the Version parameter used
                url : reguired, the url to the main released updates page
                    for example 
                        the release cumulative updates page for NAV2013 is "https://support.microsoft.com/en-us/help/2842257"
                        the Released Updates for page for BC16 is "https://support.microsoft.com/en-us/help/4549687"
			    fileNamePrefix : required the prefix for the downloaded filename e.g. NAV for NAV.7.0.34587.DE.DVD.CU01.zip or BC for BC.16.0.12805.AT.DVD.CU16.1.ZIP
			    CULinkRegex : optional, if not specified the root CULinkRegex will be used.  If there is some unique string that does not allow the default regular expression to be used.
    			downloadLinkRegex" : optional, if not specified the root downloadLinkRegex will be used.  If there is some unique string that does not allow the default regular expression to be used.
                e.g.
                versions : [
                    {
                        "version": "2013 R2",
                        "url" : "https://support.microsoft.com/en-us/help/2914930",
                        "fileNamePrefix" : "NAV",
                        "CULinkRegex" : "",
                        "downloadLinkRegex" : ""
                    },
                    {
                        "version": "BC16",
                        "url": "https://support.microsoft.com/en-us/help/4549687",
                        "fileNamePrefix" : "BC",
                        "CULinkRegex" : "",
                        "downloadLinkRegex" : ""
                    }
                ],
            "Exceptions" : array of exeption objects.  These are version CU combinations where there is a known problem.  
                version : required, the version number in which the exception applies, must match the Version parameter used
                CU : required, the update number in which the exception applies.
                description : required, a description of what the exception is.  This will be displayed as a warning.
                reference : optional, if present must be the url to a corrected download page
			    productID : optional, if present must be the product id of the download version
                e.g.
                Exceptions : [
                    {
                        "version" : "2013 R2",
                        "CU" : 19,
                        "description" : "Not available from Download Center.  It is a hotfix file request instead.", 
                        "reference" : "",
                        "productID" : ""
                    },
                    {
                        "version" :"2017",
                        "CU" : 1,
                        "description" : "Not available from Download Center.  It is a hotfix file request instead.", 
                        "reference" : "",
                        "productID" : ""
                    }
                ]
            helpers : optional, array of websites that assisted with the creation of the required regular expressions and formatting them for JSON
                    Thought they might be useful to others.
                    {
                        "name" : "Free Formatter Free Online Tools For Developers",
                        "Description" : "Use this to escape/unescape strings for storage in JSON file",
                        "url" : "https://www.freeformatter.com/json-escape.html"
                    },
                    {			
                        "name" : "RegEx Editor",
                        "Description" : "RegExr is an online tool to learn, build, & test Regular Expressions (RegEx / RegExp).",
                        "url" : "https://regexr.com/"
                    }
    .PARAMETER LogFile
        Optional, location and file name of where to put information from the web pages used to debug issues with regular expressions.
        Defaults to "Log\Version $Version Update $CUNo Country $CountryeCode Log.txt" (e.g. Log\Version 2015 Update 27 Country GB Log.txt) which is a sub-folder of the script folder
        If specified then the CreateLog parameter must also be set
    .PARAMETER ShowDownloadFolder
        Optional switch, Shows the download folder in File Explorer when the download is complete.
    .PARAMETER GetInfoOnly
        Optional switch, Do not download the file, only display the download information
    .PARAMETER SaveInfoJSON
        Optional switch, Saves the download information JSON file regardless of the GetInfoOnly parameter
    .PARAMETER PadEdition
        Optional switch, zero pads the Edition portion of the filename.  Sorts better in File listing
        e.g. NAV.09.0.43402.CZ.DVD.CU01.zip vs. NAV.9.0.43402.CZ.DVD.CU01
    .PARAMETER CreateLog
        Optional switch, creates log file specified in LogFile,
        If specified then the LogFile parameter must also be set
    .EXAMPLE
        Get-NAVCumulativeUpdateFile -version 2018 -CountryCode BE

        This example gets the latest update for Country Code BE (Belgium) for NAV2018
    .EXAMPLE
        Get-NAVCumulativeUpdateFile -version BC15 -CUNo 7 -CountryCode FR -DownloadFolder 'C:\NAV DVDS\BC15'

        This example gets update 7 for Country Code GB (Great Britain) for Business Central 2019 Wave 2 (15) and puts it in the C:\NAV DVDS\BC15 folder
    .OUTPUT
        - Objects with info about the downloaded cumulative updates
        - optionally downloads update ZIP file
        - optionally a JSON file with details about the download
#>
function Get-NAVCumulativeUpdateFile {
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]$CountryCode,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [ValidatePattern("^2013 R2$|^201[3,5-8]{1}$|^BC1[3-9]{1}$|^BC2[0-9]{1}$")]
        [String]$Version = '2018',

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]$CUNo,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]$Locale,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]$DownloadFolder = $env:TEMP,        

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]$SettingsFile = (Join-Path $PSScriptRoot 'Versions.json'),        

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]$Logfile = (Join-Path $PSScriptRoot $("Log\Version $Version Update $CUNo Country $CountryeCode Log.txt")),

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [Switch]$ShowDownloadFolder,

        [Parameter(Mandatory = $false)]        
        [Switch]$GetInfoOnly,

        [Parameter(Mandatory = $false)]        
        [Switch]$SaveInfoJSON,

        [Parameter(Mandatory = $false)]        
        [Switch]$padEdition,

        [Parameter(Mandatory = $false)]        
        [Switch]$CreateLog = $false
    )

    begin {
    }
    process {

        if (-not (Test-Path $SettingsFile)) {
            Write-Warning "Settings file cannot be found at $SettingsFile."
            return
        }

        if (Test-Path $Logfile) {
            Remove-Item -Path $Logfile -Force
        }

        $CUNo = $CUNo.PadLeft(2, "0")

        Write-Verbose ""            
        Write-Verbose "Processing parameters CountryCode: $CountryCode Version: $Version Update: $CUNo"
        
        Write-Verbose "Reading settings from $SettingsFile"
        $SettingsJSON = Get-Content -Raw -Path $SettingsFile | ConvertFrom-Json
        $VersionSettings = $SettingsJSON.Versions | Where-Object { $_.Version -eq $Version }
        if ($null -eq $VersionSettings) {
            Write-Warning "No version information found for Version $Version in $SettingsFile."
            return
        }

        $CUReleasesResponse = (Invoke-WebRequest -Uri $VersionSettings.url)
            
        $parts = ([system.uri]($VersionSettings.url)).AbsolutePath.Split('/')
        $articleId = $parts[$parts.Count - 1]
        $script = $CUReleasesResponse.Scripts | Where-object { $_.innerHtml -match '\/' + $articleId }

        switch($true) {
            ($VersionSettings.cuLinkRegex.Length -gt 0) {$regex = $VersionSettings.cuLinkRegex}
            ($SettingsJson.cuLinkRegex.Length -gt 0) {$regex = $SettingsJson.cuLinkRegex}
            default {
                Write-Error "CULinkRegex must be specified a default for $Version in $SettingsFile"    
            }
        }
        Write-Verbose "CU Regex: $regex"

        if($CreateLog) {
            ("$Version $CU - Update Links") | Set-Content -Path $Logfile
            $regex | Add-Content -Path $Logfile
            "" | Add-Content -Path $Logfile
            $script.innerText | Add-Content -Path $Logfile
        }

        $CULinkMatches = [regex]::Matches($script.innerText, $regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                
        $updateLinks = [ordered]@{}
        foreach ($CULinkMatch in $CULinkMatches) {
            switch ($true) {
                ($CULinkMatch.Groups.count -eq 5) {
                    switch ($true) {
                        ($CULinkMatch.Groups[1].success) { $value = $CULinkMatch.groups[1].Value }
                        ($CULinkMatch.Groups[2].success) { $value = $CULinkMatch.groups[2].Value }
                        ($CULinkMatch.Groups[3].success) { $value = $CULinkMatch.groups[3].Value }
                    }
                    $value = $SettingsJSON.DefaultDownloadURL + $value
                    $key = $CULinkMatch.groups[4].Value.split('.') | Select-Object -Last 1
                }
                default {
                    Write-Error "Unexpected group count $($CULinkMatch.Groups.count)"
                    return
                }
            }
            Write-Verbose "Key: '$key' Value: '$value'"
            $updateLinks.Add($key.PadLeft(2, "0"), $value)
        }

        if ($CUNo -eq '00') {
            $updateLink = $updateLinks[0]
            $CUNo = $updateLinks.Keys | Select-Object -First 1
        }
        else {
            $updateLink = $updateLinks[$CUNo]
        }
        if (!$updateLink) {
            Write-Warning "Update Release not found for $Version update $CUNo. Check $($VersionSettings.url) for correct update no."
            return
        }
            
        Write-Verbose "Reading blog page $updateLink"
        $UpdateResponse = Invoke-WebRequest -Uri $updateLink

        Write-Verbose 'Searching KB Url'
        $articleId = ([system.uri]($updateLink)).AbsolutePath.Split('/') | Select-Object -Last 1
        $script = $UpdateResponse.Scripts | Where-object { $_.innerHtml -match $SettingsJSON.ArticleIDRegex + $articleId }

        $buildMatch = [regex]::Match($script.innerText, $SettingsJSON.BuildRegex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($buildMatch.Groups[1].Success) {
            $build = $buildMatch.groups[1].Value.split(".") | Select-Object -Last 1
        }
        else {
            Write-Warning "Build not found in $updateLink"
        }
        Write-Verbose "Build No.: $build"

        switch($true) {
            ($VersionSettings.downloadlinkRegex.Length -gt 0) {$regex = $VersionSettings.downloadlinkRegex}
            ($SettingsJson.downloadlinkRegex.Length -gt 0) {$regex = $SettingsJson.downloadlinkRegex}
            default {
                Write-Error "DownloadLinkRegex must be specified a default for $Version in $SettingsFile"    
            }
        }
        Write-Verbose "Download Link Regex: $regex"

        if($CreateLog) {
            "" | Add-Content -Path $Logfile
            ("$Version $CU - Download Link") | Add-Content -Path $Logfile
            $regex | Add-Content -Path $Logfile
            "" | Add-Content -Path $Logfile
            $script.innerText | Add-Content -Path $Logfile
        }

        $DownLoadLinkMatches = [regex]::Matches($script.innerText, $regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        try {
            $UpdateNo = $DownLoadLinkMatches.Groups[3].Value.Split(".") | Select-Object -Last 1
            $ProductID = $DownLoadLinkMatches.Groups[2].Value
            $kbLink = $DownLoadLinkMatches.Groups[1].Value   
        }
        catch {
            $versionException = $SettingsJSON.Exceptions | Where-Object { ($_.Version -eq $Version) -and ($_.CU -eq $CUNo) }
            if ($null -ne $versionException) {
                Write-Warning "Version $($versionException.version) Update $($versionException.CU) $($versionException.description)"
                if ($versionException.reference.Length -eq 0) {
                    return
                }
                else {
                    $UpdateNo = $versionException.CU.ToString().PadLeft(2,"0")
                    $ProductID = $versionException.Product.ToString()
                    $kbLink = $versionException.reference
                }
            }
            else {
                Write-Warning "DownloadRegex for $Version $CUNo returned no results. Refer to $updateLink to verify download available."
                return
            }
        }
        if (!($kbLink)) {
            Write-Warning "No link to Download Center found for $Version $CUNo. Refer to $updateLink to verify download available."
            return
        }

        if ($kbLink.Contains('familyid=')) {
            $dlPage = Invoke-WebRequest -Uri $kbLink
            $ProductID = $dlPage.BaseResponse.ResponseUri.Query.Substring(1).Split('=') | Select-Object -Last 1
        }
        Write-Verbose "Found Product ID $ProductID"

        Write-Verbose "Loading NAVCumulativeUpdateHelper"
        Load-NAVCumulativeUpdateHelper
        if ($Locale) {
            $DownloadLinks = [MicrosoftDownload.MicrosoftDownloadParser]::GetDownloadDetail($ProductID, $Locale) | Select-Object *
        }
        else {
            $DownloadLinks = [MicrosoftDownload.MicrosoftDownloadParser]::GetDownloadLocales($ProductID) | Select-Object *
        }
        if ($CountryCode) {
            $DownloadLink = $DownloadLinks | Where-Object Code -eq $CountryCode
            if ($null -eq $Downloadlink) {
                
                $DownloadLink = $DownloadLinks | Where-Object DownloadUrl -match $CountryCode+".zip"
                if (-not ($null -eq $DownloadLink)) {
                    $DownloadLink.Code = $CountryCode
                }
                else {
                    Write-Warning "Download link not found for Version: $Version Update: $CUNo Country Code: $CountryCode. Available Links:"
                    foreach ($Link in $DownloadLinks) {
                        Write-Warning "  $Link.DownloadUrl"
                    }
                    return
                }
            }
            $DownloadLinks = $DownloadLink
        }

        foreach ($DownloadLink in $DownloadLinks) {
            Write-Verbose "Download Link: $($DownloadLink.DownloadUrl)"
            if ($CountryCode.Length -eq 0) {
                $CountryCodeMatches = [regex]::Matches($DownloadLink.DownloadUrl, $settingsJSON.CountryCodeRegex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                if ($CountryCodeMatches.Length -eq 0) {
                    Write-Error "Country Code not found in $($DownloadLink.DownloadUrl)"
                    return
                }
                $Value = ''
                switch ($true) {
                    ($CountryCodeMatches.groups[1].success) { $value = $CountryCodeMatches.groups[1].Value }
                    ($CountryCodeMatches.groups[2].success) { $value = $CountryCodeMatches.groups[2].Value }
                }
                $DownloadLink.Code = $value
            }

            switch ($Version) {
                '2013' { $Edition = '7.0' }
                '2013 R2' { $Edition = '7.1' }
                '2015' { $Edition = '8.0' }
                '2016' { $Edition = '9.0' }
                '2017' { $Edition = '10.0' }
                '2018' { $Edition = '11.0' }
                'BC13' { $Edition = '13.0' }
                'BC14' { $Edition = '14.0' }
                'BC15' { $Edition = '15.0' }
                'BC16' { $Edition = '16.0' }
                'BC17' { $Edition = '17.0' }
                Default { $Edition = ([regex]::Match($Version,'[0-9]{1,2}')).Value + ".0" }
            }
            if ($padEdition) {
                $Edition = $Edition.PadLeft(4, "0")
            }                

            $filename = (Join-Path -Path $DownloadFolder -ChildPath ("$($VersionSettings.fileNamePrefix).$($Edition).$($Build).$($DownloadLink.Code).DVD.CU$($UpdateNo.PadLeft(2,"0"))$([io.path]::GetExtension($DownloadLink.DownloadUrl))"))
            $filenameJSON = ([io.path]::ChangeExtension($filename, 'json'))
                    
            if (!($GetInfoOnly)) {
                if (-not(Test-Path $filenameJSON)) {
                    Write-Verbose "Downloading $($DownloadLink.Code) to $filename" 
                    Write-Information -Message "Downloading Version: $Version Update: $CUNo CountryCode: $CountryCode to $filename."
                    $null = Start-BitsTransfer -Source $DownloadLink.DownloadUrl -Destination $filename 
                    Write-Verbose 'Update downloaded' 
                }
                else {
                    write-warning "File $([io.path]::GetFileName($filenameJSON)) already exists.  Nothing downloaded!"
                }                                           
            }

            if (Test-Path $filename) {
                $null = Unblock-File -Path $filename
            }

            $result = New-Object -TypeName System.Object
            $null = $result | Add-Member -MemberType NoteProperty -Name NAVVersion -Value $Version
            $null = $result | Add-Member -MemberType NoteProperty -Name CountryCode -Value $DownloadLink.Code
            $null = $result | Add-Member -MemberType NoteProperty -Name CUNo -Value "$UpdateNo"
            $null = $result | Add-Member -MemberType NoteProperty -Name Build -Value $Build
            $null = $result | Add-Member -MemberType NoteProperty -Name KBUrl -Value "$kbLink"
            $null = $result | Add-Member -MemberType NoteProperty -Name ProductID -Value "$ProductID"
            $null = $result | Add-Member -MemberType NoteProperty -Name DownloadURL -Value $DownloadLink.DownloadUrl
            $null = $result | Add-Member -MemberType NoteProperty -Name filename -Value "$filename"
            
            if (!$GetInfoOnly -or $SaveInfoJSON) {
                $result | ConvertTo-Json | Set-Content -Path $filenameJSON
            }

            Write-Output -InputObject $result
        }                        
    }
    end {
        if ($ShowDownloadFolder) {
            Start-Process $DownloadFolder 
        }
    }
}
