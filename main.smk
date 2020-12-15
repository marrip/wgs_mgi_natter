# Define results this workflow should yield
rule all:
  input:
    expand("fastqc/{runid}_{id}_{orientation}_fastqc.{extension}", runid=config["samples"]["runid"], id=config["samples"]["barcodes"], orientation=["R1", "R2"], extension=["html", "zip"]),
    expand("genome_coverage/{runid}_{id}_coverage.bed", runid=config["samples"]["runid"], id=config["samples"]["barcodes"]),
    expand("breakdancer/{runid}_{id}_breakdancer_{focus}.vcf", runid=config["samples"]["runid"], id=config["samples"]["barcodes"], focus=["intrchr", "transchr"]),
    expand("lumpy/{runid}_{id}.vcf", runid=config["samples"]["runid"], id=config["samples"]["barcodes"]),
    expand("manta/{runid}_{id}/results/variants/{files}.vcf.gz", runid=config["samples"]["runid"], id=config["samples"]["barcodes"], files = ["candidateSV", "candidateSmallIndels", "tumorSV"])

# Combine fastq files for same sample from different barcodes and lanes
include:  "src/combine_fastq.smk"

# Run fastqc QC analysis on combined fastq files
include:  "src/fastqc.smk"

# Trim adapters and fix MGI fastq header with fastp
include:  "src/fastp.smk"

# Align reads to reference genome using the super fast bwa-mem2
include:  "src/bwa_mem2.smk"

# Mark duplicated reads using GATK4 Spark
include:  "src/mark_duplicates.smk"

# Calculate Genome coverage with bedtools
include: "src/genome_coverage.smk"

# Collect insert size metrics using GATK4 Picard
include: "src/insert_size_metrics.smk"

# CNV calling using BreakDancer
include:  "src/breakdancer.smk"

# CNV calling using Lumpy
include:  "src/lumpy.smk"

# CNV calling using Manta
include:  "src/manta.smk"

# CNV calling using Pindel - not recommended to run on WGS
include:  "src/pindel.smk"
