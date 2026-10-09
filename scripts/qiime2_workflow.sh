#!/usr/bin/env bash
set -euo pipefail

# CRC 16S pilot workflow
# Environment: qiime2-2026.7
# Run from the original project directory: ~/metagenomics
# This script documents the main analysis commands.
# It has not yet been validated as a standalone end-to-end pipeline.

PROJECT_DIR="$HOME/metagenomics"
CLASSIFIER="$PROJECT_DIR/SILVA_144_SSURef_NR99_uniform_classifier_V4-515f-806r.qza"
METADATA="$PROJECT_DIR/Metadata/qiime-metadata.tsv"
MANIFEST="$PROJECT_DIR/manifest.tsv"

for file in "$CLASSIFIER" "$METADATA" "$MANIFEST"; do
    if [[ ! -f "$file" ]]; then
        echo "Required input not found: $file" >&2
        exit 1
    fi
done

echo "Required input files found."
echo "This is a documented workflow draft, not a standalone pipeline."
echo "Review input paths and output locations before running analysis."
