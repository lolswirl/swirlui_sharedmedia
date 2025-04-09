# UpdateMedia.ps1

# Function to remove leading and trailing spaces
function Trim {
  param (
    [string]$str
  )
  return $str.Trim()
}

$jsonPath = "iconLinks.json"
$jsonContent = Get-Content $jsonPath -Raw | ConvertFrom-Json

# Convert PSCustomObject to Hashtable, using the short name as the value
$nameToIconMap = @{}
foreach ($shortName in $jsonContent.ids.PSObject.Properties) {
    $nameToIconMap[$shortName.Name] = $shortName.Value
}

# Set the current directory and folder name
$currentDir = Get-Location
$folderName = Split-Path -Leaf $currentDir

# Set the tocFile path
$tocFile = "..\$folderName\$folderName.toc"
$wagoID = ""

# Check if the tocFile exists
if (Test-Path $tocFile) {
  $wagoID = Select-String -Path $tocFile -Pattern "^## X-Wago-ID: " | ForEach-Object {
    $_.Line -replace "^## X-Wago-ID: ", ""
  }
  $wagoID = Trim -str $wagoID
}
else {
  while ($true) {
    $wagoID = Read-Host "Enter Wago Project ID (you can copy and paste it here and press Enter)"

    if (-not $wagoID) {
      Write-Host "Wago Project ID cannot be empty. Please try again."
      continue
    }

    $wagoID = Trim -str $wagoID

    if ($wagoID.Length -lt 6) {
      Write-Host "Error: wagoID must be at least 6 characters long."
      continue
    }

    break
  }

  # Create necessary directories if they do not exist
  $directories = @("background", "border", "font", "sound", "statusbar")
  foreach ($dir in $directories) {
    $path = "..\$folderName\$dir"
    if (-not (Test-Path $path)) {
      New-Item -Path $path -ItemType Directory | Out-Null
    }
  }

  # Create the tocFile and add content
  $tocContent = @(
    "## Interface: 11506, 40402, 110100",
    "## Title: $folderName",
    "## X-Wago-ID: $wagoID",
    "SharedMedia_SwirlUI.lua",
    "libs\LibStub\LibStub.lua",
    "libs\CallbackHandler-1.0\CallbackHandler-1.0.lua",
    "libs\LibSharedMedia-3.0\LibSharedMedia-3.0.lua"
  )
  $tocContent | Out-File -FilePath $tocFile -Encoding UTF8

  Write-Host "AddOn created. Add your media files to the appropriate folders."
  Write-Host "Run this script again to register the media files and create a zip file."
}

# Create SharedMedia_SwirlUI.lua file
$myMediaFile = "..\$folderName\SharedMedia_SwirlUI.lua"
$myMediaContent = @(
  'local LSM = LibStub("LibSharedMedia-3.0")',
  '',
  '-- -----',
  '-- BACKGROUND',
  '-- -----'
)

# Add background files
$backgroundFiles = Get-ChildItem -Path "..\$folderName\background\*.*"
foreach ($file in $backgroundFiles) {
  $myMediaContent += "LSM:Register('background', '$($file.BaseName)', [[Interface\Addons\$folderName\background\$($file.Name)]])"
}

# Add border files
$myMediaContent += @(
  '',
  '-- -----',
  '--  BORDER',
  '-- ----'
)
$borderFiles = Get-ChildItem -Path "..\$folderName\border\*.*"
foreach ($file in $borderFiles) {
  $myMediaContent += "LSM:Register('border', '$($file.BaseName)', [[Interface\Addons\$folderName\border\$($file.Name)]])"
}

# Add font files
$myMediaContent += @(
  '',
  '-- -----',
  '--   FONT',
  '-- -----'
)
$fontFiles = Get-ChildItem -Path "..\$folderName\font\*.ttf"
foreach ($file in $fontFiles) {
  $myMediaContent += "LSM:Register('font', '$($file.BaseName)', [[Interface\Addons\$folderName\font\$($file.Name)]])"
}

