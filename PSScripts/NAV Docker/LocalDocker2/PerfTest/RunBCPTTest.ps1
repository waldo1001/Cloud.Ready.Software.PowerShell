$UserName = 'waldo'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

Run-BCPTTestsInBcContainer `
    -containerName PerfTest `
    -credential $ContainerCredential `
    -testPage 149002 `
    -suiteCode 'TEST'
