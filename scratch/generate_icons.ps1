Add-Type -AssemblyName System.Drawing

$sourcePath = "assets\images\app_logo.png"
if (-not (Test-Path $sourcePath)) {
    Write-Error "Source image not found: $sourcePath"
    exit 1
}

$sourceImg = [System.Drawing.Bitmap]::FromFile((Resolve-Path $sourcePath).Path)

# Function to draw centered logo on a canvas
function Create-AdaptiveForeground($canvasSize, $targetHeight, $outputPath) {
    $bmp = New-Object System.Drawing.Bitmap $canvasSize, $canvasSize, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $aspectRatio = $sourceImg.Width / $sourceImg.Height
    $targetWidth = [int]($targetHeight * $aspectRatio)
    $x = [int](($canvasSize - $targetWidth) / 2)
    $y = [int](($canvasSize - $targetHeight) / 2)

    $g.DrawImage($sourceImg, $x, $y, $targetWidth, $targetHeight)
    $g.Dispose()

    $dir = [System.IO.Path]::GetDirectoryName($outputPath)
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Created Adaptive Foreground: $outputPath ($canvasSize x $canvasSize, logo: $targetWidth x $targetHeight)"
}

function Create-LegacyIcon($size, $targetHeight, $outputPath, $isRound = $false) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    if ($isRound) {
        $g.Clear([System.Drawing.Color]::Transparent)
        $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0, 0, 0))
        $g.FillEllipse($brush, 0, 0, $size, $size)
        $brush.Dispose()
    } else {
        $g.Clear([System.Drawing.Color]::FromArgb(255, 0, 0, 0))
    }

    $aspectRatio = $sourceImg.Width / $sourceImg.Height
    $targetWidth = [int]($targetHeight * $aspectRatio)
    $x = [int](($size - $targetWidth) / 2)
    $y = [int](($size - $targetHeight) / 2)

    $g.DrawImage($sourceImg, $x, $y, $targetWidth, $targetHeight)
    $g.Dispose()

    $dir = [System.IO.Path]::GetDirectoryName($outputPath)
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Created Legacy Icon: $outputPath ($size x $size, logo: $targetWidth x $targetHeight)"
}

# 1. Android Adaptive Foreground Icons (108dp canvas)
# Sized at ~52.5dp height (~48.6% of canvas, perfectly occupying ~78-80% of visible 66dp safe zone without clipping)
$adaptiveSizes = @{
    "android\app\src\main\res\mipmap-mdpi\ic_launcher_foreground.png"    = @{ Canvas = 108; TargetH = 52 }
    "android\app\src\main\res\mipmap-hdpi\ic_launcher_foreground.png"    = @{ Canvas = 162; TargetH = 78 }
    "android\app\src\main\res\mipmap-xhdpi\ic_launcher_foreground.png"   = @{ Canvas = 216; TargetH = 105 }
    "android\app\src\main\res\mipmap-xxhdpi\ic_launcher_foreground.png"  = @{ Canvas = 324; TargetH = 158 }
    "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher_foreground.png" = @{ Canvas = 432; TargetH = 210 }
}

foreach ($path in $adaptiveSizes.Keys) {
    $cfg = $adaptiveSizes[$path]
    Create-AdaptiveForeground $cfg.Canvas $cfg.TargetH $path
}

# 2. Android Legacy Icons (ic_launcher.png and ic_launcher_round.png)
$legacySizes = @{
    "mdpi"    = @{ Size = 48;  TargetH = 35 }
    "hdpi"    = @{ Size = 72;  TargetH = 52 }
    "xhdpi"   = @{ Size = 96;  TargetH = 69 }
    "xxhdpi"  = @{ Size = 144; TargetH = 104 }
    "xxxhdpi" = @{ Size = 192; TargetH = 138 }
}

foreach ($density in $legacySizes.Keys) {
    $cfg = $legacySizes[$density]
    Create-LegacyIcon $cfg.Size $cfg.TargetH "android\app\src\main\res\mipmap-$density\ic_launcher.png" $false
    Create-LegacyIcon $cfg.Size $cfg.TargetH "android\app\src\main\res\mipmap-$density\ic_launcher_round.png" $true
}

# 3. iOS Icons
$iosSizes = @{
    "Icon-App-20x20@1x.png"       = 20
    "Icon-App-20x20@2x.png"       = 40
    "Icon-App-20x20@3x.png"       = 60
    "Icon-App-29x29@1x.png"       = 29
    "Icon-App-29x29@2x.png"       = 58
    "Icon-App-29x29@3x.png"       = 87
    "Icon-App-40x40@1x.png"       = 40
    "Icon-App-40x40@2x.png"       = 80
    "Icon-App-40x40@3x.png"       = 120
    "Icon-App-60x60@2x.png"       = 120
    "Icon-App-60x60@3x.png"       = 180
    "Icon-App-76x76@1x.png"       = 76
    "Icon-App-76x76@2x.png"       = 152
    "Icon-App-83.5x83.5@2x.png"   = 167
    "Icon-App-1024x1024@1x.png"   = 1024
}

foreach ($name in $iosSizes.Keys) {
    $size = $iosSizes[$name]
    $targetH = [int]($size * 0.72)
    Create-LegacyIcon $size $targetH "ios\Runner\Assets.xcassets\AppIcon.appiconset\$name" $false
}

$sourceImg.Dispose()
Write-Output "All icons re-generated with optimal size!"
