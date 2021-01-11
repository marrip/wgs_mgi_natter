rule pre_manta:
  input:
    ref = config["reference"]["fasta"],
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    bai = "mark_duplicates/{runid}_{id}_dedup.bam.bai"
  output:
    "manta/{runid}_{id}/runWorkflow.py"
  log:
    "manta/{runid}_{id}_pre_manta.log"
  container:
    config["tools"]["manta"]
  message: "Generate Manta run workflow script"
  shell:
    "configManta.py "
      "--tumorBam={input.bam} "
      "--referenceFasta={input.ref} "
      "--runDir=manta/{wildcards.runid}_{wildcards.id} &> {log}"

rule manta:
  input:
    ref = config["reference"]["fasta"],
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    bai = "mark_duplicates/{runid}_{id}_dedup.bam.bai",
    script = "manta/{runid}_{id}/runWorkflow.py"
  output:
    "manta/{runid}_{id}/results/variants/candidateSV.vcf.gz",
    "manta/{runid}_{id}/results/variants/candidateSmallIndels.vcf.gz",
    "manta/{runid}_{id}/results/variants/tumorSV.vcf.gz"
  log:
    "manta/{runid}_{id}_manta.log"
  container:
    config["tools"]["manta"]
  message: "Run Manta workflow script"
  threads: 40
  shell:
    "{input.script} "
      "-j {threads} "
      "-g unlimited &> {log}"
