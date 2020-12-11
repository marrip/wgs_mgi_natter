rule insert_size_metrics:
  input:
    bam="mark_duplicates/{runid}_{id}_dedup.bam",
    bai="mark_duplicates/{runid}_{id}_dedup.bam.bai"
  output:
    txt="insert_size_metrics/{runid}_{id}.txt",
    pdf="insert_size_metrics/{runid}_{id}.pdf"
  log:
    "insert_size_metrics/{runid}_{id}.log"
  container:
    config["tools"]["gatk"]
  message: "Use picard to collect insert size metrics"
  shell:
    "java -jar /gatk/gatk.jar CollectInsertSizeMetrics "
      "-I {input.bam} "
      "-O {output.txt} "
      "-H {output.pdf} &> {log}"

