# Tenants, Subscriptions and Accounts are all important...

# But once we're logged in... now what?
Set-Location C:\
Clear-Host

# Let's start with Resource Groups
 # Resource Groups are a logical grouping of resources
 # Useful for separating out applications, use cases, teams or environments
 # Group the resources that you want into a single resource group...  
 # Delete the resource group and you're sure to not leave any forgotten resources behind

 New-AzureRmResourceGroup -Name "AzurePowerShellCourse" -Location "westus2" -Tag @{Use="Training";Publisher="PacktPub"}
 Get-AzureRmResourceGroup -Name "AzurePowerShellCourse" 
 
 # 3 Useful concepts - passing the resource group through the pipeline and using the -Whatif parameter
 $ResGroup = Get-AzureRmResourceGroup -Name "AzurePowerShellCourse"
 $ResGroup | Remove-AzureRmResourceGroup -WhatIf

# Another pattern with AzureRM:  Save object as a variable, change variable properties, save with "set"
 $ResGroup.Tags
 $ResGroup.Tags = $null
 $ResGroup.Tags += @{Author="Michael Simmons"}
 $ResGroup.Tags += @{Course="PowerShell for AzureRM (IaaS)"}
 $ResGroup | Set-AzureRmResourceGroup

 # Locations are an important property. Many of the commands don't work without it...
 Get-AzureRmLocation

 # And not all resources are available in every location. 
 Get-AzureRmLocation | Where-Object {$_.Providers -contains "Microsoft.Automation" -and $_.DisplayName -like "* US*"}
 Get-AzureRmLocation | Where-Object {$_.Providers -notcontains "Microsoft.Automation" -and $_.DisplayName -like "* US*"}

 #It's important to know that each resource has a unique Resource ID.
 # So even though you can have multiple VMs named "Web1", each of those still has
 # a unique identifier associated with it.
$RandomVM = Get-AzureRMVM | Get-Random 

# So the VM has a unique ID
$RandomVM.ID

#And when a resource (like the VM) uses another resource (like a network card)...
# BOTH of the resources have their own resource ID
$RandomVM | Get-AzureRmResource
$RandomVM.Id
$RandomVM.StorageProfile.OsDisk.ManagedDisk.Id
$NICId = $RandomVM.NetworkProfile.NetworkInterfaces[0].Id
$NICId
Get-AzureRmResource -ResourceId $NICId

$AdminAccount = Get-Credential "LocalAdmin"
$VMCreateTime = Measure-Command { New-AzureRMVM -Name "testVM" -Credential $AdminAccount} 
$VMCreateTime

$VMAsJobWaitTime = Measure-Command {New-AzureRMVM -AsJob -Name "testVMAsJob" -Credential $AdminAccount}
$VMAsJobWaitTime 

$JobStatusDuringBuild = Get-Job
$JobStatusDuringBuild | Receive-Job

#Using locks to keep resources from deletion

New-AzureRmResourceLock -LockName "testVMNoDelete" -LockLevel CanNotDelete -ResourceGroupName "testvm" -LockNotes "Remove Lock after testing" 
New-AzureRmResourceLock -Scope

Get-AzureRmResourceGroup "testvm" | Remove-AzureRMResourceGroup -AsJob -Force
Get-Job -Id 3 | Format-List 
Get-Job 2 | Select-Object -ExpandProperty error 

Get-AzureRMResourceLock | Remove-AzureRmResourceLock
Get-AzureRmResourceGroup "testvm" | Remove-AzureRMResourceGroup -AsJob -Force
