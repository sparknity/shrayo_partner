Add-Type -AssemblyName System.Drawing

$sourcePath = "C:\Users\paste\.gemini\antigravity-ide\brain\384762fe-3438-4254-bd6e-0a3cec6ecbcd\.user_uploaded\media_1788297559349.jpg"
$img = [System.Drawing.Bitmap]::FromFile($sourcePath)

$w = $img.Width
$h = $img.Height
Write-Host "Original Image Size: $w x $h"

# Card bounding box in screenshot (540x1200 or similar):
$cropX = [int]($w * 0.36)
$cropY = [int]($h * 0.12)
$cropW = [int]($w * 0.28)
$cropH = [int]($h * 0.126)

$rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$croppedCard = $img.Clone($rect, $img.PixelFormat)

# Make sure assets directory exists
$assetsDir = "d:\spraknity\shreyo_partner\assets\images"
if (-not (Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir -Force
}

$croppedCard.Save("$assetsDir\app_logo_card.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved app_logo_card.png"

# Inner logo crop (just the blue heart + person + star icon with clean padding)
$innerX = [int]($w * 0.425)
$innerY = [int]($h * 0.147)
$innerW = [int]($w * 0.15)
$innerH = [int]($h * 0.072)

$innerRect = New-Object System.Drawing.Rectangle($innerX, $innerY, $innerW, $innerH)
$innerLogo = $img.Clone($innerRect, $img.PixelFormat)
$innerLogo.Save("$assetsDir\app_logo.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved app_logo.png"

# Now let's generate app launcher icons for android mipmaps
$mipmapSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($folder in $mipmapSizes.Keys) {
    $size = $mipmapSizes[$folder]
    $destBitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($destBitmap)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    # Draw the card resized into destBitmap
    $destRect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
    $graphics.DrawImage($croppedCard, $destRect)
    $graphics.Dispose()

    $targetDir = "d:\spraknity\shreyo_partner\android\app\src\main\res\$folder"
    if (Test-Path $targetDir) {
        $destBitmap.Save("$targetDir\ic_launcher.png", [System.Drawing.Imaging.ImageFormat]::Png)
        Write-Host "Saved $targetDir\ic_launcher.png ($size x $size)"
    }
    $destBitmap.Dispose()
}

$img.Dispose()
$croppedCard.Dispose()
$innerLogo.Dispose()
Write-Host "Done generating logo and launcher icons!"
