Set-Location C:\
Clear-Host

Get-Command -Module AzureRM* -Name *VM* | Measure-Object


# Descriptions of the VM
# Image - the OS, Version, SKU, etc.
# Size  - CPUs, RAM, etc.
# Location, Resource Group, Tags
# Status - Is it provisioned and running


# Resources 
# ---------
# Network - network cards, public and private IP addresses
# Disks - OS and Data disks



# Software Configuration
# ---------------------
# OS Configuration
# - Admin Username
# Extensions
# - Desired State Configuration
# - Anti-Virus

Get-Command -Noun AzureRmVM
Get-Command -Noun AzureRmVMConfig
Get-Command -Noun AzureRmVMImage*
Get-Command -Noun AzureRmVMNetworkInterface
Get-Command -Noun AzureRmVMDataDisk
