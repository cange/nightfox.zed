#!/usr/bin/env zsh

local src_dir="$(pwd -P)/assets/screenshots"
local target_dir="$(pwd -P)/assets/images"
local tmp_dir="$(pwd -P)/tmp"
local names=("carbon" "dawn" "day" "dusk" "night" "nord" "tera")

# Read the first line containing 'version'
local pkg_file="$(pwd -P)/extension.toml"
local version=$(grep -E '^version *=.*' ${pkg_file})
# Extract version value
version=${version##*=}
# Strip any leading/trailing spaces
version=${version## }
version=${version%% }
# Strip any leading/trailing quotes
version="${version%\"}"
version="${version#\"}"

command mkdir -p "$tmp_dir"

for file in "${names[@]}"; do
  local filename="${file}fox.png"
  local filename_version="${file}fox-${version}.png"
  command ffmpeg -i "${src_dir}/${filename}" -vf scale=2000:-1 "${tmp_dir}/${filename}" -y
  command pngquant --colors 255 --quality 80-90 "${tmp_dir}/${filename}" --output "${target_dir}/${filename_version}" -f
done

command rm -rf "$tmp_dir"