# Add sound files
$myMediaContent += @(
  '',
  '-- -----',
  '--   SOUND',
  '-- -----'
)
$soundFiles = Get-ChildItem -Path "..\$folderName\sound\*.*"
foreach ($file in $soundFiles) {
  $iconId = ""
  foreach ($key in $nameToIconMap.Keys) {
      if ($file.BaseName -match "\b$key\b") {
          $iconId = $nameToIconMap[$key]
          break
      }
  }

  $escapedBaseName = $file.BaseName -replace "'", "\'"
  $prefix = if ($iconId) { "|T$($iconId):16|t" } else { "" }
  
  $myMediaContent += "LSM:Register('sound', '|cff00ff96$escapedBaseName ${prefix}|r', [[Interface\Addons\$folderName\sound\$($file.Name)]])"
}

# Add sound files
$myMediaContent += @(
  '',
  '-- -----',
  '--   KAZE SOUNDS',
  '-- -----'
)
$soundFiles = Get-ChildItem -Path "..\$folderName\sound\Kaze\*.*"
foreach ($file in $soundFiles) {
    $iconId = ""

    foreach ($key in $nameToIconMap.Keys) {
        if ($file.BaseName -match "\b$key\b") {
            $iconId = $nameToIconMap[$key]
            break
        }
    }

    $escapedBaseName = $file.BaseName -replace "'", "\'"
    $prefix = if ($iconId) { "|T$($iconId):16|t" } else { "" }
    $myMediaContent += "LSM:Register('sound', '|cff00ff97$escapedBaseName ${prefix}|r', [[Interface\Addons\$folderName\sound\Kaze\$($file.Name)]])"
}

# Add statusbar files
$myMediaContent += @(
  '',
  '-- -----',
  '--   STATUSBAR',
  '-- -----'
)
$statusbarFiles = Get-ChildItem -Path "..\$folderName\statusbar\*.*"
foreach ($file in $statusbarFiles) {
  $myMediaContent += "LSM:Register('statusbar', '$($file.BaseName)', [[Interface\Addons\$folderName\statusbar\$($file.Name)]])"
}

$myMediaContent | Out-File -FilePath $myMediaFile -Encoding UTF8

# Create the subfolder in the current working directory
$subfolderPath = "$currentDir\$folderName"
if (Test-Path $subfolderPath) {
  Remove-Item -Recurse -Force $subfolderPath
}
New-Item -Path $subfolderPath -ItemType Directory | Out-Null

# Copy the specified files and folders into the subfolder
Copy-Item -Path "$currentDir\SharedMedia_SwirlUI.lua" -Destination "$subfolderPath\" -Force
Copy-Item -Path "$currentDir\$folderName.toc" -Destination "$subfolderPath\" -Force
Copy-Item -Path "$currentDir\libs" -Destination "$subfolderPath\libs" -Recurse -Force
Copy-Item -Path "$currentDir\background" -Destination "$subfolderPath\background" -Recurse -Force
Copy-Item -Path "$currentDir\border" -Destination "$subfolderPath\border" -Recurse -Force
Copy-Item -Path "$currentDir\font" -Destination "$subfolderPath\font" -Recurse -Force
Copy-Item -Path "$currentDir\sound" -Destination "$subfolderPath\sound" -Recurse -Force
Copy-Item -Path "$currentDir\statusbar" -Destination "$subfolderPath\statusbar" -Recurse -Force
Copy-Item -Path "$currentDir\texture" -Destination "$subfolderPath\texture" -Recurse -Force

# Create the zip file
# $zipFile = "$currentDir\$folderName.zip"
# if (Test-Path $zipFile) {
#   Remove-Item -Force $zipFile
# }
# Compress-Archive -Path "$subfolderPath" -DestinationPath $zipFile -Force

# Write-Host "Files successfully registered"
# Write-Host "Zip file created at $zipFile"

# Clean up
Remove-Item -Recurse -Force $subfolderPath

# Pause here to give feedback to the user
Read-Host "Press Enter to exit"