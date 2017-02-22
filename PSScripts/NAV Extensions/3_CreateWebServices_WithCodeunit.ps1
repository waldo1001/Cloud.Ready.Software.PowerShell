$CodeunitID = 93999
$Method = 'PublishWebServices'

$Codeunit = "
OBJECT Codeunit $CodeunitID PublishWebServices
{
  OBJECT-PROPERTIES
  {
    Date=01/01/17;
    Time=00:00:00;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    PROCEDURE $($Method)@60000();
    VAR
      Handled@60000 : Boolean;
    BEGIN
      OnBeforePublishWebServices(Handled);

      DoPublishWebServices(Handled);

      OnAfterPublishWebServices;
    END;

    LOCAL PROCEDURE DoPublishWebServices@60001(VAR Handled@60000 : Boolean);
    VAR
      AllObj@60001 : Record 2000000038;
    BEGIN
      IF Handled THEN EXIT;

      RemoveAllCurrentWebServices;

      FilterAllWebServices(AllObj);

      IF AllObj.FINDSET THEN
        REPEAT
          PublishWebService(AllObj);
        UNTIL AllObj.NEXT < 1;
    END;

    LOCAL PROCEDURE RemoveAllCurrentWebServices@60012();
    VAR
      WebServiceAggregate@60000 : TEMPORARY Record 9900;
      ADMgt@60001 : Codeunit 60003;
    BEGIN
      WITH WebServiceAggregate DO BEGIN
        PopulateTable;

        SETFILTER(""Service Name"", ADMgt.GetAppWSPrefix + '*');
        DELETEALL(TRUE);
      END;
    END;

    LOCAL PROCEDURE FilterAllWebServices@60004(VAR AllObj@60000 : Record 2000000038);
    VAR
      ADMgt@60001 : Codeunit 60003;
    BEGIN
      WITH AllObj DO BEGIN
        SETFILTER(""Object Name"",ADMgt.GetAppWSPrefix + '*');
      END;
    END;

    LOCAL PROCEDURE PublishWebService@60008(VAR AllObj@60000 : Record 2000000038);
    VAR
      WebServiceAggregate@60001 : TEMPORARY Record 9900;
    BEGIN
      WITH AllObj DO BEGIN
        WebServiceAggregate.INIT;
        WebServiceAggregate.""Object Type"" := AllObj.""Object Type"";
        WebServiceAggregate.""Object ID"" := AllObj.""Object ID"";
        WebServiceAggregate.""Service Name"" := AllObj.""Object Name"";
        WebServiceAggregate.Published := TRUE;
        WebServiceAggregate.INSERT(TRUE);
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePublishWebServices@60002(VAR Handled@60001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPublishWebServices@60003();
    BEGIN
    END;

    BEGIN
    END.
  }
}


"

Import-NAVApplicationObjectFromString `            -ObjectString $Codeunit `            -ServerInstance $ModifiedServerInstance `            -LogPath (join-path $NavAppWorkingFolder 'CreateWebServices\Log') `            -ImportAction Default `            -SynchronizeSchemaChanges Yes Compile-NAVApplicationObject2 `            -ServerInstance $ModifiedServerInstance `            -LogPath (join-path $NavAppWorkingFolder 'CreateWebServices\Log') `            -Filter "Type=Codeunit;Id=$CodeunitId"Get-NAVCompany -ServerInstance $ModifiedServerInstance | foreach {        Invoke-NAVCodeunit -CompanyName $_.Companyname -ServerInstance $ModifiedServerInstance -CodeunitId $CodeunitID -MethodName $Method}Delete-NAVApplicationObject2 -ServerInstance $ModifiedServerInstance -LogPath (join-path $NavAppWorkingFolder 'CreateWebServices\Log') -Filter "Type=Codeunit;Id=$CodeunitId"Start-NAVApplicationObjectInWindowsClient -ServerInstance $ModifiedServerInstance -ObjectType Page -ObjectID 810