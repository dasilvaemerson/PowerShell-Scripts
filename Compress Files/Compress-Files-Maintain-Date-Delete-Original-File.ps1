<#
SCRIPT FUNCTIONALITY:
    Create a ZIP for every file in the source folder.
    The Zip-File has the same Creation Time, Acess Time and Last Write Time as the original file.
    The Zip File is named after the original file.
    Old File is deleted after the compression

NOTE:
    ! ✓ Ignore compressed files (.bz2, .gz, .zip)
    ! ✓ Ignore folders
    ! ✓ Delete old file
    ! ✓ Keep folder structure
    ! ✓ Do not delete folders
    ! ✓ Replace ZIP if file already exists
    ! ✓ Delete files older than X days

    # Code Refactoring: Make a Function out of the script with dinamic Path and Date.
#>


# List of folders to be excluded of the script, so the entire folder is not compressed on D:\
$excluded = @("*.bz2", "*.gz", "*.zip")
$limit = (Get-Date).AddDays(-30)
$SourceFolder = "D:\ServerLog"

Get-ChildItem $SourceFolder -file -Exclude $excluded -Recurse | select * |
  Foreach-Object {
    # Store the data of the original file.
    $CreationTime = $_.CreationTime
    $LastWriteTime = $_.LastWriteTime
    $LastAcessTime = $_.LastAccessTime
    
    # Set the information for the compression, like name and path.
    $_.FullName
    $Name = $_.Name
    $DirectoryName = $_.DirectoryName
    $zip = $Name + ".zip"
    $zipPath = $DirectoryName + "\" + $zip

    # File compression
    Compress-Archive -Path $_.FullName -DestinationPath $zipPath -Update

    # Change the properties of the Zip-File as the same of the original file
    Set-ItemProperty -Path $zipPath -Name CreationTime -Value $CreationTime
    Set-ItemProperty -Path $zipPath -Name LastWriteTime -Value $LastWriteTime
    Set-ItemProperty -Path $zipPath -Name LastAccessTime -Value $LastAcessTime

    # Remove old file after creating a compressed version
    $_ | Remove-Item

  }

# Remove every file where the modification date is older than the $limit (For example, older than 30 days)
Get-ChildItem -Path $SourceFolder -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit } | Remove-Item -Force

