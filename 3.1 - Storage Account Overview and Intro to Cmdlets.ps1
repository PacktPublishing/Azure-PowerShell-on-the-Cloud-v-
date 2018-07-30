#Storage Account Overview and Intro to the Cmdlets


#Rules for creating your storage account
#  names:
#  - have to be unique
#  - only lowercase letters, numbers, and hyphens

# Securing the storage accounts
#  keys:
#  - Access keys are basically ridiculously long passwords associated with the account.
#  - There are 2 keys for a storage account
#  - You can regenerate the access keys
#  network rules:
#  - Default is "allow from Internet"
#  - You can be more specific to allow only from select networks or IP ranges

# Working with storage content
#  blobs:
#  - "binary large objects"
#  - BLOCK blobs: "Files" (MOST)
#  - APPEND blobs: "Logs"
#  - PAGE blobs: "Azure VM disks"
#  files:
#  - File shares (SMB)
#  tables:
#  - A NoSQL database instance
#  queues:
#  - A simple message queue


# There are 2 modules that help us to manage all of our storage resources:
# - The AzureRM.Storage is used for creating and managing the storage accounts
Get-Command -module AzureRM.Storage

# - The Azure.Storage module holds cmdlets used to manage shares, files and blobs
Get-Command -module Azure.Storage
