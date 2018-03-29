Function New-xDesktopBMPfileWithText {
    [cmdletbinding(PositionalBinding=$false)]
    PARAM ([string] $ensure,
           [Parameter(Mandatory=$true)] [string] $path,
           [Parameter(Mandatory=$false)] [string] $text=$ENV:COMPUTERNAME,
           [Parameter(Mandatory=$true)] 
           [ValidateSet('AliceBlue','AntiqueWhite','Aqua','Aquamarine','Azure','Beige','Bisque','Black','BlanchedAlmond','Blue','BlueViolet','Brown','BurlyWood','CadetBlue','Chartreuse','Chocolate','Coral','CornflowerBlue','Cornsilk','Crimson','Cyan','DarkBlue','DarkCyan','DarkGoldenrod','DarkGray','DarkGreen','DarkKhaki','DarkMagenta','DarkOliveGreen','DarkOrange','DarkOrchid','DarkRed','DarkSalmon','DarkSeaGreen','DarkSlateBlue','DarkSlateGray','DarkTurquoise','DarkViolet','DeepPink','DeepSkyBlue','DimGray','DodgerBlue','Firebrick','FloralWhite','ForestGreen','Fuchsia','G','Gainsboro','GhostWhite','Gold','Goldenrod','Gray','Green','GreenYellow','Honeydew','HotPink','IndianRed','Indigo','IsEmpty','IsKnownColor','IsNamedColor','IsSystemColor','Ivory','Khaki','Lavender','LavenderBlush','LawnGreen','LemonChiffon','LightBlue','LightCoral','LightCyan','LightGoldenrodYellow','LightGray','LightGreen','LightPink','LightSalmon','LightSeaGreen','LightSkyBlue','LightSlateGray','LightSteelBlue','LightYellow','Lime','LimeGreen','Linen','Magenta','Maroon','MediumAquamarine','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumSpringGreen','MediumTurquoise','MediumVioletRed','MidnightBlue','MintCream','MistyRose','Moccasin','Name','NavajoWhite','Navy','OldLace','Olive','OliveDrab','Orange','OrangeRed','Orchid','PaleGoldenrod','PaleGreen','PaleTurquoise','PaleVioletRed','PapayaWhip','PeachPuff','Peru','Pink','Plum','PowderBlue','Purple','R','Red','RosyBrown','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','Silver','SkyBlue','SlateBlue','SlateGray','Snow','SpringGreen','SteelBlue','Tan','Teal','Thistle','Tomato','Transparent','Turquoise','Violet','Wheat','White','WhiteSmoke','Yellow','YellowGreen')]
           [alias('bgColor')] [string] $bgColour,
           [Parameter(Mandatory=$true)]
           [ValidateSet('AliceBlue','AntiqueWhite','Aqua','Aquamarine','Azure','Beige','Bisque','Black','BlanchedAlmond','Blue','BlueViolet','Brown','BurlyWood','CadetBlue','Chartreuse','Chocolate','Coral','CornflowerBlue','Cornsilk','Crimson','Cyan','DarkBlue','DarkCyan','DarkGoldenrod','DarkGray','DarkGreen','DarkKhaki','DarkMagenta','DarkOliveGreen','DarkOrange','DarkOrchid','DarkRed','DarkSalmon','DarkSeaGreen','DarkSlateBlue','DarkSlateGray','DarkTurquoise','DarkViolet','DeepPink','DeepSkyBlue','DimGray','DodgerBlue','Firebrick','FloralWhite','ForestGreen','Fuchsia','G','Gainsboro','GhostWhite','Gold','Goldenrod','Gray','Green','GreenYellow','Honeydew','HotPink','IndianRed','Indigo','IsEmpty','IsKnownColor','IsNamedColor','IsSystemColor','Ivory','Khaki','Lavender','LavenderBlush','LawnGreen','LemonChiffon','LightBlue','LightCoral','LightCyan','LightGoldenrodYellow','LightGray','LightGreen','LightPink','LightSalmon','LightSeaGreen','LightSkyBlue','LightSlateGray','LightSteelBlue','LightYellow','Lime','LimeGreen','Linen','Magenta','Maroon','MediumAquamarine','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumSpringGreen','MediumTurquoise','MediumVioletRed','MidnightBlue','MintCream','MistyRose','Moccasin','Name','NavajoWhite','Navy','OldLace','Olive','OliveDrab','Orange','OrangeRed','Orchid','PaleGoldenrod','PaleGreen','PaleTurquoise','PaleVioletRed','PapayaWhip','PeachPuff','Peru','Pink','Plum','PowderBlue','Purple','R','Red','RosyBrown','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','Silver','SkyBlue','SlateBlue','SlateGray','Snow','SpringGreen','SteelBlue','Tan','Teal','Thistle','Tomato','Transparent','Turquoise','Violet','Wheat','White','WhiteSmoke','Yellow','YellowGreen')]
           [alias('fgColor')] [String] $fgColour,
           [Parameter(Mandatory=$false)] [int] $width=270,
           [Parameter(Mandatory=$false)] [int] $height=61,
           [Parameter(Mandatory=$false)] [int] $fontSize=10
          )
          
    Add-Type -AssemblyName System.Drawing
  
    if ($text.Length -eq 0) {$text=$ENV:COMPUTERNAME}

    $bmp  = new-object -TypeName System.Drawing.Bitmap  -Argumentlist ($Width, $Height)
    $font = new-object -TypeName System.Drawing.Font    -Argumentlist ('Consolas',$fontSize)
  
    $bgBrushColour=[system.drawing.color]::FromName($bgcolour)
    $fgBrushColour=[system.drawing.color]::FromName($fgcolour)
    
    $bg = New-Object -TypeName Drawing.SolidBrush -ArgumentList ($bgBrushColour)
    $fg = New-Object -TypeName Drawing.SolidBrush -ArgumentList ($fgBrushColour)
  
    $graphics = [System.Drawing.Graphics]::FromImage($bmp) 
    $x=$y=0
    $graphics.FillRectangle($bg,$x,$y,$bmp.Width,$bmp.Height) 
    $x=$y=10
    $graphics.DrawString($text,$font,$fg,$x,$y) 
    $graphics.Dispose() 
  
    if (Test-Path -Path $path) { Remove-Item -Path $path }
    $bmp.Save($path) 
  
    Get-Item -Path $path -ErrorAction SilentlyContinue
  
  }
  
