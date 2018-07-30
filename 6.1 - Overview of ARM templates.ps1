Set-Location c:\
Clear-Host

# Editing the Azure Resource Manager Templates in VSCode: Load the Azure Resource Manager Tools

# Start with a large collection of sample templates: 
#  https://github.com/Azure/azure-quickstart-templates

Set-Location D:\
New-Item Repos -ItemType Directory
Set-Location D:\Repos

git clone https://github.com/Azure/azure-quickstart-templates

Set-Location D:\Repos\azure-quickstart-templates
Get-Childitem



# Get-Help New-AzureRmResourceGroupDeployment -Online
# Get-Help Save-AzureRmResourceGroupDeploymentTemplate -Online

