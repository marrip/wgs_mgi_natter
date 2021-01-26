rule bwa_mem2:
    input:
        fwd="{runid}_results/fastp/{id}/{id}_R1.fq.gz",
        rev="{runid}_results/fastp/{id}/{id}_R2.fq.gz",
        ref=config["reference"]["fasta"],
    output:
        bam="{runid}_results/bwa_mem2/{id}/{id}.bam",
        bai="{runid}_results/bwa_mem2/{id}/{id}.bam.bai",
    params:
        "'@RG\tID:{id}\tSM:{id}\tLB:{runid}_{id}'",
    log:
        "{runid}_results/bwa_mem2/log/{id}.log",
    container:
        config["tools"]["bwa_mem2"]
    threads: 40
    message:
        "Aligning reads with bwa-mem2"
    shell:
        "(bwa-mem2 mem "
        "-t {threads} "
        "-R {params} "
        "{input.ref} "
        "{input.fwd} "
        "{input.rev} | "
        "samtools sort -o {output.bam} -) &> {log} && "
        "samtools index {output.bam} {output.bai} &>> {log}"
