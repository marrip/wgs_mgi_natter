def linkSample2BarcodeFwd(wildcards):
  return expand(
    "{dir}/{runid}/{lane}/{runid}_{lane}_{barcode}_1.fq.gz",
    dir=config["samples"]["dir"],
    barcode=config["samples"]["barcodes"][wildcards.id],
    runid=config["samples"]["runid"],
    lane=config["samples"]["lane"])

def linkSample2BarcodeRev(wildcards):
  return expand(
    "{dir}/{runid}/{lane}/{runid}_{lane}_{barcode}_2.fq.gz",
    dir=config["samples"]["dir"],
    barcode=config["samples"]["barcodes"][wildcards.id],
    runid=config["samples"]["runid"],
    lane=config["samples"]["lane"])

rule combine_fastq:
  input:
    fwd = linkSample2BarcodeFwd,
    rev = linkSample2BarcodeRev
  output:
    fwd = "combine_fastq/" + config["samples"]["runid"] + "_{id}_R1.fq.gz",
    rev = "combine_fastq/" + config["samples"]["runid"] + "_{id}_R2.fq.gz"
  container:
    config["tools"]["ubuntu"]
  shell:
    "cat {input.fwd} > {output.fwd} &&"
    "cat {input.rev} > {output.rev}"
