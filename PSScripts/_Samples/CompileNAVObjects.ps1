Measure-Command {
    Compile-NAVApplicationObjectInParallel -ServerInstance DynamicsNAV90 -SynchronizeSchemaChanges Yes 
}

Measure-Command {
    Compile-NAVApplicationObject NAV2016 -Recompile -SynchronizeSchemaChanges Yes
}

<#
Days              : 0
Hours             : 0
Minutes           : 13
Seconds           : 32
Milliseconds      : 339
Ticks             : 8123392182
TotalDays         : 0,00940207428472222
TotalHours        : 0,225649782833333
TotalMinutes      : 13,53898697
TotalSeconds      : 812,3392182
TotalMilliseconds : 812339,2182

Days              : 0
Hours             : 0
Minutes           : 10
Seconds           : 41
Milliseconds      : 306
Ticks             : 6413061523
TotalDays         : 0,00742252491087963
TotalHours        : 0,178140597861111
TotalMinutes      : 10,6884358716667
TotalSeconds      : 641,3061523
TotalMilliseconds : 641306,1523

#>

