#!/usr/bin/env bash
# Render docs/*.md and REVIEWING.md to output/*.docx (formatted with docx-format.yaml) and output/*.pdf.
set -euo pipefail
shopt -s nullglob

mkdir -p output
files=(docs/*.md)
[[ -f REVIEWING.md ]] && files+=(REVIEWING.md)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "No documents found" >&2
  exit 1
fi

for f in "${files[@]}"; do
  python tools/md-to-docx.py "$f" "output/$(basename "$f" .md).docx" --config docx-format.yaml
done
soffice -env:UserInstallation=file:///tmp/lo-profile --headless --convert-to pdf --outdir output output/*.docx
ls -l output
