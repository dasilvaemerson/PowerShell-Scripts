function CompressFiles {
    <#
    .SYNOPSIS
        Create a ZIP for every file in the source folder that are older than x day, delete original file. 
        There is an aditional option for deleting every file that is older than X days after the compression.

    .DESCRIPTION
        This function can be used to compress all the files in the source folder that are older than X days.
        The original file is deleted after the compression.
        The Zip-File has the same Creation Time, Acess Time and Last Write Time as the original file.
        The Zip File is named after the original file.
        There is an aditional option for deleting every file that is older than X days after the compression (Parameter -DeleteOlderThan).

    .PARAMETER Folder
        Specifies the target Path as a STRING. This parameter is mandatory.

    .PARAMETER DeleteOlderThan
        Specifies the number of days as an INT. It will be used to delete all files in the target path that are older than the given number.
        This parameter is mandatory.

    .PARAMETER CompressionDate
        Specifies the number of days as an INT. It will be used to compress all files in the target path that are older than the given number.
        The original file will be deleted after the compression.
        This parameter is mandatory.

    .NOTES
        Version:        1.0
        Author:         <Emerson da Silva>
        Creation Date:  <30.11.2022>
        Purpose/Change: Automatic sorting and compression of log files on the server to save space.
        Already compressed files are ignored by the function (.bz2, .gz, .zip)
        Folders are ignored by the function
        Folder Structure is kept and empty folders are not deleted.
        If a Zip File already exists, it will be replaced
  
    .EXAMPLE
        CompressFiles -Folder D:\ServerLog -CompressionDate 60 -DeleteOlderThan 9999
    #>

    [CmdletBinding()]
    param(
        [Parameter(Position=0,mandatory=$true)]
        [string]$Folder,
        [Parameter(Position=1,mandatory=$true)]
        [int]$DeleteOlderThan,
        [Parameter(Position=2,mandatory=$true)]
        [int]$CompressionDate) # end param
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $excluded = @("*.bz2", "*.gz", "*.zip")
    $limit = (Get-Date).AddDays(-$DeleteOlderThan)
    $SourceFolder = $Folder

    $refDate = (Get-Date).AddDays(-$CompressionDate)

    Get-ChildItem $SourceFolder -file -Exclude $excluded -Recurse |
    Where-Object { $_.LastWriteTime -lt $refDate } | select * |
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

    try
    {
        # >>>>>> Insert script here.
    }

    finally
    {
        Write-Output "Compression of $SourceFolder Done. Elapsed time: $($stopwatch.Elapsed)"
    }

}

CompressFiles -Folder D:\ServerLog -CompressionDate 60 -DeleteOlderThan 9999