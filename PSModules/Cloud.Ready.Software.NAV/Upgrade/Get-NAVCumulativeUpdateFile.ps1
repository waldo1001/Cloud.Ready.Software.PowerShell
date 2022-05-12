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
            CountryCodeRegex : the regular expression used to parse the country code from the download file name from downloads link, 
                "\\.([A-Z]{2}|W1).DVD|(?:\\.)?([A-Z]{2}|W1)\\.ZIP"
            downloadLinkRegex : the regular expression used to parse the download link information from the specific update page 
                "(https?\\:\\\/\\\/www\\.microsoft\\.com\\\/(?:[a-z]{2}-[a-z]{2}\\\/)?download\\\/details.aspx\\?(?:familyid=([\\da-zA-Z]{8}-(?:[\\da-zA-Z]{4}-){3}[\\da-zA-Z]{12})|id(?:%3d|=)?(\\d+)))"
            CUNoRegex : the regular expression used to parse the cu number from the support article description.
                "(?:Cumulative )?Update (\\d\\d?\\.?\\d{0,2})""
            versions : Array of version objects, one object is required for each version to be downloaded
            version object 
			    version: required, the version number, must match the Version parameter used
                url : reguired, the url to the main released updates page
                    for example 
                        the release cumulative updates page for NAV2013 is "https://support.microsoft.com/en-us/help/2842257"
                        the Released Updates for page for BC16 is "https://support.microsoft.com/en-us/help/4549687"
			    fileNamePrefix : required the prefix for the downloaded filename e.g. NAV for NAV.7.0.34587.DE.DVD.CU01.zip or BC for BC.16.0.12805.AT.DVD.CU16.1.ZIP
    			downloadLinkRegex" : optional, if not specified the root downloadLinkRegex will be used.  If there is some unique string that does not allow the default regular expression to be used.
                CUNoRegex : optional, if not specified the root CUNoRegex will be used.  If there is some unique string that does not allow the default regular expression to be used.
                e.g.
                versions : [
                    {
                        "version": "2013 R2",
                        "url" : "https://support.microsoft.com/en-us/help/2914930",
                        "fileNamePrefix" : "NAV",
                        "downloadLinkRegex" : ""
                    },
                    {
                        "version": "BC16",
                        "url": "https://support.microsoft.com/en-us/help/4549687",
                        "fileNamePrefix" : "BC",
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
        [Switch]$CreateLog = $false, 

        [Parameter(Mandatory = $false)]        
        [Switch]$skipExceptions = $false
    )

    begin {
    }
    process {

        if (-not (Test-Path $SettingsFile)) {
            Write-Error "Settings file cannot be found at $SettingsFile."
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
            Write-Error "No version information found for Version $Version in $SettingsFile."
            return
        }

        if (-not $skipExceptions) {
            Write-Verbose "Checking exceptions"
            $CUException = $SettingsJSON.Exceptions | Where-Object {($_.version -eq $Version) -and ($_.CU -eq $CUNo)}
            if ($null -ne $CUException) {
                Write-Error "$version $CUNo is an exception. Description: $($CUException.description)"
                return
            }
        }


        switch ($true) {
            ($VersionSettings.CUNoRegex.Length -gt 0) { $regex = $VersionSettings.CUNoRegex }
            ($SettingsJson.CUNoRegex.Length -gt 0) { $regex = $SettingsJson.CUNoRegex }
            default {
                Write-Error "CUNoRegex must be specified a default for $Version in $SettingsFile" 
                return
            }
        }
        Write-Verbose "CU Regex: $regex"
        $CULinkMatches = [ordered]@{}

        if ($VersionSettings.Count -gt 1){
            $Page = Invoke-WebRequest -Uri $VersionSettings[0].url
        } else {
            $Page = Invoke-WebRequest -Uri $VersionSettings.url
        }
        $parsedPage = $page.ParsedHtml
        $rows = $parsedPage.getElementById('supArticleContent').getElementsByTagName('tbody').item(0).rows
        foreach ($row in $rows) {
            $html = $row.getElementsByTagName('td')[0].innerHTML
            $Link = $html.Substring($html.IndexOf('"') + 1, $html.LastIndexOf('"') - ($html.IndexOf('"') + 1))

            $Description = $row.getElementsByTagName('td')[1].innerText
            $CU = ((([regex]::Matches($Description, $regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Groups[1].Value).Split('.') | Select-Object -Last 1).PadLeft(2, '0')

            Write-Verbose("$CU`t$Link")
        
            if (!($CULinkMatches[$CU])){
                $CULinkMatches.Add($CU, $Link)
            }
        }
        $Page.Dispose()
        $Page = $null

                
        if ($CUNo -eq '00') {
            $updateLink = $CULinkMatches[0]
            $CUNo = $CULinkMatches.Keys | Select-Object -First 1
        }
        else {
            $updateLink = $CULinkMatches[$CUNo]
        }
        if (!$updateLink) {
            Write-Error "Update Release not found for $Version update $CUNo. Check $($VersionSettings.url) for correct update no."
            return
        }
        elseif ($updateLink.Substring(0, 4) -ine 'http') {
            $updateLink = $updateLink.Insert(0, $SettingsJson.DefaultDownloadURL)
        }

        Write-Verbose "Reading download page $updateLink"
        switch ($true) {
            ($VersionSettings.downloadlinkRegex.Length -gt 0) { $regex = $VersionSettings.downloadlinkRegex }
            ($SettingsJson.downloadlinkRegex.Length -gt 0) { $regex = $SettingsJson.downloadlinkRegex }
            default {
                Write-Error "DownloadLinkRegex must be specified a default for $Version in $SettingsFile"    
                return
            }
        }
        Write-Verbose "Download Link Regex: $regex"

        $Page = Invoke-WebRequest -Uri $updateLink

        $div = ($Page.ParsedHTML).getElementById('ocArticle')

        $buildMatch = [regex]::Match($div.innerText, $SettingsJSON.BuildRegex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($buildMatch.Groups[1].Success) {
            $build = $buildMatch.groups[1].Value
        }
        elseif ($buildMatch.Groups[2].Success) {
            $build = $buildMatch.Groups[2].Value.Split('.') | Select-Object -Last 1
        }
        else {
            Write-Error "Build not found in $updateLink"
            return
        }
        Write-Verbose "Build No. Regex: $($SettingsJSON.BuildRegex)"
        Write-Verbose "Build No.: $build"

        $kbLink = ($Page.Links).href | Where-Object {$_ -match $regex} | Select-Object -First 1
        if (!$kbLink) {
            Write-Error "No link to Download Center found for $Version $CUNo. Refer to $updateLink to verify download available."
            return
        }
        $Page.Dispose()
        $Page = $null
        Write-Verbose "Download link $kbLink"

        $kbLinkMatches = [regex]::Matches($kbLink, $regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($kbLink.Contains('familyid=')) {
            $dlPage = Invoke-WebRequest -Uri $kbLink
            $ProductID = $dlPage.BaseResponse.ResponseUri.Query.Substring(1).Split('=') | Select-Object -Last 1
            $dlPage.Dispose()
            $dlPage = $null

        }
        else {
            $ProductID = $kbLinkMatches.Groups[3].Value
        }
        if (!$ProductID) {
            Write-Error "No product id (familyid) found in $kbLink. Refer to $updateLink to verify download available."
            return
        }
        Write-Verbose "Found Product ID $ProductID"

        Write-Verbose "Loading NAVCumulativeUpdateHelper"
        Load-NAVCumulativeUpdateHelper
        $DownloadLinks = [MicrosoftDownload.MicrosoftDownloadParser]::GetDownloadLocales($ProductID) | Select-Object *
        if ($CountryCode) {
            $DownloadLink = $DownloadLinks | Where-Object Code -eq $CountryCode
            if ($null -eq $Downloadlink) {
                
                $DownloadLink = $DownloadLinks | Where-Object DownloadUrl -match $CountryCode+".zip"
                if (-not ($null -eq $DownloadLink)) {
                    $DownloadLink.Code = $CountryCode
                }
                else {
                    $crlf = "`r`n"
                    Write-Error "Download link not found for Version: $Version Update: $CUNo Country Code: $CountryCode. Available Links: $crlf $($DownloadLinks | ForEach-Object {$($_.DownloadUrl+$crlf)})"
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
                '2013' { $Edition = '7.0'; break; }
                '2013 R2' { $Edition = '7.1'; break; }
                '2015' { $Edition = '8.0'; break; }
                '2016' { $Edition = '9.0'; break; }
                '2017' { $Edition = '10.0'; break; }
                '2018' { $Edition = '11.0'; break; }
                'BC13' { $Edition = '13.0'; break; }
                'BC14' { $Edition = '14.0'; break; }
                'BC15' { $Edition = '15.0'; break; }
                'BC16' { $Edition = '16.0'; break; }
                'BC17' { $Edition = '17.0'; break; }
                'BC18' { $Edition = '18.0'; break; }
                Default { $Edition = ([regex]::Match($Version, '[0-9]{1,2}')).Value + ".0" }
            }
            if ($padEdition) {
                $Edition = $Edition.PadLeft(4, "0")
            }                

            $filename = (Join-Path -Path $DownloadFolder -ChildPath ("$($VersionSettings.fileNamePrefix).$($Edition).$($Build).$($DownloadLink.Code).DVD.CU$CUNo$([io.path]::GetExtension($DownloadLink.DownloadUrl))"))
            $filenameJSON = ([io.path]::ChangeExtension($filename, 'json'))
                    
            if (!($GetInfoOnly)) {
                if (-not(Test-Path $filenameJSON)) {
                    Write-Verbose "Downloading $($DownloadLink.Code) to $filename" 
                    Write-Information -Message "Downloading Version: $Version Update: $CUNo CountryCode: $CountryCode to $filename."
                    $null = Start-BitsTransfer -Source $DownloadLink.DownloadUrl -Destination $filename 
                    Write-Verbose 'Update downloaded' 
                }
                else {
                    Write-Error "File $([io.path]::GetFileName($filenameJSON)) already exists.  Nothing downloaded!"

                }                                           
            }

            if (Test-Path $filename) {
                $null = Unblock-File -Path $filename
            }

            $result = New-Object -TypeName System.Object
            $null = $result | Add-Member -MemberType NoteProperty -Name NAVVersion -Value $Version
            $null = $result | Add-Member -MemberType NoteProperty -Name CountryCode -Value $DownloadLink.Code
            $null = $result | Add-Member -MemberType NoteProperty -Name CUNo -Value "$CUNo"
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
