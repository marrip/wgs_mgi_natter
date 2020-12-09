rule fastqc:
  input:
    fwd="combine_fastq/{runid}_{id}_R1.fq.gz",
    rev="combine_fastq/{runid}_{id}_R2.fq.gz"
  output:
    html="fastqc/{runid}_{id}_R1_fastqc.html",
    zip="fastqc/{runid}_{id}_R1_fastqc.zip"
  log:
    "fastqc/{runid}_{id}.log"
  container:
    config["tools"]["fastqc"]
  shell:
    "fastqc --outdir fastqc {input} &> {log}"
