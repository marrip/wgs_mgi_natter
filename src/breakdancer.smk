# Multi threading not an option but splitting according to chromosomes
rule breakdancer:
  input:
    bam="mark_duplicates/{runid}_{id}_dedup.bam",
    bai="mark_duplicates/{runid}_{id}_dedup.bam.bai"
  output:
    intrchr="breakdancer/{runid}_{id}_breakdancer_intrchr.vcf",
    transchr="breakdancer/{runid}_{id}_breakdancer_transchr.vcf"
  log:
    "breakdancer/{runid}_{id}.log"
  container:
    config["tools"]["breakdancer"]
  shell:
    "bam2cfg.pl {input.bam} 1> breakdancer/breakdancer.cfg 2> {log} &&"
    "breakdancer-max breakdancer/breakdancer.cfg 1> {output.intrchr} 2>> {log} &&"
    "breakdancer-max -t breakdancer/breakdancer.cfg 1> {output.transchr} 2>> {log}"
