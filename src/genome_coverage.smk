rule genome_coverage:
    input:
        "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
    output:
        "{runid}_results/genome_coverage/{id}/{id}_coverage.bed",
    log:
        "{runid}_results/genome_coverage/log/{id}_bedtools.log",
    container:
        config["tools"]["common"]
    message:
        "Calculating coverage using bedtools"
    shell:
        "bedtools genomecov "
        "-ibam {input} "
        "-bg 1> {output} 2> {log}"


rule mosdepth:
    input:
        "{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
    output:
        "{runid}_results/genome_coverage/{id}/{id}.mosdepth.global.dist.txt",
        "{runid}_results/genome_coverage/{id}/{id}.mosdepth.region.dist.txt",
        "{runid}_results/genome_coverage/{id}/{id}.mosdepth.summary.txt",
        "{runid}_results/genome_coverage/{id}/{id}.regions.bed.gz",
        "{runid}_results/genome_coverage/{id}/{id}.regions.bed.gz.csi",
    log:
        "{runid}_results/genome_coverage/log/{id}_mosdepth.log",
    container:
        config["tools"]["mosdepth"]
    threads: 40
    message:
        "Calculating coverage using mosdepth"
    shell:
        "mosdepth "
        "-n "
        "-t {threads} "
        "--fast-mode "
        "--by 500 "
        "{wildcards.runid}_results/genome_coverage/{wildcards.id}/{wildcards.id} "
        "{input} 2> {log}"
