Add-Type -AssemblyName System.Drawing

function Get-NonTransparentBounds($filePath) {
    $img = [System.Drawing.Bitmap]::FromFile($filePath)
    $minX = $img.Width
    $minY = $img.Height
    $maxX = 0
    $maxY = 0
    $hasPixel = $false

    for ($y = 0; $y -lt $img.Height; $y++) {
        for ($x = 0; $x -lt $img.Width; $x++) {
            $pixel = $img.GetPixel($x, $y)
            if ($pixel.A -gt 10) {
                $hasPixel = $true
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }
    $img.Dispose()
    if ($hasPixel) {
        $contentW = $maxX - $minX + 1
        $contentH = $maxY - $minY + 1
        return [PSCustomObject]@{
            File = $filePath
            ContentWidth = $contentW
            ContentHeight = $contentH
            Bounds = "$minX,$minY to $maxX,$maxY"
        }
    } else {
        return "No non-transparent pixels found in $filePath"
    }
}

Get-NonTransparentBounds "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher_foreground.png"
Get-NonTransparentBounds "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"
Get-NonTransparentBounds "assets\images\app_logo.png"
Get-NonTransparentBounds "assets\images\app_logo_dark.png"
Get-NonTransparentBounds "assets\images\app_logo_square.png"
