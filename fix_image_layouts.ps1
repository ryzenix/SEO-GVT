# PowerShell script to fix image layouts in HTML files
# Converts images with captions to use <figure> and <figcaption> elements

$workspaceFolder = "f:\School & Work\SEO-GVT"
$htmlFiles = Get-ChildItem -Path $workspaceFolder -Filter "*.html" | Where-Object { $_.Name -match "^[0-9]{3}\.html$" }

foreach ($file in $htmlFiles) {
    $filePath = $file.FullName
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Pattern 1: <div style="text-align: justify;"><img ... /> <em>caption</em></div>
    $pattern1 = '<div style="text-align: justify;"><img\s+([^>]*?)\s*/>\s*<em>([^<]*)</em></div>'
    $replacement1 = '<div style="text-align: center;">' + "`n" + '<figure>' + "`n" + '<img $1/>' + "`n" + '<figcaption><em>$2</em></figcaption>' + "`n" + '</figure>' + "`n" + '</div>'
    $content = [regex]::Replace($content, $pattern1, $replacement1)
    
    # Pattern 2: <div style="text-align: center;"><img ... /></div> (images without captions - add empty div)
    # This pattern will just center the image if there's no caption
    
    # Pattern 3: Images in <p> tags with justify
    $pattern3 = '<p[^>]*style="text-align: center;"[^>]*>\s*<img\s+([^>]*?)\s*/>\s*</p>'
    $replacement3 = '<div style="text-align: center;">' + "`n" + '<figure>' + "`n" + '<img $1/>' + "`n" + '</figure>' + "`n" + '</div>'
    $content = [regex]::Replace($content, $pattern3, $replacement3)
    
    if ($content -ne $originalContent) {
        Set-Content -Path $filePath -Value $content -Encoding UTF8
        Write-Host "Fixed: $($file.Name)"
    } else {
        Write-Host "No changes needed: $($file.Name)"
    }
}

Write-Host "`nLayout fixes completed!"
