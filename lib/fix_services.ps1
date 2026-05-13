$file = 'c:\Users\User\Desktop\OWN HOLIDAY\own_holiday_app\lib\modules\home\view\home_view.dart'
$allLines = [System.IO.File]::ReadAllLines($file, [System.Text.Encoding]::UTF8)

# Find line with offset: const Offset(0, -60)
for ($i = 0; $i -lt $allLines.Length; $i++) {
    if ($allLines[$i] -match "Offset\(0, -60\)") {
        Write-Host "Found at line $($i+1)"
        # Remove the Transform.translate entirely by replacing with just the Padding
        # But that's complex - instead just set offset to 0 to eliminate the gap
        $allLines[$i] = '                offset: const Offset(0, 0),'
        Write-Host "Changed to: $($allLines[$i])"
    }
}

[System.IO.File]::WriteAllLines($file, $allLines, [System.Text.Encoding]::UTF8)
Write-Host "Done"
