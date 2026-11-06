# EE282 Homework3

## Data

The genome and annotation files are from the *Drosophila melanogaster* release **r6.66, FB2025_05** linked in the assignment.

| Dataset | FlyBase source |
| --- | --- |
| All-chromosome genome FASTA | [dmel-all-chromosome-r6.66.fasta.gz](https://s3ftp.flybase.org/genomes/Drosophila_melanogaster/dmel_r6.66_FB2025_05/fasta/dmel-all-chromosome-r6.66.fasta.gz) |
| GTF annotation | [dmel-all-r6.66.gtf.gz](https://s3ftp.flybase.org/genomes/Drosophila_melanogaster/dmel_r6.66_FB2025_05/gtf/dmel-all-r6.66.gtf.gz) |

### Download files

My working directory on my local is `~/myrepos/hw3`, with the two summary scripts saved in `code/scripts/`.

```bash
cd ~/myrepos/hw3
mkdir -p data output code/scripts
base=https://s3ftp.flybase.org/genomes/Drosophila_melanogaster/dmel_r6.66_FB2025_05

wget -O data/dmel-all-chromosome-r6.66.fasta.gz \
    "$base/fasta/dmel-all-chromosome-r6.66.fasta.gz"
wget -O data/fasta-md5sum.txt "$base/fasta/md5sum.txt"
wget -O data/dmel-all-r6.66.gtf.gz \
    "$base/gtf/dmel-all-r6.66.gtf.gz"
wget -O data/gtf-md5sum.txt "$base/gtf/md5sum.txt"
```

### Run summaries

```bash
cd ~/myrepos/hw3
conda activate ee282
bash code/scripts/hw3_genome_summary.sh \
    data/dmel-all-chromosome-r6.66.fasta.gz \
    > output/genome_summary.tsv
bash code/scripts/hw3_annotation_summary.sh \
    data/dmel-all-r6.66.gtf.gz features \
    > output/feature_counts.tsv
bash code/scripts/hw3_annotation_summary.sh \
    data/dmel-all-r6.66.gtf.gz genes \
    > output/genes_per_arm.tsv
```

## 1. Summarize the genome assembly

### File integrity

The compressed FASTA's calculated MD5 checksum matches the value published in FlyBase's [FASTA checksum manifest](https://s3ftp.flybase.org/genomes/Drosophila_melanogaster/dmel_r6.66_FB2025_05/fasta/md5sum.txt).

| Check | Result |
| --- | --- |
| Published MD5 | `ccb86e94117eb4eeaaf70efb6be1b6b9` |
| Calculated MD5 | `ccb86e94117eb4eeaaf70efb6be1b6b9` |
| Comparison | **PASS** |

```bash
cd ~/myrepos/hw3/data
grep ' dmel-all-chromosome-r6.66.fasta.gz$' fasta-md5sum.txt \
| md5sum -c
```

```text
dmel-all-chromosome-r6.66.fasta.gz: OK
```

### Genome summary

| Requested statistic | Count |
| --- | ---: |
| Total number of nucleotides, including Ns | **143,726,002** |
| Total number of Ns, counting both `N` and `n` | **1,152,978** |
| Total number of sequences | **1,870** |

The genome script runs:

```bash
faSize -tab "$1"
```

`baseCount` gives total bases including Ns, `nBaseCount` gives Ns, and `seqCount` gives the number of sequences.

Implementation: [hw3_genome_summary.sh](code/scripts/hw3_genome_summary.sh). Recorded output: [genome_summary.tsv](output/genome_summary.tsv).

## 2. Summarize the annotation file

### File integrity

The compressed GTF's calculated MD5 checksum matches the value published in FlyBase's [GTF checksum manifest](https://s3ftp.flybase.org/genomes/Drosophila_melanogaster/dmel_r6.66_FB2025_05/gtf/md5sum.txt).

| Check | Result |
| --- | --- |
| Published MD5 | `ea600dbb86f1779463f69082131753cd` |
| Calculated MD5 | `ea600dbb86f1779463f69082131753cd` |
| Comparison | **PASS** |

```bash
cd ~/myrepos/hw3/data
md5sum -c gtf-md5sum.txt
```

```text
dmel-all-r6.66.gtf.gz: OK
```

### Total features of each type

| Feature type | Number of features |
| --- | ---: |
| exon | 190,176 |
| CDS | 163,377 |
| 5UTR | 46,856 |
| 3UTR | 33,778 |
| start_codon | 30,922 |
| stop_codon | 30,862 |
| mRNA | 30,836 |
| gene | 17,872 |
| ncRNA | 3,059 |
| miRNA | 485 |
| pseudogene | 365 |
| tRNA | 312 |
| snoRNA | 270 |
| pre_miRNA | 262 |
| rRNA | 115 |
| snRNA | 32 |
| **Total** | **549,579** |

Features are sorted from most common to least common:

```bash
bioawk -c gff '{print $feature}' "$gtf" \
| sort | uniq -c | sort -rn
```

Implementation: [hw3_annotation_summary.sh](code/scripts/hw3_annotation_summary.sh), `features` mode. Recorded output: [feature_counts.tsv](output/feature_counts.tsv).

### Total genes per chromosome arm

```bash
bioawk -c gff '$feature == "gene" && $seqname ~ /^(X|Y|2L|2R|3L|3R|4)$/ {print $seqname}' "$gtf" \
| sort | uniq -c
```

| Chromosome arm | Number of genes |
| --- | ---: |
| X | 2,704 |
| Y | 113 |
| 2L | 3,508 |
| 2R | 3,649 |
| 3L | 3,481 |
| 3R | 4,226 |
| 4 | 114 |
| **Total** | **17,795** |

Implementation: [hw3_annotation_summary.sh](code/scripts/hw3_annotation_summary.sh), `genes` mode. Recorded output: [genes_per_arm.tsv](output/genes_per_arm.tsv).
