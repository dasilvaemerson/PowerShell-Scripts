<#
SCRIPT FUNCTIONALITY:
    Read every file in the folder (except Zip-Files)
    Files where the modification date is older than 7 Days are compressed in a Zip-File in the folder.
    This is made on the Source-Folder and every sub-folder.

NOTE:
    The -WhatIf switch at the end is a safety switch. 
    Remove the -WhatIf switch so the files are deleted after the compression.
    Keep the -whatIf switch so it displays what would be deleted after the compression. 
#>


$SourceFolder = "D:\ServerLog"
$refDate      = (Get-Date).AddDays(-7)

Get-ChildItem -Path $SourceFolder -File -Recurse -Exclude "*.zip" | 
    Where-Object { $_.LastWriteTime -lt $refDate } |
    Group-Object DirectoryName | ForEach-Object {
        # construct the target folder path for the zip file using the Name of each group
        $zip = Join-Path -Path $_.Name -ChildPath 'OlderThan7Days.zip'
        # archive all files in the group
        Compress-Archive -Path $_.Group.FullName -DestinationPath $zip -Update

        # here is where you can delete the original files after zipping
        $_.Group | Remove-Item -WhatIf
    }


<#
ALTERNATIVE:
    Check if file is older than 7 days
    Zip all files and folders that check.
    Delete zipped files
#>

<#
$items  = Get-ChildItem -Path D:\ServerLog
$items | ForEach-Object {
    $lastwrite = ($_).LastAccessTime
    $timespan = New-TimeSpan -days 7 -hours 0 -Minutes 0
    
    if(((get-date) - $lastwrite) -gt $timespan){
        $name = $_.Name
        $_ | Compress-Archive -DestinationPath "D:\Data\Archive\$name.zip"
        $_ | Remove-Item
    }
}
#>