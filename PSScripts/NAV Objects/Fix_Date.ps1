$Objects = Get-NAVApplicationObjectProperty -Source '.\MergeResult'

$DefaultObjectFolder = Get-Item '.\13.1.25940.0-be'
$DistriObjectFolder = Get-Item '.\Distri113_NAV2018'

foreach ($Object in $Objects) {
    
    $DefaultObjectFileName = Join-Path $DefaultObjectFolder.FullName ([io.path]::GetFileName($Object.FileName))
    $DistriObjectFileName = Join-Path $DistriObjectFolder.FullName ([io.path]::GetFileName($Object.FileName))

    $DefaultObject = $null
    $distriobject = $null
    if (Get-Item $DefaultObjectFileName -ErrorAction SilentlyContinue) {
        $DefaultObject = Get-NAVApplicationObjectProperty -Source $DefaultObjectFileName
    }
    if (Get-Item $DistriObjectFileName -ErrorAction SilentlyContinue) {
        $DistriObject = Get-NAVApplicationObjectProperty -Source $DistriObjectFileName
    }

    $ChangeToDate = $Object.Date
    if ($DefaultObject -and $DistriObject) {
        if ($DistriObject.Date -ge $DefaultObject.Date) {
            $ChangeToDate = $DistriObject.Date
        }
        else {
            $ChangeToDate = $DefaultObject.Date
        }
    }
    else {
        if ($DistriObject) {
            $ChangeToDate = $DistriObject.Date
        }
        else {
            if ($DefaultObject) {
                $ChangeToDate = $DefaultObject.Date
            }
        }
    }
    
    if ($ChangeToDate -ne $Object.Date) {
        if (-not (Get-Date $ChangeToDate -ErrorAction SilentlyContinue)) {
            Write-Host -ForegroundColor Red "Wrong Date! $($object.ObjectType) $($object.Id) - $ChangeToDate"
        }

        Set-NAVApplicationObjectProperty -TargetPath $object.FileName -DateTimeProperty (Get-Date $ChangeToDate -Format g)
        Write-Host "$($object.ObjectType) $($object.Id) - $($Object.Date) --> $($ChangeToDate)"
    }
}
