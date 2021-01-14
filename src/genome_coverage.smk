rule genome_coverage:
  input:
    "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
  output:
    "{runid}_results/genome_coverage/{id}/{id}_coverage.bed"
  log:
    "{runid}_results/genome_coverage/log/{id}.log"
  container:
    config["tools"]["common"]
  message: "Calculating coverage using bedtools"
  shell:
    "bedtools genomecov "
      "-ibam {input} "
      "-bg 1> {output} 2> {log}"
