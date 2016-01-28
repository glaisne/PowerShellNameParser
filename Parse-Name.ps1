param(
    [string] $name
)


<#
Possible patterns:
    First Last
    First Last Suffix
    First Mi Last
    First Mi Last Suffix
    First Middle Last
    First Middle Last Suffix

    X Last, First
    X Last, First Mi
    X Last, First Middle
    X Last Suffix, First
    X Last Suffix, First Mi
    X Last Suffix, First Middle
#>

<# Known Issues:
PS PowerShell:\work\Scripts> .\Parse-Name.ps1 -name "DANIEL Harmon III"


MiddleName    : Harmon
Suffix        :
FirstName     : DANIEL
MiddleInitial :
LastName      : III

#>

$parsedName = new-object psobject -Property @{
    FirstName     = [string]::Empty
    LastName      = [string]::Empty
    MiddleInitial = [string]::Empty
    MiddleName    = [string]::Empty
    Suffix        = [string]::Empty
}

# Remove all extra spaces
while ($name.Contains("  "))
{
    $name = $name.Replace("  "," ")
}

$SpaceCount = ($name.split(' ')).count

$ContainsComma = $name.Contains(',')

if ($ContainsComma)
{
    switch ($name)
    {
        {$_ -match "^(\w{2,}), (\w{2,})$"}
            {
                $_ -match "^(\w{2,}), (\w{2,})$" | Out-Null
                $parsedName.FirstName      = $matches[2]
                $parsedName.LastName       = $matches[1]
                Break
            }
        {$_ -match "^(\w{2,}), (\w{2,}) (\w)$"}
            {
                $_ -match "^(\w{2,}), (\w{2,}) (\w)$" | Out-Null
                $parsedName.FirstName      = $matches[2]
                $parsedName.LastName       = $matches[1]
                $parsedName.MiddleInitial  = $matches[3]
                Break
            }
        {$_ -match "^(\w{2,}), (\w{2,}) (\w{2,})$"}
            {
                $_ -match "^(\w{2,}), (\w{2,}) (\w{2,})$" | Out-Null
                $parsedName.FirstName      = $matches[2]
                $parsedName.LastName       = $matches[1]
                $parsedName.MiddleName     = $matches[3]
                Break
            }
        {$_ -match "^(\w{2,}) (\w{2,3}), (\w{2,})$"}
            {
                $_ -match "^(\w{2,}) (\w{2,3}), (\w{2,})$" | Out-Null
                $parsedName.FirstName      = $matches[3]
                $parsedName.Suffix         = $matches[2]
                $parsedName.LastName       = $matches[1]
                Break
            }
        {$_ -match "^(\w{2,}) (\w{2,3}), (\w{2,}) (\w)$"}
            {
                $_ -match "^(\w{2,}) (\w{2,3}), (\w{2,}) (\w)$" | Out-Null
                $parsedName.FirstName      = $matches[3]
                $parsedName.Suffix         = $matches[2]
                $parsedName.LastName       = $matches[1]
                $parsedName.MiddleInitial  = $matches[4]
                Break
            }
        {$_ -match "^(\w{2,}) (\w{2,3}), (\w{2,}) (\w{2,})$"}
            {
                $_ -match "^(\w{2,}) (\w{2,3}), (\w{2,}) (\w{2,})$" | Out-Null
                $parsedName.FirstName      = $matches[3]
                $parsedName.Suffix         = $matches[2]
                $parsedName.LastName       = $matches[1]
                $parsedName.MiddleName     = $matches[4]
                Break
            }
        Default {}
    }
}
else
{
    switch ($name)
    {
        {$_ -match "^(\w{2,}) (\w{2,})$"}
            {
                $_ -match "^(\w{2,}) (\w{2,})$" | Out-Null
                $parsedName.FirstName      = $matches[1]
                $parsedName.LastName       = $matches[2]
                Break
            }
        {$_ -match "^(\w{2,}) (\w) (\w{2,})$"}
            {
                $_ -match "^(\w{2,}) (\w) (\w{2,})$" | Out-Null
                $parsedName.FirstName      = $matches[1]
                $parsedName.LastName       = $matches[3]
                $parsedName.MiddleInitial  = $matches[2]
                Break
            }
        {$_ -match "^(\w{2,}) (\w{2,}) (\w{2,})$"}
            {
                $_ -match "^(\w{2,}) (\w{2,}) (\w{2,})$" | Out-Null
                $parsedName.FirstName      = $matches[1]
                $parsedName.LastName       = $matches[3]
                $parsedName.MiddleName     = $matches[2]
                Break
            }
        {$_ -match "^(\w{2,}) (\w{2,}) (\w{2,3})$"}
            {
                $_ -match "^(\w{2,}) (\w{2,}) (\w{2,3})$" | Out-Null
                $parsedName.FirstName      = $matches[1]
                $parsedName.Suffix         = $matches[3]
                $parsedName.LastName       = $matches[2]
                Break
            }
        {$_ -match "^(\w{2,}) (\w) (\w{2,}) (\w{2,3})$"}
            {
                $_ -match "^(\w{2,}) (\w) (\w{2,}) (\w{2,3})$" | Out-Null
                $parsedName.FirstName      = $matches[1]
                $parsedName.Suffix         = $matches[4]
                $parsedName.LastName       = $matches[3]
                $parsedName.MiddleInitial  = $matches[2]
                Break
            }
        {$_ -match "^(\w{2,}) (\w{2,}) (\w{2,}) (\w{2,3})$"}
            {
                $_ -match "^(\w{2,}) (\w{2,}) (\w{2,}) (\w{2,3})$" | Out-Null
                $parsedName.FirstName      = $matches[1]
                $parsedName.Suffix         = $matches[4]
                $parsedName.LastName       = $matches[3]
                $parsedName.MiddleName     = $matches[2]
                Break
            }
        Default {}
    }
}

$parsedName |fl * -force

