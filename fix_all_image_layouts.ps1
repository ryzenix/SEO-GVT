# PowerShell script to comprehensively fix all image layouts in HTML files
# This script will ensure all images in center divs are wrapped in proper <figure> elements

$workspaceFolder = "f:\School & Work\SEO-GVT"
$htmlFiles = Get-ChildItem -Path $workspaceFolder -Filter "*.html" | Where-Object { $_.Name -match "^[0-9]{3}\.html$" }

function Fix-ImageLayouts {
    param(
        [string]$filePath
    )
    
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Fix 1: Images wrapped in span inside center divs (most common pattern in these files)
    # <div style="text-align: center;"><span><span><img ... /></span></span></div>
    $pattern1 = '<div style="text-align: center;"><span><span><img\s+([^>]*?)\s*/></span></span></div>'
    $replacement1 = '<div style="text-align: center;">' + "`n<figure>" + "`n" + '<img $1/>' + "`n" + '</figure>' + "`n" + '</div>'
    $content = [regex]::Replace($content, $pattern1, $replacement1, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    
    # Fix 2: Images with justify text containing <em> captions
    $pattern2 = '<div style="text-align: justify;"><img\s+([^>]*?)\s*/>\s*<em>([^<]+)</em></div>'
    $replacement2 = '<div style="text-align: center;">' + "`n<figure>" + "`n" + '<img $1/>' + "`n" + '<figcaption><em>$2</em></figcaption>' + "`n" + '</figure>' + "`n" + '</div>'
    $content = [regex]::Replace($content, $pattern2, $replacement2, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    
    return $content
}

foreach ($file in $htmlFiles) {
    $filePath = $file.FullName
    $fixedContent = Fix-ImageLayouts -filePath $filePath
    $originalContent = Get-Content -Path $filePath -Raw -Encoding UTF8
    
    if ($fixedContent -ne $originalContent) {
        Set-Content -Path $filePath -Value $fixedContent -Encoding UTF8
        Write-Host "Fixed: $($file.Name)"
    }
}

Write-Host "`nAll image layouts have been processed!"
