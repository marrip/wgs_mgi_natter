rule insert_size_metrics:
    input:
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        bai="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
    output:
        txt="{runid}_results/insert_size_metrics/{id}/{id}.txt",
        pdf="{runid}_results/insert_size_metrics/{id}/{id}.pdf",
    log:
        "{runid}_results/insert_size_metrics/log/{id}.log",
    container:
        config["tools"]["gatk"]
    message:
        "Use picard to collect insert size metrics"
    shell:
        "java -jar /gatk/gatk.jar CollectInsertSizeMetrics "
        "-I {input.bam} "
        "-O {output.txt} "
        "-H {output.pdf} &> {log}"
