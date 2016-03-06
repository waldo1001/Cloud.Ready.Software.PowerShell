<#
.Synopsis
   Gets object properties from a Delta File 
.DESCRIPTION
   Get-NAVApplicationObject alternative for DELTA files.
.EXAMPLE
   
.EXAMPLE
   $NAVObjects = get-item $Deltafiles | Get-NAVApplicationObjectPropertyFromDelta

#>
function Get-NAVApplicationObjectPropertyFromDelta
{
    param 
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Fullname')] 
        $Source
    )

    Process
    {
        
        Get-Item $Source | foreach {
        
            $NAVObject = Get-NAVApplicationObjectProperty -Source $_.Fullname

            if ($NAVObject.Count -gt 1) {
                write-error "File $($_.Fullname) contains multiple objects, which is not supported by this function"
                break
            }

            $MyNAVObject = New-Object PSObject
            $NAVObject | Get-Member -MemberType Properties | foreach {
                $MyNAVObject | Add-Member -MemberType NoteProperty -Name $_.Name -Value $NAVObject."$($_.name)"        
            }
        
            IF ($MyNAVObject.ObjectType -eq 'Modification') {
                $DeltaFileFirstLine = (Get-Content $_)[0]

                $regex = '.+\((\w+) (\d+)\)'
                $MatchedRegEx = [regex]::Match($DeltaFileFirstLine, $regex)
                                    
                $MyNAVObject.ObjectType = $MatchedRegEx.Groups.Item(1).value
                $MyNAVObject.Id = $MatchedRegEx.Groups.Item(2).value
            }

            return $MyNAVObject

        }
       
    }
}