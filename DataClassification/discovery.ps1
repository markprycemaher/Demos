
$Query = "select * from [dbo].[vwInstances] "
$SQL_Query_db = "select name from sys.databases where database_id > 5"
$SQL_Query_Add_Database = 'exec AddDatabase'




$CentralDBAServer = "MININT-IG7S4G6\sql2017"
$CentralDatabaseName = "db_Classify"


$AlltheServers= Invoke-Sqlcmd -ServerInstance $CentralDBAServer -Database $CentralDatabaseName -Query $query

$AlltheServers
foreach($db in $AlltheServers)
{


    $theInstanceName = $db[0]
    $theDatabasename = $db[2]
    $theInstanceID = $db[4]

    $theInstanceName
    $theDatabasename

    if  ( $theDatabasename.ToString() -eq ''  )
    {  
         Write-Debug 'No databases found - collect local database information'
        
        
         $dblist = Invoke-Sqlcmd -ServerInstance $theInstanceName -Database 'master' -Query $SQL_Query_db 
         
         foreach($newDB in $dblist)
         {
            $Add_DB = $SQL_Query_Add_Database  + ' ' + $theInstanceID.ToString() + ', "' + $newDB[0] + '"'
             $Add_DB
            Invoke-Sqlcmd -ServerInstance $CentralDBAServer -Database  $CentralDatabaseName -Query $Add_DB
         }
         
    }
    else
    {
       Write-Debug 'Databases found - collecting information'

       $pathToDataClassificationScript =  Get-ScriptDirectory + '\gdpr.sql'



    }


}


function Get-ScriptDirectory {
    if ($psise) {Split-Path $psise.CurrentFile.FullPath}
    else {$global:PSScriptRoot}
}
