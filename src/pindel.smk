rule pre_pindel:
  input:
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    metrics = "insert_size_metrics/{runid}_{id}.txt"
  output:
    "pindel/{runid}_{id}_pindel.cfg"
  log:
    "pindel/{runid}_{id}_pre_pindel.log"
  container:
    config["tools"]["python"]
  message: "Create pindel config file"
  script:
    "script/generate_pindel_config.py"

rule pindel:
  input:
    ref = config["reference"]["fasta"],
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    bai = "mark_duplicates/{runid}_{id}_dedup.bam.bai",
    cfg = "pindel/{runid}_{id}_pindel.cfg"
  output:
    "pindel/{runid}_{id}_BP",
    "pindel/{runid}_{id}_CloseEndMapped",
    "pindel/{runid}_{id}_D",
    "pindel/{runid}_{id}_INT_final",
    "pindel/{runid}_{id}_INV",
    "pindel/{runid}_{id}_LI",
    "pindel/{runid}_{id}_RP",
    "pindel/{runid}_{id}_SI",
    "pindel/{runid}_{id}_TD"
  params:
    B = 60
  log:
    "pindel/{runid}_{id}_pindel.log"
  container:
    config["tools"]["pindel"]
  threads: 40
  message: "Run pindel"
  shell:
    "pindel "
      "-f {input.ref} "
      "-i {input.cfg} "
      "-T {threads} "
      "-B {params.B} "
      "-o pindel/{wildcards.runid}_{wildcards.id} &> {log}"

rule pindel_to_vcf:
  input:
    ref = config["reference"]["fasta"],
    pindel_files = expand("pindel/{runid}_{id}_{out_type}",
        runid = config["samples"]["runid"],
        id = config["samples"]["barcodes"],
        out_type = ["BP", "CloseEndMapped", "D", "INT_final", "INV", "LI", "RP", "SI", "TD"])
  output:
    expand("pindel/{runid}_{id}_pindel.vcf",
        runid=config["samples"]["runid"],
        id=config["samples"]["barcodes"])
  params:
    prefix = expand("pindel/{runid}_{id}",
        runid = config["samples"]["runid"],
        id = config["samples"]["barcodes"]),
    refid = "'Genome Reference Consortium Human Build 38'",
    refdate = "20131217",
    e = 10,
    mc = 10,
    minsize = 5
  log:
    expand("pindel/{runid}_{id}_pindel_to_vcf.log",
        runid=config["samples"]["runid"],
        id=config["samples"]["barcodes"])
  container:
    config["tools"]["pindel"]
  message: "Reformat pindel output into vcf"
  shell:
    "pindel2vcf "
    "-P {params.prefix} "
    "-r {input.ref} "
    "-R {params.refid} "
    "-d {params.refdate} "
    "-v {output} "
    "-e {params.e} "
    "-mc {params.mc} "
    "-is {params.minsize} "
    "-G &> {log}"
