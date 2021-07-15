configuration SetTheDesktopBitmap
{
 PARAM ([string] $path='c:\windows\web\wallpaper\windows\AEMO.bmp', 
        [string] $text)

 Import-DscResource -ModuleName xDesktop

 Node localhost {
 
    #create a custom BMP file with the servername 

    xDesktopBMPFile MYBITMAP {
     Ensure='Present'
     Text = $text
     Path = $path
     FontSize = 10
     Height = 61
     Width = 270
     BGcolour = 'Teal'
     FGcolour = 'White'
    }
 
    # apply the specified bitmap to the desktop

    xDesktopBackground MYDESKTOP {
     Ensure='Present'
     Path = $path
     Style = 'Tile'
     DependsOn = '[xDesktopBMPFile]MYBITMAP'
    }

 }

}


#SetTheDesktopBitmap
#Start-DscConfiguration .\SetTheDesktopBitmap -Wait -Verbose
