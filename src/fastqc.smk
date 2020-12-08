rule fastqc:
  input:
    fwd="combine_fastq/{runid}_{id}_R1.fq",
    rev="combine_fastq/{runid}_{id}_R2.fq"
  output:
    html="fastqc/{runid}_{id}_R1_fastqc.html",
    zip="fastqc/{runid}_{id}_R1_fastqc.zip"
  log:
    "fastqc/{runid}_{id}.log"
  container:
    config["tools"]["fastqc"]
  shell:
    "fastqc --outdir fastqc {input} &> {log}"
