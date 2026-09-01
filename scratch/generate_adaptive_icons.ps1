Add-Type -AssemblyName System.Drawing

$sourcePath = "C:\Users\paste\.gemini\antigravity-ide\brain\384762fe-3438-4254-bd6e-0a3cec6ecbcd\.user_uploaded\media_1788298517727.jpg"
$img = [System.Drawing.Bitmap]::FromFile($sourcePath)
$w = $img.Width
$h = $img.Height
Write-Host "Source Image Dimensions: $w x $h"

# Find non-black bounding box to trim black borders perfectly
$minX = $w; $maxX = 0; $minY = $h; $maxY = 0

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $c = $img.GetPixel($x, $y)
        $brightness = [Math]::Max($c.R, [Math]::Max($c.G, $c.B))
        if ($brightness -gt 15) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

Write-Host "Trimmed Logo Bounds: X: $minX..$maxX, Y: $minY..$maxY"
$trimW = $maxX - $minX + 1
$trimH = $maxY - $minY + 1
$trimRect = New-Object System.Drawing.Rectangle($minX, $minY, $trimW, $trimH)

# Create high-res transparent cropped logo
$trimmedTransparent = New-Object System.Drawing.Bitmap($trimW, $trimH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($y = 0; $y -lt $trimH; $y++) {
    for ($x = 0; $x -lt $trimW; $x++) {
        $c = $img.GetPixel($minX + $x, $minY + $y)
        $brightness = [Math]::Max($c.R, [Math]::Max($c.G, $c.B))
        if ($brightness -lt 10) {
            $trimmedTransparent.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } elseif ($brightness -lt 30) {
            $alpha = [int](($brightness - 10) / 20.0 * 255)
            $trimmedTransparent.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B))
        } else {
            $trimmedTransparent.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
        }
    }
}

# Save in-app asset
$assetsDir = "d:\spraknity\shreyo_partner\assets\images"
if (-not (Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir -Force
}
$trimmedTransparent.Save("$assetsDir\app_logo.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved trimmed transparent logo to $assetsDir\app_logo.png"

# Save square dark version with transparent padding
$squareSize = [Math]::Max($trimW, $trimH) + 40
$squareLogo = New-Object System.Drawing.Bitmap($squareSize, $squareSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gSquare = [System.Drawing.Graphics]::FromImage($squareLogo)
$gSquare.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gSquare.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$drawX = ($squareSize - $trimW) / 2
$drawY = ($squareSize - $trimH) / 2
$gSquare.DrawImage($trimmedTransparent, $drawX, $drawY, $trimW, $trimH)
$gSquare.Dispose()
$squareLogo.Save("$assetsDir\app_logo_square.png", [System.Drawing.Imaging.ImageFormat]::Png)

# ----------------------------------------------------
# Android Adaptive Icons Setup (108dp base)
# Adaptive foreground standard: 108x108 dp canvas.
# Safe zone is center 72dp (radius 36dp).
# ----------------------------------------------------
$adaptiveDensities = @{
    "mipmap-mdpi"    = @{ full = 108; legacy = 48 }
    "mipmap-hdpi"    = @{ full = 162; legacy = 72 }
    "mipmap-xhdpi"   = @{ full = 216; legacy = 96 }
    "mipmap-xxhdpi"  = @{ full = 324; legacy = 144 }
    "mipmap-xxxhdpi" = @{ full = 432; legacy = 192 }
}

foreach ($folder in $adaptiveDensities.Keys) {
    $info = $adaptiveDensities[$folder]
    $fullSize = $info.full
    $legacySize = $info.legacy
    $targetDir = "d:\spraknity\shreyo_partner\android\app\src\main\res\$folder"
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force
    }

    # 1. Create Adaptive Foreground (Transparent, logo inside center ~65% of fullSize)
    $fgBmp = New-Object System.Drawing.Bitmap($fullSize, $fullSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $gFg = [System.Drawing.Graphics]::FromImage($fgBmp)
    $gFg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gFg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gFg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    $fgLogoSize = [int]($fullSize * 0.64)
    # Maintain aspect ratio
    if ($trimW -gt $trimH) {
        $logoDrawW = $fgLogoSize
        $logoDrawH = [int]($fgLogoSize * ($trimH / $trimW))
    } else {
        $logoDrawH = $fgLogoSize
        $logoDrawW = [int]($fgLogoSize * ($trimW / $trimH))
    }
    $fgX = ($fullSize - $logoDrawW) / 2
    $fgY = ($fullSize - $logoDrawH) / 2
    $gFg.DrawImage($trimmedTransparent, $fgX, $fgY, $logoDrawW, $logoDrawH)
    $gFg.Dispose()
    $fgBmp.Save("$targetDir\ic_launcher_foreground.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $fgBmp.Dispose()

    # 2. Create Legacy / Round Icon with Black/Dark Background (fills legacySize)
    $legacyBmp = New-Object System.Drawing.Bitmap($legacySize, $legacySize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $gLeg = [System.Drawing.Graphics]::FromImage($legacyBmp)
    $gLeg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gLeg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gLeg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $gLeg.Clear([System.Drawing.Color]::FromArgb(255, 0, 0, 0))

    $legLogoSize = [int]($legacySize * 0.82)
    if ($trimW -gt $trimH) {
        $lW = $legLogoSize
        $lH = [int]($legLogoSize * ($trimH / $trimW))
    } else {
        $lH = $legLogoSize
        $lW = [int]($legLogoSize * ($trimW / $trimH))
    }
    $lX = ($legacySize - $lW) / 2
    $lY = ($legacySize - $lH) / 2
    $gLeg.DrawImage($trimmedTransparent, $lX, $lY, $lW, $lH)
    $gLeg.Dispose()
    $legacyBmp.Save("$targetDir\ic_launcher.png", [System.Drawing.Imaging.ImageFormat]::Png)

    # Round legacy icon
    $roundBmp = New-Object System.Drawing.Bitmap($legacySize, $legacySize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $gRound = [System.Drawing.Graphics]::FromImage($roundBmp)
    $gRound.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gRound.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gRound.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse(0, 0, $legacySize, $legacySize)
    $gRound.SetClip($path)
    $gRound.Clear([System.Drawing.Color]::FromArgb(255, 0, 0, 0))
    $gRound.DrawImage($trimmedTransparent, $lX, $lY, $lW, $lH)
    $gRound.Dispose()
    $path.Dispose()
    $roundBmp.Save("$targetDir\ic_launcher_round.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $roundBmp.Dispose()
    $legacyBmp.Dispose()

    Write-Host "Generated Adaptive & Legacy Icons for $folder"
}

$img.Dispose()
$trimmedTransparent.Dispose()
$squareLogo.Dispose()

Write-Host "Done generating all icons!"
