$RoletailoredCLient = "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Client.exe"

$ConnectionString = """DynamicsNAV://WIN-K5JLU49T31O:7746/DemoMTEnvironment/Demo PRS Company1/?tenant=demoprscompany"""
Start-Process -FilePath $RoletailoredCLient -ArgumentList $ConnectionString

$ConnectionString = """DynamicsNAV://WIN-K5JLU49T31O:7746/DemoMTEnvironment/Demo Waldo Company1/?tenant=demowaldocompany"""
Start-Process -FilePath $RoletailoredCLient -ArgumentList $ConnectionString

$ConnectionString = """DynamicsNAV://WIN-K5JLU49T31O:7746/DemoMTEnvironment/Default Company/?tenant=maintenant"""
Start-Process -FilePath $RoletailoredCLient -ArgumentList $ConnectionString
