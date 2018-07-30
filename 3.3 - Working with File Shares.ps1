# Using the Azure File Shares with Windows PowerShell
Set-Location C:\
Clear-Host

$GeneralAccount = $RG | New-AzureRmStorageAccount -Name "azurestoragetutorial" `
 -SkuName Standard_LRS `
 -Kind StorageV2

# With the storage account created, we can now create one or more file shares
$Departments = @("Sales","Marketing","Operations") 
Foreach ($Dept in $Departments) {
  $GeneralAccount | New-AzureStorageShare -name "$($Dept.ToLower())"
}

#Setting the quota (size) for the shares
$GeneralAccount | Get-AzureStorageShare | Set-AzureStorageShareQuota -Quota 500

#Adding content: Several options
# Upload a file with 
$sales = $GeneralAccount | Get-AzureStorageShare "sales"
$sales | New-AzureStorageDirectory -Path "Pictures"
$sales | Set-AzureStorageFileContent -Source D:\localPhotos\Portugal.jpg -Path "Pictures\Portugal.jpg"



# Mapping the drive
# You need to know the storageAccount and Share name
$StorageAccountName = $GeneralAccount.StorageAccountName
$ShareName = $sales.Name
$SMBSharePath = "\\$StorageAccountName.file.core.windows.net\$ShareName"

#You need to create a credential object
# You need a storage account key
$rawkey = $GeneralAccount | Get-AzureRmStorageAccountKey | Select-Object -First 1 -ExpandProperty Value
$secKey = $rawkey | ConvertTo-SecureString -AsPlainText -Force 
# And a username - the storage account name
$AccountName = "Azure\$StorageAccountName"
# To create the credential object
$salesCredential = New-Object pscredential -ArgumentList $AccountName, $secKey

# Now you have everything you need to map the drive:
New-PSDrive -Name Z -PSProvider FileSystem -Root $SMBSharePath -Credential $salescredential -Persist


# Let's finish up with finding and downloading content from our SMB share with PowerShell
New-Item -ItemType directory D:\localPhotos\FromShare

$Sales | Get-AzureStorageFile

$Pictures = $Sales | Get-AzureStorageFile

$Pictures | Get-AzureStorageFile

$PictureFiles = $Pictures | Get-AzureStorageFile
$PictureFiles | Get-AzureStorageFileContent -Destination D:\localPhotos\FromShare

