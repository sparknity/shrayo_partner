Add-Type -AssemblyName System.Drawing

function Describe-Image($path) {
    $img = [System.Drawing.Bitmap]::FromFile($path)
    Write-Output "Image: $path"
    Write-Output "Size: $($img.Width) x $($img.Height)"
    Write-Output "Pixel (0,0): $($img.GetPixel(0,0))"
    Write-Output "Pixel (Width/2, Height/2): $($img.GetPixel([int]($img.Width/2), [int]($img.Height/2)))"
    $img.Dispose()
    Write-Output ""
}

Describe-Image "assets\images\app_logo.png"
Describe-Image "assets\images\app_logo_card.png"
Describe-Image "assets\images\app_logo_dark.png"
Describe-Image "assets\images\app_logo_square.png"
