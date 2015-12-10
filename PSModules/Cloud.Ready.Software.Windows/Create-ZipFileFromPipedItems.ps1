#still some work to do - doesn't work that well ..
#source: http://www.technologytoolbox.com/blog/jjameson/archive/2012/02/28/zip-a-folder-using-powershell.aspx

function Create-ZipFileFromPipedItems
{
	param([string]$zipfilename)

	if(test-path($zipfilename))
	{
		get-item $zipfilename | remove-item
	}
    
    set-content $zipfilename ('PK' + [char]5 + [char]6 + ("$([char]0)" * 18))
	(get-childitem $zipfilename).IsReadOnly = $false	
	
	$shellApplication = new-object -com shell.application
	$zipPackage = $shellApplication.NameSpace($zipfilename)
	
	foreach($file in $input) 
	{ 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 500
	}
} 