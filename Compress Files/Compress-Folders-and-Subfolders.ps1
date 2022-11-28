<# This script uses Compress archives (ZIP) to compress multiple (sub)folders 
and saves them individually in separate zip files.
#>
 
# Specify source folder
$source = "D:\ServerLog"
 
# Specify zip file location folder (destination folder, make sure it exists)
$destination = "D:\ServerLog"
 
# Action
$subfolders = Get-ChildItem $source -Directory -Recurse
foreach ($s in $subfolders) {
 
$folderpath = $s.FullName
$foldername = $s.Name
 
Compress-Archive `
-Path $folderpath `
-DestinationPath $destination\$foldername
 
}
