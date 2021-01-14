# Multi threading not an option but splitting according to chromosomes
rule breakdancer:
  input:
    bam = "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
    bai = "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
  output:
    cfg = "{runid}_results/breakdancer/{id}/breakdancer.cfg",
    intrchr = "{runid}_results/breakdancer/{id}/{id}_breakdancer_intrchr.vcf",
    transchr = "{runid}_results/breakdancer/{id}/{id}_breakdancer_transchr.vcf"
  log:
    "{runid}_results/breakdancer/log/{id}.log"
  container:
    config["tools"]["breakdancer"]
  message: "Calling CNVs with BreakDancer"
  shell:
    "bam2cfg.pl {input.bam} 1> {output.cfg} 2> {log} &&"
    "breakdancer-max {output.cfg} 1> {output.intrchr} 2>> {log} &&"
    "breakdancer-max -t {output.cfg} 1> {output.transchr} 2>> {log}"
