rule bwa_mem2:
  input:
    fwd = "fastp/{runid}_{id}_R1.fq.gz",
    rev = "fastp/{runid}_{id}_R2.fq.gz",
    ref = config["reference"]["fasta"]
  output:
    bam = "bwa_mem2/{runid}_{id}.bam",
    bai = "bwa_mem2/{runid}_{id}.bam.bai"
  params:
    "'@RG\tID:{id}\tSM:{id}\tLB:{runid}_{id}'"
  log:
    "bwa_mem2/{runid}_{id}.log"
  container:
    config["tools"]["bwa_mem2"]
  threads: 40
  message: "Aligning reads with bwa-mem2"
  shell:
    "(bwa-mem2 mem "
      "-t {threads} "
      "-R {params} "
      "{input.ref} "
      "{input.fwd} "
      "{input.rev} | "
    "samtools sort -o {output.bam} -) &> {log} && "
    "samtools index {output.bam} {output.bai} &>> {log}"
