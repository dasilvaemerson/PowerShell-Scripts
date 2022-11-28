<# 
SCRIPT FUNCTIONALITY:
    Compress ALL files in the path into a Zip file


NOTES:
    To compress only specific type of files (ex: PDF):
    Compress-Archive -Path 'D:\temp\test zipping flow\*.pdf' -DestinationPath 'D:\temp\final.zip' -Force
#>

$path = "D:\ServerLog"
$destinationPath = "D:\ServerLog\Draft.zip"

Compress-Archive -Path $path -DestinationPath $destinationPath -Force



