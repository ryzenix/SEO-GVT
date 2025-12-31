# PowerShell script to generate empty HTML files from 622.html to 691.html

$workspaceFolder = "f:\School & Work\SEO-GVT"

# Loop from 622 to 691
for ($i = 622; $i -le 691; $i++) {
    $fileName = "$i.html"
    $filePath = Join-Path -Path $workspaceFolder -ChildPath $fileName
    
    # Create empty file
    New-Item -Path $filePath -ItemType File -Force | Out-Null
    
    Write-Host "Created: $fileName"
}

Write-Host "`nDone! Generated files 622.html through 691.html"
