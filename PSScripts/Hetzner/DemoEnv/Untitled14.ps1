[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

install-module ALOps.ExternalDeployer -Force

import-module ALOps.ExternalDeployer 

Install-ALOpsExternalDeployer 

New-ALOpsExternalDeployer -ServerInstance BC