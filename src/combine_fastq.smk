include:  "common.smk"
runid = config['samples']['runid']

rule combine_fastq:
  input:
    fwd = linkSample2BarcodeFwd,
    rev = linkSample2BarcodeRev
  output:
    fwd = "combine_fastq/{runid}_{id}_R1.fq.gz",
    rev = "combine_fastq/{runid}_{id}_R2.fq.gz"
  log:
    "combine_fastq/{runid}_{id}.log"
  container:
    config["tools"]["ubuntu"]
  message: "Adding all reads for same sample and direction to single fastq file"
  shell:
    "cat {input.fwd} > {output.fwd} && "
    "cat {input.rev} > {output.rev}"
