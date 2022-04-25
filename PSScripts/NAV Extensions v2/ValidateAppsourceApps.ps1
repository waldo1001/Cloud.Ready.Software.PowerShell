$NewFolder = "C:\Temp\AppSourceApps\New"
$PrevFolder = "C:\Temp\AppSourceApps\Previous"

$Newapps = Get-ChildItem $NewFolder
$PrevApps = Get-ChildItem $PrevFolder

Run-AlValidation `
    -apps $Newapps.FullName `
    -validateCurrent `
    -countries 'be' `
    -affixes AAI,APPD,ASPR,CASHR,CHF,CLCH,CPLA,CREA,CRON,CSF,CSH,CUSF,DAR,DHE,DOCMAIL,DRL,DSE,DTS,ECCO,ECE,ECF,ECME,EDII,EFORM,EIT,ENVI,ERR,FFI,FIF,FILE,FINREP,FSU,HIS,HLI,IAR,ICON,IDR,IIM,INTRAST,INVF,INP,ISC,ITFE,JQM,JTS,LEM,LTE,MARG,META,MFF,NTT,OGM,OSO,OTY,PGR,PLF,PMENU,PORF,POST,PRME,QOE,RDT,RELD,REST,RHE,RPO,SOR,SPEC,SPRE,RCSP,SQF,SSF,SHR,STAH,STAU,ISUP,ITAX,TOPIC,TST,VNDF,VMF,VVC,WAO,WBR,WFB,WHSESCAN,WPR,WRO,WSO,WSW,WTO,BSE,LGI,CPSP,CPLOG,EDI-PEPPOL,EDIIP,FNC,FNCSP,SALESPURCH,COD,TEST,IFC,IFT,ETR,TDO,ICPR,DGD `
    -sasToken $SecretSettings.InsiderSASToken `
    -validateNextMajor 
    # -previousApps $PrevApps.FullName `
    

    