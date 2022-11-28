<# Block
comments
look like this #>

# Get-Date 
# Get-Date -DisplayHint Date
# Get-Date -DisplayHint Time

# Get-Content "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Snipping Tool.lnk"

# Start-Process notepad

# Write-Output "Print something" -Foregroundcolor Green      # Das ist ein Print
# read-host  "Please, write a number: "     #Das ist ein input.

# Creates a new folder with name "Test Folder"
# new-item -Path "C:\Users\emerson\Downloads\Test\Bash-Shell\Test Folder" -ItemType Directory

# Creates a new file with name "Test File.txt"
# new-item -Path "C:\Users\emerson\Downloads\Test\Bash-Shell\Text.txt" -ItemType File
# Set-Content D:\temp\test\test.txt 'Welcome to TutorialsPoint'
# Add-Content D:\temp\test\test.txt 'World!'
# Clear-Content D:\temp\test\test.txt  

# Copy-Item 'D:\temp\Test Folder' 'D:\temp\Test Folder1'

# Remove-Item 'D:\temp\Test Folder1'

# Move-Item D:\temp\Test D:\temp\Test1

# Rename-Item "D:\temp\Test Test1"

# (Get-Content D:\temp\test\test.txt).length   # Read a file. The length show how many chars are there.

# Test-Path D:\temp\test    #Test existence of a folder
# Test-Path D:\temp\test\test.txt   # Test existence of a file.

# Set-Location c:\   # Bring you to the C:\ directory

# Test-Connection 8.8.8.8

# Get-Service | Where-Object {$_.Status -eq "Stopped"}

# 1000,2000,3000 | ForEach-Object -Process {$_/1000}

# "Microsoft.PowerShell.Core", "Microsoft.PowerShell.Host" | ForEach-Object {$_.Split(".")}

# Start-Sleep -s 15

# Write-Warning  "Test Warning"


#####################################

$variable = "test"
$array = @("item1", "item2", "item3")

# $array[0]
# for($i = 0; $i -lt $array.length; $i++){ $array[$i] }
# foreach ($element in $array) { $element }
# $array | foreach { $_ }

$counter = 0;

<#
   while($counter -lt $array.length){
   $array[$counter]
   $counter += 1
}
#>

<#
do {
   $array[$counter]
   $counter += 1
} while($counter -lt $array.length)
#>

$x = 10

<#
if($x -le 20){
   write-host("This is if statement")
}

######

if($x -le 20){
   write-host("This is if statement")
}else {
   write-host("This is else statement")
}

#####

if($x -eq 10){
   write-host("Value of X is 10")
} elseif($x -eq 20){
   write-host("Value of X is 20")
} elseif($x -eq 30){
   write-host("Value of X is 30")
} else {
   write-host("This is else statement")
}


switch(3){
   1 {"One"}
   2 {"Two"}
   3 {"Three"}
   4 {"Four"}
   3 {"Three Again"}
}

# In the below example, we've created an alias help for Get-Help cmdlet.
# New-Alias -Name help -Value Get-Help  




#>








 

