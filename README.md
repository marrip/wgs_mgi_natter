# WGS-MGI-Natter :snake:

Snakemake workflow to process WGS sequencing data from MGI Instrument

## Requirements

To run this analysis, a couple of dependencies need to be met:

- python ≥ 3.8
- [snakemake](https://snakemake.readthedocs.io/en/stable/) ≥ 5.22.1
- [Singularity](https://sylabs.io/docs/) ≥ 3.7

In addition, the `template.cfg` needs to be modified to your individual
data. There are comments in the file for guidance. As an example, one
may check the `test.cfg`. The used reference file should be indexed both
with `samtools` and `bwa-mem2`. For detailed instructions on how to prep
the reference, please refer to the section *Prep reference*. There are
also suitable files available at
`https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0`.

## Usage

The workflow may be started doing something like this:

```
snakemake \
  -s main.smk \
  --configfile test.cfg \
  --use-singularity \
  --singularity-args " --cleanenv --bind /Path/to/data/and/references"
```

## Prep reference

Starting of with the latest version of the human genome as a `fasta` file,
we use `samtools` to index the file like so:

```
samtools faidx genome.fasta
```

In addition to the `fasta` file, the `{genome}_assembly_report.txt` and
the `par_align.gff` are needed. The former to build the right subset of
regions, excluding alternate loci, and rename them, and the latter to mask
the pseudo-autosomal region (PAR) on chromosome Y. Starting with generating
a list for the subset of sequences:

```
sort -k1,1V {genome}_assembly_report.txt | awk -v FS="\t" '$8 == "Primary Assembly" || $8 == "non-nuclear" {print $7}' > subset_ids.txt
```

With this list we can do the actual subset:

```
samtools faidx genome.fasta -r subset_ids.txt -o genome_subset.fasta
```

The next step is to mask the PAR on chromosome Y. We extract the positions
from the `par_align.gff`:

```
sed -E 's/.*Target=([^;]+).*/\1/g' par_align.gff | awk -v OFS="\t" '$0 !~ "^#" {print $1, $2-1, $3}'  > parY.bed
```

and then use `bedtools` to do the actual masking:

```
bedtools maskfasta -fi genome_subset.fasta -bed parY.bed -fo genome_subset_masked.fasta
```

Finally, the sequence headers need to be renamed to replace the GenBank
Accession Numbers:

```
awk -v FS="\t" 'NR==FNR {header[">"$5] = ">"$1" "$5" "$7" "$10; next} $0 ~ "^>" {$0 = header[$0]}1' {genome}_assembly_report.txt genome_subset_masked.fasta > genome_alignment.fasta
```
