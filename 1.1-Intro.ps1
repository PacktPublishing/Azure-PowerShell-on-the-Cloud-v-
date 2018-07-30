Set-Location C:\
Clear-Host

$AzureRMModule = Find-Module AzureRM
$AllAzureRMModules = Find-Module AzureRM*

$AzureRMModule | Measure-Object 
$AllAzureRMModules | Measure-Object 

$AllAzureRMModules | Where-Object Name -like *Compute*