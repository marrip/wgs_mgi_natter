rule fastp:
  input:
    fwd="combine_fastq/{runid}_{id}_R1.fq.gz",
    rev="combine_fastq/{runid}_{id}_R2.fq.gz"
  output:
    fwd="fastp/{runid}_{id}_R1.fq.gz",
    rev="fastp/{runid}_{id}_R2.fq.gz",
    json="fastp/{runid}_{id}_fastp.json",
    html="fastp/{runid}_{id}_fastp.html"
  params:
    ad_fwd=config["samples"]["adapter"]["fwd"],
    ad_rev=config["samples"]["adapter"]["rev"]
  log:
    "fastp/{runid}_{id}.log"
  container:
    config["tools"]["fastp"]
  threads: 40
  shell:
    "fastp --in1 {input.fwd} --in2 {input.rev} --out1 {output.fwd} --out2 {output.rev} --fix_mgi_id --adapter_sequence {params.ad_fwd} --adapter_sequence_r2 {params.ad_rev} --json {output.json} --html {output.html} --w {threads} &> {log}"
