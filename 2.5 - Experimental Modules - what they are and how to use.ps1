#Finding out more about the Azure PowerShell modules and what's coming next

 https://github.com/Azure/azure-powershell/projects
 
#Keeping your modules up to date
Update-Module AzureRM

#Checking if there's a newer module
# To find the latest version of a module, use Find-Module
# To find the currently installed version of a module, use Get-Module (-listavailable)
# To update to the latest module, use Update-Module


Function Compare-ModuleVersion {
  Param ($Name, [switch]$Autoupdate)
    $InstalledVersion = (Get-Module -Name $Name -ListAvailable).Version
    $OnlineVersion = (Find-Module -Name $Name ).Version
    if ($OnlineVersion -gt $InstalledVersion ) {
      Write-Host "Newer version of $Name is available. (Installed: $InstalledVersion) (Online: $OnlineVersion)" 
      if ($Autoupdate) {
        Update-Module $Name -Verbose
      }
    } else {
      Write-Host "Installed: $InstalledVersion"
      Write-Host "Online: $OnlineVersion"
    }
}

Compare-ModuleVersion -Name AzureRM -Autoupdate
