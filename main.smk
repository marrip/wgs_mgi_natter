# Define results this workflow should yield
rule all:
  input:
    expand("{runid}_results/fastqc/{id}/{id}_{orientation}_fastqc.{extension}", runid=config["samples"]["runid"], id=config["samples"]["barcodes"], orientation=["R1", "R2"], extension=["html", "zip"]),
    expand("{runid}_results/genome_coverage/{id}/{id}.mosdepth.{files}.txt", runid=config["samples"]["runid"], id=config["samples"]["barcodes"], files=["global.dist", "summary"]),
    expand("{runid}_results/seqtools/{id}/tumorSV_annotated_processed.txt", runid=config["samples"]["runid"], id=config["samples"]["barcodes"])

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

# CNV calling using Manta
include:  "src/manta.smk"

# Annotation using SnpEff
include: "src/snpeff.smk"

# Annotation using simple_sv_annotation
include: "src/simple_sv_annotation.smk"

# Melt vcf with seqtools
include: "src/seqtools.smk"

# Collect insert size metrics using GATK4 Picard - no output rule
include: "src/insert_size_metrics.smk"

# CNV calling using BreakDancer - no output rule
include:  "src/breakdancer.smk"

# CNV calling using Lumpy - no output rule
include:  "src/lumpy.smk"

# CNV calling using Pindel - not recommended to run on WGS
include:  "src/pindel.smk"
