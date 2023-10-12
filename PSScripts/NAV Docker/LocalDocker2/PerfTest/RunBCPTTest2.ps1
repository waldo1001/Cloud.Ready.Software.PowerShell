$UserName = 'waldo'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$Version = (Get-ChildItem "C:\bcartifacts.cache\sandbox\" | where Name -like "*23.0*" | sort Name -Descending | select Name -First 1).Name
Set-Location "C:\bcartifacts.cache\sandbox\$Version\platform\Applications\testframework\TestRunner"

./RunBCPTTests.ps1 `
    -Environment OnPrem `
    -AuthorizationType NavUserPassword `
    -Credential $Credential `
    -TestRunnerPage 149002 `
    -SuiteCode "TEST" `
    -ServiceUrl 'http://PerfTest/BC' `
    -BCPTTestRunnerInternalFolderPath './internal' 

