rule genome_coverage:
  input:
    "mark_duplicates/{runid}_{id}_dedup.bam",
  output:
    "genome_coverage/{runid}_{id}_coverage.bed"
  log:
    "genome_coverage/{runid}_{id}.log"
  container:
    config["tools"]["common"]
  message: "Calculating coverage using bedtools"
  shell:
    "bedtools genomecov "
      "-ibam {input} "
      "-bg 1> {output} 2> {log}"
