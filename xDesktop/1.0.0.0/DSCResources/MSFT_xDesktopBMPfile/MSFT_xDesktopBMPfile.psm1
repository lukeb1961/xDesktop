Import-Module $PSScriptRoot\..\Helper.psm1 -Verbose:$false

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [ValidateSet('Present','Absent')]
        [System.String] $Ensure,
        [Parameter(Mandatory)]
        [System.String] $Path,
        [System.String] $Text,
        [uint32] $FontSize,
        [uint32] $Height,
        [uint32] $Width,
        [String] $BGcolour,
        [String] $FGcolour
    )
    Add-Type -AssemblyName System.Drawing
    $returnValue = @{}

    if (Test-Path -Path $Path) {
        $returnValue.Path=$path  
        $returnValue.Ensure = "Present"
        write-verbose "get the bitmap size of $path"
        $image=[System.Drawing.Image]::FromFile($path)
        $returnValue.Width = $image.Width
        $returnValue.Height = $image.Height
    }
    else {
        $returnValue.Path=$path  
        $returnValue.Ensure="Absent"
    }
    
    $returnValue 
}



function Set-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [ValidateSet('Present','Absent')]
        [System.String] $Ensure,
        [Parameter(Mandatory)]
        [System.String] $Path,
        [System.String] $Text,
        [uint32] $FontSize,
        [uint32] $Height,
        [uint32] $Width,
        [String] $BGcolour,
        [String] $FGcolour
    )

    if ($Text.Length -eq 0) {$Text=$ENV:COMPUTERNAME}

    if ($Ensure -eq 'Present')
    {
      Write-Verbose "Creating bitmap file $path to ensure it is Present."
      Write-Verbose "Containing text $Text on the bitmap."
      if (New-xDesktopBMPfileWithText @PSBoundParameters) {
        $isCompliant=$true
      }
      else {
        $isCompliant=$false
      } 
    }
    else {
        Write-Verbose "Removing bitmap file $path to ensure it is Absent"
        Remove-Item -Path $path -Force
        $isCompliant=$true
    }

    return $isCompliant
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [ValidateSet('Present','Absent')]
        [System.String] $Ensure,
        [Parameter(Mandatory)]
        [System.String] $Path,
        [System.String] $Text,
        [uint32] $FontSize,
        [uint32] $Height,
        [uint32] $Width,
        [String] $BGcolour,
        [String] $FGcolour
    )

    
    $BMPfile = Get-TargetResource -Path $Path -ErrorAction SilentlyContinue -ErrorVariable ev

    if ($Ensure -ne "Absent")                    # Present
    {
        if ($BMPfile.Ensure -eq "Absent")
        {
            $testResult = $false
        }
        elseif ($BMPfile.Ensure -eq "Present")
        {
            $testResult = $true
            if ($PSboundparameters.Height) {
                if ($BMPfile.Height -ne $Height)
                {
                    $testResult = $false
                }
            }
            if ($PSboundparameters.Width) {
                if ($BMPfile.Width -ne $Width)
                {
                    $testResult = $false
                }
            }
        }
    }
    else {                                     # Absent
        if ($BMPfile.Ensure -eq "Absent")
        {
            $testResult = $true
        }
        else
        {
            $testResult = $false
        }
    }

    $testResult
}