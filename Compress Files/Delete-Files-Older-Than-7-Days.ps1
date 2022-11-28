<# 
SCRIPT FUNCTIONALITY:
    Delete files that are older than 7 days
    Delete any empty directories left behind after deleting the old files.


NOTES:
    "-Force" deletes hidden and read-only files as well.
    Do you want to delete files that were not updated in 7 days instead of older than 7 days? Use $_.LastWriteTime instead of $_.CreationTime.
    "-Recurse" search sub-directories
    Do you want to see what files or folders will be deleted before deleting them? Add "-WhatIf" to the "remove-item" at the end of both lines 
    
    To ignore files that beggin with "A":
    Get-ChildItem -Path C:\Test\Logs\* -Exclude A*
#>



# Delete files that are older than 7 days

$limit = (Get-Date).AddDays(-7)
$path = "D:\ServerLog"

Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse




