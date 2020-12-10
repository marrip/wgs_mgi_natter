include:  "common.smk"

rule combine_fastq:
  input:
    fwd = linkSample2BarcodeFwd,
    rev = linkSample2BarcodeRev
  output:
    fwd = f"combine_fastq/{config['samples']['runid']}_{id}_R1.fq.gz",
    rev = f"combine_fastq/{config['samples']['runid']}_{id}_R2.fq.gz"
  log:
    f"combine_fastq/{config['samples']['runid']}_{id}.log"
  container:
    config["tools"]["ubuntu"]
  shell:
    "cat {input.fwd} > {output.fwd} && "
    "cat {input.rev} > {output.rev}"
