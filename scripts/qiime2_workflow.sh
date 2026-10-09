#!/usr/bin/env bash
set -euo pipefail

# CRC gut microbiome 16S pilot
# Environment used: QIIME 2 2026.7
#
# IMPORTANT:
# This file documents and checks the existing workflow inputs.
# It does NOT rerun the analysis or claim to be a validated,
# end-to-end executable pipeline.

PROJECT_DIR="$HOME/metagenomics"
CLASSIFIER="$PROJECT_DIR/SILVA_144_SSURef_NR99_uniform_classifier_V4-515f-806r.qza"
METADATA="$PROJECT_DIR/Metadata/qiime-metadata.tsv"
MANIFEST="$PROJECT_DIR/manifest.tsv"

required_files=(
  "$CLASSIFIER"
  "$METADATA"
  "$MANIFEST"
)

echo "CRC 16S pilot: input validation"
echo "Project directory: $PROJECT_DIR"
echo

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "MISSING: $file" >&2
    exit 1
  fi
  echo "FOUND: $file"
done

echo
echo "Verified analysis settings:"
echo "  QIIME 2 environment: qiime2-2026.7"
echo "  DADA2 forward truncation: 240 bp"
echo "  DADA2 reverse truncation: 200 bp"
echo "  Taxonomy classifier: SILVA 144, V4 515F-806R"
echo
echo "Documented workflow order:"
echo "  1. Import paired-end reads using the manifest"
echo "  2. Inspect demultiplexing quality"
echo "  3. Denoise paired reads with DADA2"
echo "  4. Classify representative sequences"
echo "  5. Summarize taxonomy"
echo "  6. Calculate alpha diversity"
echo "  7. Calculate Bray-Curtis beta diversity and PCoA"
echo "  8. Run group-significance tests and interpret cautiously"
echo
echo "This script checks inputs only; it does not execute these steps."
echo "See README.md for the pilot's results and limitations."
