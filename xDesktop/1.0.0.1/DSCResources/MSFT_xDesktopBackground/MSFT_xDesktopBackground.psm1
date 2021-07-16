Import-Module $PSScriptRoot\..\Helper.psm1 -Verbose:$false

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory)] [ValidateSet('Present','Absent')]  [System.String] $Ensure,
        [Parameter(Mandatory)] [System.String] $path,
        [ValidateSet('Tile','Center','Stretch','NoChange','Fill','Span')] [System.String] $style
    )

    $returnValue = @{}

    # simple validation that the file exists.
    # we could possibly grab all the attributes of the bitmap?
    if (Test-Path -Path $Path) {
        $returnValue.Path=$path  
        $returnValue.Ensure = "Present"
    }
    else {
        $returnValue.Path=$path  
        $returnValue.Ensure ="Absent"
    }
    
    $returnValue 

}


function Set-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory)]   [ValidateSet('Present','Absent')]  [System.String] $Ensure,
        [Parameter(Mandatory)]   [System.String] $path,
        [ValidateSet('Tile','Center','Stretch','NoChange','Fill','Span')] [System.String] $style
    )

    if ($Ensure -eq 'Present')
    {
        Write-Verbose "Applying bitmap file $path to desktop background"
        Set-xDesktopBackgroundWindowsWallpaper @PSBoundParameters
        $isCompliant=$true
    }
    else {
        Write-Verbose "Removing bitmap file $path to ensure it is Absent"
        Set-xDesktopBackgroundWindowsWallpaper -Path '' -Style Center
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
        [Parameter(Mandatory=$true)]   [ValidateSet('Present','Absent')]  [System.String] $Ensure,
        [Parameter(Mandatory=$true)]   [System.String] $path,
        [Parameter(Mandatory=$true)]   [ValidateSet('Tile','Center','Stretch','NoChange','Fill','Span')] [System.String] $style
    )
    
<#      
        Switch ($Style) {
          'Tile'     {$IntStyle=0}
          'Center'   {$IntStyle=1}
          'Stretch'  {$IntStyle=2}
          'NoChange' {$IntStyle=3}
          'Fill'     {$IntStyle=4}
        }
#>
         $testResults=@()
         foreach($UserHive in Get-ChildItem -Path Registry::HKEY_USERS -EA SilentlyContinue) {
            $DesktopKeyPath = (Join-Path -Path $UserHive.PSPath -ChildPath 'Control Panel\Desktop')
            if (Test-Path -Path $DesktopKeyPath) {
                 Write-Verbose -Message "Key: $DesktopKeyPath"
                 $value=Get-ItemProperty -Path $DesktopKeyPath -Name 'WallPaper' -ErrorAction SilentlyContinue

                 If ($Value.Wallpaper -eq $Path) {
                      $testResults += $true
                    }
                    else {

                        $testResult += $false
                     }

                 switch ( $style )
                 {
                  'Stretch' {
                              $value1=get-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle' -ErrorAction SilentlyContinue
                              $value2=get-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'  -ErrorAction SilentlyContinue
                              if (($value1.WallpaperStyle -eq '2') -and ($value2.TileWallpaper -eq '0')) {
                                $testResults += $true
                              }
                              else {
                                $testResult += $false
                              }
                              break
                            }
                  'Center'  {
                              $value1=get-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle'  -ErrorAction SilentlyContinue
                              $value2=get-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'   -ErrorAction SilentlyContinue
                              if (($value1.WallpaperStyle -eq '1') -and ($value2.TileWallpaper -eq '0')) {
                               $testResults += $true
                              }
                              else {
                                $testResults += $false
                              }
                              break
                            }
                  'Tile'    {
                              $value1=get-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle'  -ErrorAction SilentlyContinue
                              $value2=get-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'   -ErrorAction SilentlyContinue
                              if (($value1.WallpaperStyle -eq '1') -and ($value2.TileWallpaper -eq '1')) {
                                $testResults += $true
                              }
                              else {
                                $testResults += $false
                              }
                              break
                            }
                  'Fill'    {
                              $value1=get-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle'  -ErrorAction SilentlyContinue
                              $value2=get-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'   -ErrorAction SilentlyContinue
                              if (($value1.WallpaperStyle -eq '10') -and ($value2.TileWallpaper -eq '0')) {
                                $testResults += $true
                            }
                            else {
                              $testResults += $false
                            }
                            break
                            }
                  'Span'    {
                              $value1=get-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle'  -ErrorAction SilentlyContinue
                              $value2=get-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'   -ErrorAction SilentlyContinue
                              if (($value1.WallpaperStyle -eq '22') -and ($value2.TileWallpaper -eq '0')) {
                                $testResults += $true
                            }
                            else {
                              $testResults += $false
                            }
                            break
                            }
                   'NoChange' {
                                $testResults += $true
                                break
                              }
                 }
            }
        }
        
        if ($testResults -contains $false) {
            $testResult = $false
        }
        else {
            $testResult = $true
        }

    $testResult
}
