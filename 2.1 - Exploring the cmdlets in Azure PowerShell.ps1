Set-Location C:\
Clear-Host

# Finding cmdlets in the Azure modules
# What are the modules in Azure RM? 
Get-Module AzureRM*Storage* -ListAvailable

Get-Command *Disk* -Module AzureRM*

#Structure of the cmdlets - LOOOONG Nouns

Get-Command Get-VM

Get-Service 

# Get-VM? No...
# Get-AzureVM?  Not quite...
# Get-AzureRMVM   A-ha! 

#Get a better understanding of PowerShell through practice with AzureRM IaaS Resources

Get-Command New-AzureRMVM -Syntax

Get-Help New-AzureRMVM -Online

New-AzureRMVM -

#Storage

Get-Command -Module AzureRM.Storage

#Network 

Get-Command -Module AzureRM.Network
Get-Command -Module AzureRM.Network | Measure-Object 

#Virtual Machines

Get-Command -Module AzureRM.Compute 
Get-Command -Module AzureRM.Compute | Measure-Object 

