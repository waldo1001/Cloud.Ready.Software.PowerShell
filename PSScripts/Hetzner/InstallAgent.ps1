. (Join-Path $PSScriptRoot "Connect-Warp10VSTSAgent.ps1")

Connect-Warp10VSTSAgent `
    -DevOpsUrl "https://dev.azure.com/NAVTechDays19" `
    -AgentPool "WaldoHetzner" `
    -AgentName "WaldoHetzner01" `
    -AgentFolder "C:\vsts-agent-win-x64-2.155.1_2" `
    -Verbose
# also add PAT to the script