function Set-xDesktopBackgroundWindowsWallpaper {
  [CmdletBinding()] 
  PARAM([string] $ensure,
        [Parameter(Mandatory=$true)] [string] $Path,
        [ValidateSet('Tile','Center','Stretch','NoChange')]  [string] $style
       )

  Switch ($Style) {
    'Tile'     {$IntStyle=0}
    'Center'   {$IntStyle=1}
    'Stretch'  {$IntStyle=2}
    'NoChange' {$IntStyle=3}
  }


   foreach($UserHive in Get-ChildItem -Path Registry::HKEY_USERS) {
      $DesktopKeyPath = (Join-Path -Path $UserHive.PSPath -ChildPath 'Control Panel\Desktop')
       if (Test-Path -Path $DesktopKeyPath) {
           Write-Verbose -Message "Key: $DesktopKeyPath"
           Set-ItemProperty -Path $DesktopKeyPath -Name 'WallPaper' -Value $Path -Force
           switch( $style )
           {
            'Stretch' {
                       Set-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle' -Value '2' -Force
                       Set-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'  -Value '0' -Force
                       break
                      } 
            'Center'  {
                       Set-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle' -Value '1' -Force
                       Set-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'  -Value '0' -Force
                       break
             }
            'Tile'   {
                      Set-ItemProperty -Path $DesktopKeyPath -Name 'WallpaperStyle' -Value '1' -Force
                      Set-ItemProperty -Path $DesktopKeyPath -Name 'TileWallpaper'  -Value '1' -Force
                      break
             }
             'NoChange' {  break  }
           }
        }
      }
 
    & "$env:windir\system32\rundll32.exe" user32.dll, UpdatePerUserSystemParameters
}