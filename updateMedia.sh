#!/bin/bash

# Define function to trim whitespaces
trim() {
  local trimmed="$1"
  echo "$trimmed" | xargs
}

# Path to the JSON file
jsonPath="iconLinks.json"
# Load longName ➝ shortName map
declare -A longToShortMap
while IFS="=" read -r long short; do
  longToShortMap["$long"]="$short"
done < <(jq -r '.shortNames | to_entries[] | "\(.key)=\(.value)"' "$jsonPath")

# Load shortName ➝ iconId map
declare -A shortToIconMap
while IFS="=" read -r short id; do
  shortToIconMap["$short"]="$id"
done < <(jq -r '.ids | to_entries[] | "\(.key)=\(.value)"' "$jsonPath")


# Your existing logic to handle other parts of the script
currentDir=$(pwd)
folderName=$(basename "$currentDir")
tocFile="../$folderName/$folderName.toc"
wagoID=""

if [[ -f "$tocFile" ]]; then
  wagoID=$(grep "^## X-Wago-ID: " "$tocFile" | sed 's/^## X-Wago-ID: //')
  wagoID=$(trim "$wagoID")
else
  while true; do
    read -rp "Enter Wago Project ID (you can copy and paste it here and press Enter): " wagoID
    wagoID=$(trim "$wagoID")

    if [[ -z "$wagoID" ]]; then
      echo "Wago Project ID cannot be empty. Please try again."
    elif [[ ${#wagoID} -lt 6 ]]; then
      echo "Error: wagoID must be at least 6 characters long."
    else
      break
    fi
  done

  # Create necessary directories
  for dir in background border font sound statusbar; do
    mkdir -p "../$folderName/$dir"
  done

  # Create TOC file
  cat <<EOF > "$tocFile"
## Interface: 11506, 40402, 110100
## Title: $folderName
## X-Wago-ID: $wagoID
SharedMedia_SwirlUI.lua
libs\\LibStub\\LibStub.lua
libs\\CallbackHandler-1.0\\CallbackHandler-1.0.lua
libs\\LibSharedMedia-3.0\\LibSharedMedia-3.0.lua
EOF

  echo "AddOn created. Add your media files to the appropriate folders."
  echo "Run this script again to register the media files and create a zip file."
fi

luaFile="../$folderName/SharedMedia_SwirlUI.lua"
{
  echo 'local LSM = LibStub("LibSharedMedia-3.0")'
  echo
  echo 'local BACKGROUND = LSM.MediaType.BACKGROUND'
  echo 'local BORDER = LSM.MediaType.BORDER'
  echo 'local FONT = LSM.MediaType.FONT'
  echo 'local SOUND = LSM.MediaType.SOUND'
  echo 'local STATUSBAR = LSM.MediaType.STATUSBAR'
  echo
  echo '-- -----'
  echo '-- BACKGROUND'
  echo '-- -----'

  for f in ../$folderName/background/*; do
    [[ -f "$f" ]] || continue
    echo "LSM:Register(BACKGROUND, '$(basename "${f%.*}")', [[Interface\\Addons\\$folderName\\background\\$(basename "$f")]])"
  done

  echo
  echo '-- -----'
  echo '--  BORDER'
  echo '-- ----'

  for f in ../$folderName/border/*; do
    [[ -f "$f" ]] || continue
    echo "LSM:Register(BORDER, '$(basename "${f%.*}")', [[Interface\\Addons\\$folderName\\border\\$(basename "$f")]])"
  done

  echo
  echo '-- -----'
  echo '--   FONT'
  echo '-- -----'

  for f in ../$folderName/font/*.ttf; do
    [[ -f "$f" ]] || continue
    echo "LSM:Register(FONT, '$(basename "${f%.*}")', [[Interface\\Addons\\$folderName\\font\\$(basename "$f")]])"
  done

  echo
  echo '-- -----'
  echo '--   SOUND'
  echo '-- -----'

  for f in ../$folderName/sound/*; do
    [[ -f "$f" ]] || continue
    iconId=""
    for key in "${!shortToIconMap[@]}"; do
      if [[ "$(basename "$f")" =~ $key ]]; then
        iconId="${shortToIconMap[$key]}"
        iconId=$(echo -n "$iconId" | tr -d '\n' | xargs)
        break
      fi
    done
    baseName=$(basename "${f%.*}")
    prefix=""
    [[ -n "$iconId" ]] && prefix="|T${iconId}:16|t"
    echo "LSM:Register(SOUND, '|cff00ff96${baseName//\'/\\\'} ${prefix}|r', [[Interface\\Addons\\$folderName\\sound\\$(basename "$f")]])"
  done

  echo
  echo '-- -----'
  echo '--   STATUSBAR'
  echo '-- -----'

  for f in ../$folderName/statusbar/*; do
    [[ -f "$f" ]] || continue
    echo "LSM:Register(STATUSBAR, '$(basename "${f%.*}")', [[Interface\\Addons\\$folderName\\statusbar\\$(basename "$f")]])"
  done

} > "$luaFile"

subfolderPath="$currentDir/$folderName"
[[ -d "$subfolderPath" ]] && rm -rf "$subfolderPath"
mkdir -p "$subfolderPath"

cp -r "$luaFile" "$tocFile" libs background border font sound statusbar "$subfolderPath"

# Optionally create ZIP file
# zip -r "$folderName.zip" "$subfolderPath"

rm -rf "$subfolderPath"