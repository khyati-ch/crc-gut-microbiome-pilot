
# Gut Microbiome Across the Colorectal Adenoma–Carcinoma Sequence

## Project Overview

How does gut microbial diversity and community composition vary across normal controls, colorectal adenoma, and colorectal cancer (CRC)?

This project documents a nine-sample pilot analysis of publicly available 16S rRNA amplicon sequencing data. It explores microbial community patterns across three diagnostic groups and establishes a foundation for a transparent microbiome analysis workflow.

**This is an exploratory pilot, not a powered disease-association study.** The results are preliminary and should not be interpreted as evidence of causation or clinical utility.

## Research Question

Colorectal cancer can develop through a sequence of tissue changes that includes adenomatous lesions. Gut microbial communities may differ across these diagnostic stages.

This pilot examines:

- **Alpha diversity:** within-sample microbial diversity.
- **Beta diversity:** differences in microbial community composition between samples.
- **Taxonomic composition:** microbial taxa identified from 16S rRNA sequences.

Although the broader biological motivation includes bile acid and lipid metabolism, 16S amplicon sequencing does not directly measure microbial metabolic genes, pathway activity, or metabolite concentrations. These questions require additional functional or metabolomic data.

## Dataset

- **Source study:** Baxter et al. (2016)
- **NCBI BioProject:** [PRJNA290926](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA290926)
- **Publication:** [Baxter et al., Genome Medicine (2016)](https://doi.org/10.1186/s13073-016-0290-3)
- **Pilot size:** 9 samples
- **Diagnostic groups:** 3 normal controls, 3 adenoma, and 3 CRC
- **Data type:** paired-end 16S rRNA amplicon sequencing
- **Taxonomic reference:** SILVA 144 classifier trained for the V4 region

The `dx` metadata field defines the three diagnostic groups. The original `stage` field was not used for these comparisons because its values were inconsistent for this subset.

This is a small reanalysis pilot, not a reproduction of the original study's complete analysis.

## Tools and Methods

| Tool or method | Purpose |
|---|---|
| QIIME 2 (2026.7) | Microbiome analysis framework |
| DADA2 | Paired-read denoising, merging, and chimera removal |
| SILVA 144 classifier | Taxonomic classification |
| Shannon diversity | Measures within-sample diversity |
| Simpson diversity | Summarizes diversity with greater weight on common taxa |
| Pielou evenness | Measures the evenness of taxon abundances |
| Bray–Curtis dissimilarity | Quantifies differences in community composition |
| Principal Coordinates Analysis (PCoA) | Visualizes sample relationships from a distance matrix |
| PERMANOVA | Tests for differences in community composition between groups |

## Workflow

The documented analysis workflow comprises the following stages:

1. Import paired-end reads using a manifest.
2. Inspect sequencing-read quality.
3. Denoise paired-end reads with DADA2, including read merging and chimera removal.
4. Classify representative sequences using the SILVA 144 V4-trained classifier.
5. Summarize taxonomic composition.
6. Calculate alpha-diversity metrics.
7. Calculate Bray–Curtis distances and perform PCoA.
8. Explore differences in community composition using PERMANOVA.

**Documented DADA2 truncation settings:** 240 bp for forward reads and 200 bp for reverse reads.

These steps describe the analysis workflow. The current shell script is a helper that checks for required input files and prints documented settings; it does not execute the complete analysis end to end.

## Installation and Setup

### 1. Install QIIME 2

Follow the official installation instructions for QIIME 2 2026.7:

https://docs.qiime2.org/2026.7/install/

Activate the environment used for this analysis:

```bash
conda activate qiime2-2026.7
qiime --version
```

### 2. Obtain the Input Data

The source data are available through [NCBI BioProject PRJNA290926](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA290926).

The documented workflow requires:

- Paired-end sequencing reads for the nine selected samples.
- A manifest containing the read-file locations.
- A metadata file containing the diagnostic groups.
- A SILVA 144 classifier artifact trained for the V4 region.

Raw sequencing files and large QIIME 2 intermediate artifacts are not bundled with this repository.

### 3. Check the Workflow Inputs

The current helper script expects these files under `$HOME/metagenomics`:

- `SILVA_144_SSURef_NR99_uniform_classifier_V4-515f-806r.qza`
- `Metadata/qiime-metadata.tsv`
- `manifest.tsv`

From the repository directory, run:

```bash
bash scripts/qiime2_workflow.sh
```

**Important:** this script checks whether the required files exist and prints documented workflow settings. It does not import reads, run DADA2, classify sequences, calculate diversity, or execute statistical tests. Its paths reflect the original local directory structure and may need to be adapted for another installation.

## Results

### Read Processing

All nine samples produced non-chimeric sequences after DADA2 processing.

- **Input read pairs:** approximately 19,315–124,117 per sample.
- **Non-chimeric sequences:** approximately 15,814–101,301 per sample.
- **Non-chimeric read retention:** approximately 81.04–88.09%.

Input sequencing depth varied by approximately 6.4-fold across samples, an important consideration when comparing diversity metrics.

### Alpha Diversity

Shannon diversity, Simpson diversity, and Pielou evenness were calculated. A depth-standardized analysis was subsequently generated using a rarefaction depth of 15,000 reads per sample, retaining all nine samples.

Relevant outputs:

- `results/alpha-diversity-all-metrics.xlsx`
- `figures/shannon-diversity.png`

The pilot shows variation among individual samples and does not establish a clear, consistent diversity trend across the normal–adenoma–cancer sequence.

Rarefaction standardizes the number of reads sampled for this analysis, but it does not overcome the small sample size or establish statistical significance.

### Beta Diversity

The existing Bray–Curtis PCoA was based on the original DADA2 feature table.

- **PCoA axis 1:** 23.37% of variation.
- **PCoA axis 2:** 17.81% of variation.
- **Overall PERMANOVA:** pseudo-F = 0.981, p = 0.537, using 999 permutations.

The groups overlapped in the ordination, and the overall PERMANOVA result was not statistically significant.

This does not establish that the groups have identical microbiomes or that disease-associated differences are absent. With only three samples per group, statistical power is limited.

The beta-diversity results should not be described as a rarefied reanalysis unless those analyses are explicitly rerun and documented.

## Figures

### Bray–Curtis PCoA

![Bray–Curtis PCoA of the nine-sample pilot](figures/bray-curtis-pcoa.png)

The first two axes explain 23.37% and 17.81% of the variation, respectively.

### Shannon Alpha Diversity

![Shannon diversity across diagnostic groups](figures/shannon-diversity.png)

The figure displays Shannon diversity from the depth-standardized pilot analysis. Each group contains only three samples.

### DADA2 Read Retention

![Percentage of input reads retained after DADA2](figures/dada2-read-retention.png)

The plot summarizes non-chimeric read retention for the nine samples.

## Repository Structure

- `Metadata/qiime-metadata.tsv`: metadata for the pilot samples.
- `manifest-template.tsv`: template for specifying paired-end FASTQ locations.
- `scripts/qiime2_workflow.sh`: checks for required local input files and prints documented workflow settings.
- `results/`: exported diversity summaries and other analysis outputs.
- `figures/`: visual summaries of diversity, ordination, and read retention.

Raw sequencing files, reference artifacts, and large QIIME 2 intermediate artifacts are not included. File locations may need adjustment for a new installation.

## Limitations

- Only three samples represent each diagnostic group.
- Sequencing depth differs substantially among samples.
- Alpha- and beta-diversity results were not all generated from the same feature-table version.
- The current helper script is not an end-to-end reproducible pipeline.
- The pilot cannot establish causation, clinical utility, or equivalence between diagnostic groups.
- 16S amplicon data do not directly measure microbial functional genes or metabolic pathways.
- The analysis workflow, including primer handling, environment setup, and the complete sequence of processing steps, requires further validation.

## Next Steps

- Make the analysis workflow executable from a fresh project directory.
- Document the exact commands and software versions used at each analysis stage.
- Validate primer handling and read-processing parameters.
- Ensure diversity analyses use appropriately documented feature tables and settings.
- Expand the sample set before drawing disease-group inferences.
- Use suitable shotgun metagenomic datasets for future investigations of bile acid and lipid-metabolism genes.

## Acknowledgements

This project uses publicly available data associated with NCBI BioProject PRJNA290926.

## Reference

Baxter NT, Ruffin MT IV, Rogers MAM, Schloss PD. Microbiota-based model improves the sensitivity of fecal immunochemical test for detecting colonic lesions. *Genome Medicine*. 2016;8:37.

https://doi.org/10.1186/s13073-016-0290-3
