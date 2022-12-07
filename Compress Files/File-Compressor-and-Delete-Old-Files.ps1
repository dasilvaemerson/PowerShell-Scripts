function CompressFiles {
    <#
    .SYNOPSIS
        Create a ZIP for every file in the source folder that are older than x day and delete the original file. 
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
        This parameter is optional. As default, the numbers of days ist set to 737819, what is equivalent to more or less 2000 years ago.

    .PARAMETER CompressionDate
        Specifies the number of days as an INT. It will be used to compress all files in the target path that are older than the given number.
        The original file will be deleted after the compression.
        This parameter is optional. As default, the numbers of days ist set to 737819, what is equivalent to more or less 2000 years ago.

    .PARAMETER Recurse
        Specifies if the script should work only on the files located in the target path (-Recurse $false) or if it should also run in the subdirectories (-Recurse $true).
        As standart, -Recurse is equal to $false.

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
        CompressFiles -Folder D:\ServerLog -CompressionDate 30

        CompressFiles -Folder D:\ServerLog -DeleteOlderThan 30

        CompressFiles -Folder D:\ServerLog -CompressionDate 30 -DeleteOlderThan 60

        CompressFiles -Folder D:\ServerLog -CompressionDate 30 -Recurse $true

        CompressFiles -Folder D:\ServerLog -DeleteOlderThan 30 -Recurse $true

        CompressFiles -Folder D:\ServerLog -CompressionDate 30 -DeleteOlderThan 60 -Recurse $true
    #>

    [CmdletBinding()]
    param(
        [Parameter(Position=0,mandatory=$true)]
        [string]$Folder,
        [Parameter(Position=1,mandatory=$false)]
        [int]$DeleteOlderThan = 737819, 
        [Parameter(Position=2,mandatory=$false)]
        [int]$CompressionDate = 737819,
        [Parameter(Position=3,mandatory=$false)]
        [boolean]$Recurse = $false) # end param
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $limit = (Get-Date).AddDays(-$DeleteOlderThan)
    $SourceFolder = $Folder

    $refDate = (Get-Date).AddDays(-$CompressionDate)

    # TEST IF THE GIVEN PATH IS VALID
    if(Test-Path -Path $Folder){
        Write-Output "Path $Folder found"
    } 
    else {
        Write-Output "ERROR - PATH NOT FOUND: $Folder "
        Write-Host "Closing application..."
        Exit
        }

    # COMPRESS FILES OLDER THAN X
    Get-ChildItem $SourceFolder -file -Recurse:$Recurse |
    Where {$_.FullName -notlike "*.bz2"} | Where {$_.FullName -notlike "*.gz"} | Where {$_.FullName -notlike "*.zip"} |
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
      # DELETE FILES OLDER THAN X
      Get-ChildItem $SourceFolder -file -Recurse:$Recurse |
        Where-Object { $_.LastWriteTime -lt $limit } | select * |
            Foreach-Object {
            $_ | Remove-Item -Force -Whatif
      }

    try
    {
        # >>>>>> Insert script here.
    }

    finally
    {
        Write-Output "Compression of $SourceFolder Done. Elapsed time: $($stopwatch.Elapsed)"
    }

}

CompressFiles -Folder D:\ServerLog -CompressionDate 30 -DeleteOlderThan 60 -Recurse $true

#help CompressFiles
#get-help CompressFiles -examples
#get-help CompressFiles -parameter Folder
#get-help CompressFiles -parameter DeleteOlderThan
#get-help CompressFiles
