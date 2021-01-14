rule mark_duplicates:
  input:
    bam = "{runid}_results/bwa_mem2/{id}/{id}.bam",
    bai = "{runid}_results/bwa_mem2/{id}/{id}.bam.bai"
  output:
    bam = "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
    bai = "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
    metrics = "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.metrics"
  params:
    tmp = "{runid}_results/mark_duplicates"
  log:
    "{runid}_results/mark_duplicates/log/{id}.log"
  container:
    config["tools"]["gatk"]
  threads: 40
  message: "Run MarkDuplicatesSpark to mark duplicates"
  shell:
    "java -jar /gatk/gatk.jar MarkDuplicatesSpark "
      "-I {input.bam} "
      "-O {output.bam} "
      "-M {output.metrics} "
      "--tmp-dir {params} "
      "--create-output-bam-index true "
      "--spark-master local[{threads}] &> {log}"
