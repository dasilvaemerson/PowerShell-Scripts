#This file is only used for notes on Functions with Powershell

function functionExample {
    "Hello World"
}

functionExample

function helloArg {
    "Hello $args"
}

helloArg Emerson da Silva

function helloArg1 {
    "Hello $($args[1])"
}

helloArg1 John Tester

function Write-Message-To ($Message, $Person) {
    "Dead $Person, $Message"
}

Write-Message-To -message "How Are you?" -Person "Bob"
Write-Message-To "How Are you?" "Bob"

function ReturnString ($p1, $p2) {
    $x = $p1 + $p2
    return $x
}

ReturnString -p1 "hello " -p2 "world"
ReturnString -p1 1 -p2 2

# This one accepts only Int as parameter
function ReturnInt ([int]$p1, [int]$p2) {
    $x = $p1 + $p2
    return $x
}

ReturnString -p1 1 -p2 2

function example {
    [CmdletBinding()]
    param (

        [Parameter(
            Position = 0,
            Mandatory = $false
            )]
            [string]
            $City,

        [Parameter(Position = 1)]
        [ValidadeSet('Metric', 'USCS')]
        [string]
        $Units = 'USCS'





    )
    
}