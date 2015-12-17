$SMTPServer = 'relay.iconos.be'
$ToAddress ='eric.wauters@ifacto.be'
$FromAddress = 'PowerShell@ifacto.be'
$Subject = 'Test mail from PowerShell'
$Body = '
No 
Serious 
Body 
content
'

Send-MailMessage -to $ToAddress -From $FromAddress -Subject $Subject -Body $Body -SmtpServer $SMTPServer