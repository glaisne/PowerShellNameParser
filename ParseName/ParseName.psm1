<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Parse-Name
{
    [CmdletBinding()]
    [OutputType([psobject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]] $name
    )

<#
Possible patterns:
    First Last
    First Last Suffix
    First Mi Last
    First Mi. Last
    First Mi Last Suffix
    First Mi. Last Suffix
    First Middle Last
    First Middle Last Suffix

    Last, First
    Last, First Mi
    Last, First Middle
    Last Suffix, First
    Last Suffix, First Mi
    Last Suffix, First Mi.
    Last Suffix, First Middle
#>

    Begin
    {
    }

    Process
    {

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
                # Last, First
                {$_ -match "^(\w{2,}), (\w{2,})$"}
                    {
                        $_ -match "^(\w{2,}), (\w{2,})$" | Out-Null
                        $parsedName.LastName       = $matches[1]
                        $parsedName.FirstName      = $matches[2]
                        Break
                    }

                # Last, first Mi
                {$_ -match "^(\w{2,}), (\w{2,}) (\w)\.?$"}
                    {
                        $_ -match "^(\w{2,}), (\w{2,}) (\w)\.?$" | Out-Null
                        $parsedName.LastName       = $matches[1]
                        $parsedName.FirstName      = $matches[2]
                        $parsedName.MiddleInitial  = $matches[3]
                        Break
                    }

                # Last, First Middle
                {$_ -match "^(\w{2,}), (\w{2,}) (\w{2,})$"}
                    {
                        $_ -match "^(\w{2,}), (\w{2,}) (\w{2,})$" | Out-Null
                        $parsedName.LastName       = $matches[1]
                        $parsedName.FirstName      = $matches[2]
                        $parsedName.MiddleName     = $matches[3]
                        Break
                    }

                # Last Suffix, First
                {$_ -match "^(\w{2,}) (jr|sr|[IV]{3}), (\w{2,})$"}
                    {
                        $_ -match "^(\w{2,}) (\w{2,3}), (\w{2,})$" | Out-Null
                        $parsedName.LastName       = $matches[1]
                        $parsedName.Suffix         = $matches[2]
                        $parsedName.FirstName      = $matches[3]
                        Break
                    }

                # Last Suffix, First Mi
                {$_ -match "^(\w{2,}) (jr|sr|[IV]{3}), (\w{2,}) (\w)\.?$"}
                    {
                        $_ -match "^(\w{2,}) (jr|sr|[IV]{3}), (\w{2,}) (\w)\.?$" | Out-Null
                        $parsedName.LastName       = $matches[1]
                        $parsedName.Suffix         = $matches[2]
                        $parsedName.FirstName      = $matches[3]
                        $parsedName.MiddleInitial  = $matches[4]
                        Break
                    }

                # Last Suffix, First Middle
                {$_ -match "^(\w{2,}) (jr|sr|[IV]{3}), (\w{2,}) (\w{2,})$"}
                    {
                        $_ -match "^(\w{2,}) (jr|sr|[IV]{3}), (\w{2,}) (\w{2,})$" | Out-Null
                        $parsedName.LastName       = $matches[1]
                        $parsedName.Suffix         = $matches[2]
                        $parsedName.FirstName      = $matches[3]
                        $parsedName.MiddleName     = $matches[4]
                        Break
                    }
                Default {
                    Write-Error "Was unable to match patter for name $name"
                }
            }
        }
        else
        {
            switch ($name)
            {
                # First Last
                {$_ -match "^(\w{2,}) (\w{2,})$"}
                    {
                        $_ -match "^(\w{2,}) (\w{2,})$" | Out-Null
                        $parsedName.FirstName      = $matches[1]
                        $parsedName.LastName       = $matches[2]
                        Break
                    }

                # First Mi Last
                {$_ -match "^(\w{2,}) (\w)\.? (\w{2,})$"}
                    {
                        $_ -match "^(\w{2,}) (\w)\.? (\w{2,})$" | Out-Null
                        $parsedName.FirstName      = $matches[1]
                        $parsedName.MiddleInitial  = $matches[2]
                        $parsedName.LastName       = $matches[3]
                        Break
                    }

                # First Middle Last
                {$_ -match "^(\w{2,}) (\w{2,}) (\w{2,})$"}
                    {
                        $_ -match "^(\w{2,}) (\w{2,}) (\w{2,})$" | Out-Null
                        $parsedName.FirstName      = $matches[1]
                        $parsedName.MiddleName     = $matches[2]
                        $parsedName.LastName       = $matches[3]
                        Break
                    }

                # First Last Suffix
                {$_ -match "^(\w{2,}) (\w{2,}) (jr|sr|[IV]{3})$"}
                    {
                        $_ -match "^(\w{2,}) (\w{2,}) (jr|sr|[IV]{3})$" | Out-Null
                        $parsedName.FirstName      = $matches[1]
                        $parsedName.LastName       = $matches[2]
                        $parsedName.Suffix         = $matches[3]
                        Break
                    }

                # First Mi Last Suffix
                {$_ -match "^(\w{2,}) (\w)\.? (\w{2,}) (jr|sr|[IV]{3})$"}
                    {
                        $_ -match "^(\w{2,}) (\w)\.? (\w{2,}) (jr|sr|[IV]{3})$" | Out-Null
                        $parsedName.FirstName      = $matches[1]
                        $parsedName.MiddleInitial  = $matches[2]
                        $parsedName.LastName       = $matches[3]
                        $parsedName.Suffix         = $matches[4]
                        Break
                    }

                # First Middle Last Suffix
                {$_ -match "^(\w{2,}) (\w{2,}) (\w{2,}) (jr|sr|[IV]{3})$"}
                    {
                        $_ -match "^(\w{2,}) (\w{2,}) (\w{2,}) (jr|sr|[IV]{3})$" | Out-Null
                        $parsedName.FirstName      = $matches[1]
                        $parsedName.MiddleName     = $matches[2]
                        $parsedName.LastName       = $matches[3]
                        $parsedName.Suffix         = $matches[4]
                        Break
                    }
                Default {
                    Write-Error "Was unable to match patter for name $name"
                }
            }
        }

        Write-Output $parsedName

    }

    End
    {
    }
}