rule fastqc:
  input:
    fwd = "combine_fastq/{runid}_{id}_R1.fq.gz",
    rev = "combine_fastq/{runid}_{id}_R2.fq.gz"
  output:
    "fastqc/{runid}_{id}_R1_fastqc.html",
    "fastqc/{runid}_{id}_R1_fastqc.zip",
    "fastqc/{runid}_{id}_R2_fastqc.html",
    "fastqc/{runid}_{id}_R2_fastqc.zip"
  log:
    "fastqc/{runid}_{id}.log"
  container:
    config["tools"]["fastqc"]
  threads: 2
  shell:
    "fastqc "
      "-t {threads} "
      "--outdir fastqc "
      "{input} &> {log}"
