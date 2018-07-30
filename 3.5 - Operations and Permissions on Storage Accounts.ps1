# Snapshots
$RG = Get-AzureRMResourceGroup -Name "StorageLesson"
$v2Context = ($RG | Get-AzureRmStorageAccount -Name "azurestoragetutorial").Context

$Sales = Get-AzureStorageShare -Name "sales" -Context $v2Context

$Sales
$Sales | Get-AzureStorageFile -path \pictures | Get-AzureStorageFile

$Snapshot = $Sales.SnapshotAsync().Result

Get-AzureStorageShare -Context $v2Context 

$Sales | Get-AzureStorageFile

$Sales | Get-AzureStorageFile -Path "Pictures\Portugal.jpg"

$Sales | Remove-AzureStorageFile -Path "Pictures\Portugal.jpg"


# Restore SampleUpload.txt from the share snapshot
Start-AzureStorageFileCopy `
    -SrcShare $Snapshot `
    -SrcFilePath "Pictures\Portugal.jpg" `
    -DestShareName "sales" `
    -DestContext $v2Context `
    -DestFilePath "Pictures\Portugal.jpg"

#Lots of variations on using Filecopy to get files from one place to another
# https://docs.microsoft.com/en-us/powershell/module/Azure.Storage/Start-AzureStorageFileCopy

$Sales | Get-AzureStorageFile -Path "Pictures\Portugal.jpg"

# Key management
## Recreate a key
$v2Context | New-AzureRmStorageAccountKey -KeyName key1 -ResourceGroupName "StorageLesson"
$v2Context | Get-AzureRmStorageAccountKey -ResourceGroupName "StorageLesson"
## Change a key to read-only
$Keys = $v2Context | Get-AzureRmStorageAccountKey -ResourceGroupName "StorageLesson"
$Keys
$Keys[0]

