rule fastqc:
  input:
    fwd = "{runid}_results/combine_fastq/{id}/{id}_R1.fq.gz",
    rev = "{runid}_results/combine_fastq/{id}/{id}_R2.fq.gz"
  output:
    "{runid}_results/fastqc/{id}/{id}_R1_fastqc.html",
    "{runid}_results/fastqc/{id}/{id}_R1_fastqc.zip",
    "{runid}_results/fastqc/{id}/{id}_R2_fastqc.html",
    "{runid}_results/fastqc/{id}/{id}_R2_fastqc.zip"
  params:
    "{runid}_results/fastqc/{id}"
  log:
    "{runid}_results/fastqc/log/{id}.log"
  container:
    config["tools"]["fastqc"]
  threads: 2
  shell:
    "fastqc "
      "-t {threads} "
      "--outdir {params} "
      "{input} &> {log}"
