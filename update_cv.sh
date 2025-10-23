#!/bin/bash

set -u

new_cv="$1"

# Find and remove old CV
config_path="_config.yml"
# CV line is like: cv_rel_url: /assets/pdf/BenLimpanukornCV-2025-10.pdf
old_cv_path=$(sed -n 's|^cv_rel_url: \(.*\)|.\1|p' "$config_path")
if [ -f "$old_cv_path" ]; then
    rm "$old_cv_path"
    echo "Removed old CV: $old_cv_path"
else
    echo "No old CV found at: $old_cv_path"
    exit 1
fi
# Copy new CV to assets/pdf/
cv_dir="assets/pdf"
mkdir -p "$cv_dir"
new_cv_filename=$(basename "$new_cv")
cp "$new_cv" "$cv_dir/$new_cv_filename"
echo "Copied new CV to: $cv_dir/$new_cv_filename"
# Update _config.yml with new CV path
new_cv_rel_url="/$cv_dir/$new_cv_filename"
sed -i.bak "s|^cv_rel_url: .*|cv_rel_url: $new_cv_rel_url|" "$config_path"
echo "Updated $config_path with new CV URL: $new_cv_rel_url"
# Clean up backup file created by sed
rm "$config_path.bak"
