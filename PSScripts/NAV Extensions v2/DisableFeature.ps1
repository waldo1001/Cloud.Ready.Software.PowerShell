Invoke-ScriptInBcContainer -containerName "demos" -scriptblock {
    invoke-sqlcmd -query "Update [dbo].[Tenant Feature Key] SET Enabled = 0 where ID = 'ExtensibleExchangeRateAdjustment'" -serverinstance "localhost\SQLEXPRESS" -database "CRONUS"
    invoke-sqlcmd -query "delete from [dbo].[Tenant Feature Key] where ID = 'ExtensibleExchangeRateAdjustment'" -serverinstance "localhost\SQLEXPRESS" -database "CRONUS"
    invoke-sqlcmd -query 'Update [dbo].[Feature Data Update Status$63ca2fa4-4f03-4f2b-a480-172fef340d3f] SET [Feature Status] = 0 where [Feature Key] = ''ExtensibleExchangeRateAdjustment''' -serverinstance "localhost\SQLEXPRESS" -database "CRONUS"

    set-navserverinstance BC -restart
}
