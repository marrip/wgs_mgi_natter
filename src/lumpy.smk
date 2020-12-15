rule disco_reads:
  input:
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    bai = "mark_duplicates/{runid}_{id}_dedup.bam.bai"
  output:
    "lumpy/{runid}_{id}_disco_reads.bam"
  log:
    "lumpy/{runid}_{id}_disco_reads.log"
  container:
    config["tools"]["lumpy"]
  message: "Extracting disconcordant reads from dedup bam file"
  shell:
    "(samtools view "
      "-b "
      "-F 1294 {input.bam} | "
    "samtools sort -o {output} -) &> {log}"
  
rule split_reads:
  input:
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    bai = "mark_duplicates/{runid}_{id}_dedup.bam.bai"
  output:
    "lumpy/{runid}_{id}_split_reads.bam"
  log:
    "lumpy/{runid}_{id}_split_reads.log"
  container:
    config["tools"]["lumpy"]
  message: "Extracting split reads from dedup bam file"
  shell:
    "(samtools view -h {input.bam} | "
    "extractSplitReads_BwaMem -i stdin | "
    "samtools view -Sb - | "
    "samtools sort -o {output} -) &> {log}"

rule lumpyexpress:
  input:
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    bai = "mark_duplicates/{runid}_{id}_dedup.bam.bai",
    disco = "lumpy/{runid}_{id}_disco_reads.bam",
    split = "lumpy/{runid}_{id}_split_reads.bam"
  output:
    "lumpy/{runid}_{id}.vcf"
  log:
    "lumpy/{runid}_{id}_lumpyexpress.log"
  container:
    config["tools"]["lumpy"]
  message: "Running lumpyexpress to identify CNVs"
  shell:
    "lumpyexpress "
      "-B {input.bam} "
      "-D {input.disco} "
      "-S {input.split} "
      "-o {output}"
