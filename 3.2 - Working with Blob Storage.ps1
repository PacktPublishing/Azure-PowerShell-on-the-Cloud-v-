#Creating a new storage account

Set-Location c:\
Clear-Host

# Creating a BLOB storage
# - Needs: Blog Storage Account, a Container (like "Folder") and some content

$RG = New-AzureRMResourceGroup Storage -Location 'West US'

$BlobAccount = $RG | New-AzureRmStorageAccount -Name "azurestoragetutorialblob" `
 -SkuName Standard_GRS `
 -Kind BlobStorage `
 -AccessTier Hot

# Now we need a container to store our blobs. Extra bonus: since we will need it again, save it as a variable
$PhotosContainer = New-AzureStorageContainer -Name "photos" -Permission Blob -Context $BlobAccount.Context






New-AzureRmStorageAccount