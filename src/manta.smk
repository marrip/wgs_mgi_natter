rule pre_manta:
    input:
        ref=config["reference"]["fasta"],
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        bai="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
    output:
        "{runid}_results/manta/{id}/runWorkflow.py",
    log:
        "{runid}_results/manta/log/{id}_pre_manta.log",
    container:
        config["tools"]["manta"]
    message:
        "Generate Manta run workflow script"
    shell:
        "configManta.py "
        "--tumorBam={input.bam} "
        "--referenceFasta={input.ref} "
        "--runDir={wildcards.runid}_results/manta/{wildcards.id} &> {log}"


rule manta:
    input:
        ref=config["reference"]["fasta"],
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        bai="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
        script="{runid}_results/manta/{id}/runWorkflow.py",
    output:
        "{runid}_results/manta/{id}/results/variants/tumorSV.vcf.gz",
    log:
        "{runid}_results/manta/log/{id}_manta.log",
    container:
        config["tools"]["manta"]
    message:
        "Run Manta workflow script"
    threads: 40
    shell:
        "{input.script} "
        "-j {threads} "
        "-g unlimited &> {log}"


rule filter_manta:
    input:
        vcf="{runid}_results/manta/{id}/results/variants/tumorSV.vcf.gz",
        bed=config["manta"]["bed"],
    output:
        "{runid}_results/manta/{id}/results/variants/tumorSV_filtered.vcf.gz",
    log:
        "{runid}_results/manta/log/{id}_filter_manta.log",
    container:
        config["tools"]["common"]
    message:
        "Filter manta vcf against bed file with normal variants"
    shell:
        "(bedtools intersect "
        "-header "
        "-v "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} | gzip > {output}) &> {log}"
