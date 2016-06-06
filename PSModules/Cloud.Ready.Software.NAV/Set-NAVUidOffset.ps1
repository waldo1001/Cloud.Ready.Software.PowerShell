function Set-NAVUidOffset {   
    <#
    .Synopsis
       Set the UidOffSet of a certain database from a certain instance
    .DESCRIPTION
       The UIDOffSet is important to control the "controlids" of the controls you create during development.  With this 
    .NOTES
       <TODO: Some tips>
    .PREREQUISITES
       <TODO: like positioning the prompt and such>
    .EXAMPLE
       
    #>

    param
    (
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Object] $ServerInstance,
        [parameter(Mandatory=$true)]
        [int] $UidOffSet
    )

    $SQLCommand = "UPDATE [$('$ndo$dbproperty')] SET [uidoffset] = $UidOffSet"
       
    Invoke-NAVSQL `        -ServerInstance $ServerInstance `
        -SQLCommand $SQLCommand
}