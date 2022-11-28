<#
SCRIPT FUNCTIONALITY:
    Creates a 'Temp' folder
    Read every file in the folder
    Files where the modification date is older than 7 Days are move the the 'Temp' folder.
    Temp folder is compressed and saved as 'Backup.zip'.

NOTE:
    It just checks the Source Folder, not the Sub-Folders

    Optional at the end: Delete Temp Folder after the backup
#>

$SourceFolder = "D:\ServerLog"
$TempPath = "D:\ServerLog\Temp"
$destinationPath = "D:\ServerLog\Backup.zip"
$refDate      = (Get-Date).AddDays(-7)

# Create Temp folder to store files to be archived
if (Test-Path -Path $TempPath) {
    "Temp already exists!"
} else {
    "Temp doesn't exist."
    New-Item D:\ServerLog\Temp -type directory
}


# Get all children of SourceFolder older than '7' days and move to temp folder
get-childitem -Path $OriginalLocation |
    where-object {$_.LastWriteTime -lt $refDate} | 
    move-item -destination $TempPath

# Compress the files located on the 'Temp' folder as 'Backup.zip'
Compress-Archive -Path $TempPath -DestinationPath $destinationPath -Force


# Delete the 'Temp' Folder after the backup
# Remove-Item -LiteralPath $TempPath -Force -Recurse


