rule mark_duplicates:
  input:
    bam = "bwa_mem2/{runid}_{id}.bam",
    bai = "bwa_mem2/{runid}_{id}.bam.bai"
  output:
    bam = "mark_duplicates/{runid}_{id}_dedup.bam",
    bai = "mark_duplicates/{runid}_{id}_dedup.bam.bai",
    metrics = "mark_duplicates/{runid}_{id}_dedup.bam.metrics"
  log:
    "mark_duplicates/{runid}_{id}.log"
  container:
    config["tools"]["gatk"]
  threads: 40
  message: "Run MarkDuplicatesSpark to mark duplicates"
  shell:
    "java -jar /gatk/gatk.jar MarkDuplicatesSpark "
      "-I {input.bam} "
      "-O {output.bam} "
      "-M {output.metrics} "
      "--tmp-dir mark_duplicates "
      "--create-output-bam-index true "
      "--spark-master local[{threads}] &> {log}"
