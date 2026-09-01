Add-Type -AssemblyName System.Drawing

$sourcePath = "C:\Users\paste\.gemini\antigravity-ide\brain\384762fe-3438-4254-bd6e-0a3cec6ecbcd\.user_uploaded\media_1788298517727.jpg"
$img = [System.Drawing.Bitmap]::FromFile($sourcePath)
$w = $img.Width
$h = $img.Height
Write-Host "Source Image Dimensions: $w x $h"

# 1. Create transparent logo
$transparentBmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $c = $img.GetPixel($x, $y)
        $brightness = [Math]::Max($c.R, [Math]::Max($c.G, $c.B))
        
        if ($brightness -lt 12) {
            # Completely black background -> transparent
            $transparentBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } elseif ($brightness -lt 35) {
            # Edge feathering
            $alpha = [int](($brightness - 12) / 23.0 * 255)
            $transparentBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B))
        } else {
            $transparentBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
        }
    }
}

$assetsDir = "d:\spraknity\shreyo_partner\assets\images"
if (-not (Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir -Force
}

$transparentBmp.Save("$assetsDir\app_logo.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved $assetsDir\app_logo.png"

# 2. Save original high-res square
$img.Save("$assetsDir\app_logo_dark.png", [System.Drawing.Imaging.ImageFormat]::Png)

# 3. Create a rounded icon with white/subtle background for launcher
$launcherMaster = New-Object System.Drawing.Bitmap(512, 512, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($launcherMaster)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Background fill (Deep Dark Navy or Clean White / Gradient)
# Using dark sleek background matching the logo's native design with subtle rounded gradient
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Rectangle(0, 0, 512, 512)),
    [System.Drawing.Color]::FromArgb(255, 10, 15, 30),
    [System.Drawing.Color]::FromArgb(255, 2, 6, 18),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$g.FillRectangle($brush, 0, 0, 512, 512)

# Draw the logo centered
$destRect = New-Object System.Drawing.Rectangle(32, 32, 448, 448)
$g.DrawImage($transparentBmp, $destRect)
$g.Dispose()
$brush.Dispose()

$launcherMaster.Save("$assetsDir\app_logo_card.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved $assetsDir\app_logo_card.png"

# 4. Generate Android mipmap launcher icons
$mipmapSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($folder in $mipmapSizes.Keys) {
    $size = $mipmapSizes[$folder]
    $iconBmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $gIcon = [System.Drawing.Graphics]::FromImage($iconBmp)
    $gIcon.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gIcon.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gIcon.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    # Draw scaled master launcher icon
    $gIcon.DrawImage($launcherMaster, (New-Object System.Drawing.Rectangle(0, 0, $size, $size)))
    $gIcon.Dispose()

    $targetDir = "d:\spraknity\shreyo_partner\android\app\src\main\res\$folder"
    if (Test-Path $targetDir) {
        $iconBmp.Save("$targetDir\ic_launcher.png", [System.Drawing.Imaging.ImageFormat]::Png)
        Write-Host "Updated $targetDir\ic_launcher.png ($size x $size)"
    }
    $iconBmp.Dispose()
}

$img.Dispose()
$transparentBmp.Dispose()
$launcherMaster.Dispose()
Write-Host "All assets processed and updated successfully!"
