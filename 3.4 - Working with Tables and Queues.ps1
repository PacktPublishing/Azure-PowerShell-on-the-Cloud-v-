Set-Location C:\
Clear-Host

# Tables
# Creating a Table
# Using the "general" Storage Account 
$StorageAccount = Get-AzureRmStorageAccount -ResourceGroupName "StorageLesson" -Name azurestoragetutorial
$v2Context = $StorageAccount.Context

$Table = New-AzureStorageTable –Name Table -Context $v2Context

# Retrieve the list of tables to verify the table has been removed.
$StorageAccount | Get-AzureStorageTable -Name Table
Get-AzureStorageTable –Context $v2Context -Name Table

#Removing the entire table
Remove-AzureStorageTable –Name Table –Context $v2Context 
$v2Context | Remove-AzureStorageTable -Name Table -WhatIf
$Table | Remove-AzureStorageTable -WhatIf

# Options for populating tables:
# AZCopy    https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy
# REST API  https://docs.microsoft.com/en-us/rest/api/storageservices/table-service-rest-api
# AzureRMStorageTable Module  https://blogs.technet.microsoft.com/paulomarques/2017/01/17/working-with-azure-storage-tables-from-powershell/



# Queues
# Creating a Queue
$v2Context | New-AzureStorageQueue -Name messagequeue123

$MQ = Get-AzureStorageQueue -Name "messagequeue123" -Context $StorageAccount.Context

$MQ | Remove-AzureStorageQueue 

