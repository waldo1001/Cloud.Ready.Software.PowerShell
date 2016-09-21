function New-NAVAppPermissionSet
{
    <#
        .SYNOPSIS
        To quickly create (and overwrite any existing) Permission Set.
        .DESCRIPTION
        This function is going to delete the existing Permission set, and overwrite it with the corresponding settings.
        Usually used for automation the creation for an Extension DEV Environment, where the typical READ and READ/WRITE permission Sets have to be created.

        Be aware:
          - Only sets permissions on TableData (as mostly used)
    #>
    param(
        [String] $ServerInstance,
        [String] $AppName,
        [ValidateSet('Read','Write')]
        [String] $PermissionType,
        [Int[]] $OnTableIDs 

    )

    Switch($PermissionType){
        'Read'{
            $PermissionSetID= "$($AppName)_R"
            $PermissionSetName = "$($AppName) Read"
        }
        'Write'{
            $PermissionSetID= "$($AppName)_RW"
            $PermissionSetName = "$($AppName) Read&Write "
        }
        
    }

    $PermissionSetIDExists = Get-NAVServerPermissionSet -ServerInstance $ServerInstance | where PermissionSetId -eq $PermissionSetID
    if ($PermissionSetIDExists){
        if (-not(Confirm-YesOrNo -title "PermissionSetID $PermissionSetID already exists" -message "PermissionSetID $PermissionSetID already exists, do you want to remove it?")){
            exit
        }
    }

    Remove-NAVServerPermissionSet -ServerInstance $ServerInstance -PermissionSetId $PermissionSetID -Force -ErrorAction SilentlyContinue

    New-NAVServerPermissionSet `
        -PermissionSetId $PermissionSetID `
        -PermissionSetName $PermissionSetName `
        -ServerInstance $ServerInstance `
        -Force
  
    foreach($TableID in $OnTableIDs){
        
        if ($PermissionType -eq 'Write'){
            $WritePermission = 'Yes'
        } else {
            $WritePermission = 'No'
        }

        New-NAVServerPermission `
            -PermissionSetId $PermissionSetID `
            -ServerInstance $ServerInstance `
            -ObjectType TableData `
            -ObjectId $TableID `
            -Read Yes `
            -Insert $WritePermission `
            -Modify $WritePermission `
            -Delete $WritePermission

    }  
                                                  

}
    
