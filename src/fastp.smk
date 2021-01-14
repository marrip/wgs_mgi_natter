rule fastp:
  input:
    fwd = "{runid}_results/combine_fastq/{id}/{id}_R1.fq.gz",
    rev = "{runid}_results/combine_fastq/{id}/{id}_R2.fq.gz"
  output:
    fwd = "{runid}_results/fastp/{id}/{id}_R1.fq.gz",
    rev = "{runid}_results/fastp/{id}/{id}_R2.fq.gz",
    json = "{runid}_results/fastp/{id}/{id}_fastp.json",
    html = "{runid}_results/fastp/{id}/{id}_fastp.html"
  params:
    ad_fwd = config["samples"]["adapter"]["fwd"],
    ad_rev = config["samples"]["adapter"]["rev"]
  log:
    "{runid}_results/fastp/log/{id}.log"
  container:
    config["tools"]["fastp"]
  threads: 40
  message: "Trim adapters and fix mgi id in fastq header"
  shell:
    "fastp "
      "--in1 {input.fwd} "
      "--in2 {input.rev} "
      "--out1 {output.fwd} "
      "--out2 {output.rev} "
      "--fix_mgi_id "
      "--adapter_sequence {params.ad_fwd} "
      "--adapter_sequence_r2 {params.ad_rev} "
      "--json {output.json} "
      "--html {output.html} "
      "-w {threads} &> {log}"
