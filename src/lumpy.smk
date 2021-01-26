rule disco_reads:
    input:
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        bai="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
    output:
        "{runid}_results/lumpy/{id}/{id}_disco_reads.bam",
    log:
        "{runid}_results/lumpy/log/{id}_disco_reads.log",
    container:
        config["tools"]["lumpy"]
    message:
        "Extracting disconcordant reads from dedup bam file"
    shell:
        "(samtools view "
        "-b "
        "-F 1294 {input.bam} | "
        "samtools sort -o {output} -) &> {log}"


rule split_reads:
    input:
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        bai="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
    output:
        "{runid}_results/lumpy/{id}/{id}_split_reads.bam",
    log:
        "{runid}_results/lumpy/log/{id}_split_reads.log",
    container:
        config["tools"]["lumpy"]
    message:
        "Extracting split reads from dedup bam file"
    shell:
        "(samtools view -h {input.bam} | "
        "extractSplitReads_BwaMem -i stdin | "
        "samtools view -Sb - | "
        "samtools sort -o {output} -) &> {log}"


rule lumpyexpress:
    input:
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        bai="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
        disco="{runid}_results/lumpy/{id}/{id}_disco_reads.bam",
        split="{runid}_results/lumpy/{id}/{id}_split_reads.bam",
    output:
        "{runid}_results/lumpy/{id}/{id}.vcf",
    log:
        "{runid}_results/lumpy/log/{id}_lumpyexpress.log",
    container:
        config["tools"]["lumpy"]
    message:
        "Running lumpyexpress to identify CNVs"
    shell:
        "lumpyexpress "
        "-B {input.bam} "
        "-D {input.disco} "
        "-S {input.split} "
        "-o {output}"
