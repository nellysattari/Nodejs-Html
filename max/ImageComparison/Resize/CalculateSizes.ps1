[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

Function Get-Image ($filename)
{
    $file = (get-item $filename)
    return [System.Drawing.Image]::Fromfile($file);
}

Function Extend-Image ($img_src, $newheight, $newwidth)
{
	"Changing $($img_src) to new height $($newheight) and width $($newwidth)"
    &"C:\Program Files\ImageMagick-7.0.7-Q16\magick.exe" convert "$($img_src)" -gravity NorthWest -extent "$($newwidth)x$($newheight)" "$($img_src)"
}

$sourcePath = "E:\dev\ImageComparison\output\baseline\"
$targetPath = "E:\dev\ImageComparison\output\current\"
$filesToCrop = New-Object System.Collections.ArrayList
$filesToExtend = New-Object System.Collections.ArrayList

dir "$($sourcePath)*.png" -Recurse | % {

   $oldImg = Get-Image $_.FullName 
   $newImg = Get-Image "$($targetPath)$($_.Name)"

	"$($_.FullName) - $($targetPath)$($_.Name) - $($oldImg.Height) vs $($newImg.Height)"
	
	$fileToChange = @{
		NewHeight = $oldImg.Height
		NewWidth = $newImg.Width
		ImagePath = "$($targetPath)$($_.Name)"
	}
	#$outputObj = New-Object –TypeName PSObject –Prop $fileToChange
	
    if ($oldImg.Height -lt $newImg.Height)
    {
        $filesToCrop += $fileToChange
        #Write-Output "File to be croped $($outputObj)"
    }
    elseif ($oldImg.Height -gt $newImg.Height)
    {
        $filesToExtend += $fileToChange
        #Write-Output "File to be extended $($outputObj)"
    }
    $oldImg.Dispose()
    $newImg.Dispose()
}

$filesToCrop |foreach {
	$_
	Extend-Image $_.ImagePath $_.NewHeight $_.NewWidth
}

$filesToExtend |foreach {
	Extend-Image $_.ImagePath $_.NewHeight $_.NewWidth
}
