[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

Function Generate-PngOutput ($img_old_src, $img_new_src, $img_out_src)
{
    &"C:\Program Files\ImageMagick-7.0.7-Q16\magick.exe" compare -metric AE "$($img_old_src)" "$($img_new_src)" null: "$($img_out_src)"
}

Function Generate-GifOutput ($img_old_src, $img_new_src, $img_out_src)
{
    &"C:\Program Files\ImageMagick-7.0.7-Q16\magick.exe" convert -delay 100 "$($img_old_src)" "$($img_new_src)" -loop 0 "$($img_out_src)"
}

$sourcePath = "E:\dev\ImageComparison\output\baseline"
$targetPath = "E:\dev\ImageComparison\output\current"
$outputPath = "E:\dev\ImageComparison\output\results"
md -Force "$($outputPath)\Static"
md -Force "$($outputPath)\Dynamic"

dir "$($sourcePath)\*.png" -Recurse | % {
    Generate-PngOutput $_.FullName "$($targetPath)\$($_.Name)" "$($outputPath)\Static\$($_.Name).png"
    Generate-GifOutput $_.FullName "$($targetPath)\$($_.Name)" "$($outputPath)\Dynamic\$($_.Name).gif"
}

ii $outputPath