Add-Type -AssemblyName System.Drawing
Get-ChildItem -Path "assets\images\*.png" | ForEach-Object {
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    Write-Output "$($_.Name): $($img.Width)x$($img.Height)"
    $img.Dispose()
}

Write-Output "--- Android Mipmap Foreground Images ---"
Get-ChildItem -Path "android\app\src\main\res\mipmap-*\*.png" | ForEach-Object {
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    Write-Output "$($_.Directory.Name)/$($_.Name): $($img.Width)x$($img.Height)"
    $img.Dispose()
}
