#Using contexts to access subscriptions and save credentials

Set-Location C:\
Clear-Host

# Context Parts:
# - Environment
# - Tenant
# - Subscription
# - Account
# - Credentials

Login-AzureRmAccount
#The alias is Login-AzureRMAccount
New-AzureRmResourceGroup -Name "AzurePowerShell" -Location "westus"
Get-AzureRMResourceGroup -Name "AzurePowerShell"


#In a new session, the context needs to be created again.
Set-Location C:\
Clear-Host

Get-AzureRMResourceGroup -Name "AzurePowerShell"

#By using Context Autosave, your already connected
Enable-AzureRmContextAutosave

#With autosave enabled, when we log in it will get saved
Set-Location C:\
Clear-Host
Get-AzureRMResourceGroup -Name "AzurePowerShell"


Disable-AzureRmContextAutoSave

Get-AzureRMSubscription 

$Ent = Set-AzureRmContext -Subscription "Visual Studio Enterprise" -Name "VSEnterprise"
$MSDN = Set-AzureRmContext -Subscription "Visual Studio Ultimate with MSDN" -Name "MSDN"

Get-AzureRMResourceGroup -Name "AzurePowerShell" -DefaultProfile $MSDN
Get-AzureRMResourceGroup -Name "AzurePowerShell" -DefaultProfile $Ent

New-AzureRmResourceGroup -Name "MyMSDNResourceGroup" -Location "westus" -DefaultProfile $MSDN
Remove-AzureRMResourceGroup -Name "MyMSDNResourceGroup" -DefaultProfile $MSDN

