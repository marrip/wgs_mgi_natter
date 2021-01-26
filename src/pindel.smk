rule pre_pindel:
    input:
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        metrics="{runid}_results/insert_size_metrics/{id}/{id}.txt",
    output:
        "{runid}_results/pindel/{id}/{id}_pindel.cfg",
    log:
        "{runid}_results/pindel/log/{id}_pre_pindel.log",
    container:
        config["tools"]["python"]
    message:
        "Create pindel config file"
    script:
        "script/generate_pindel_config.py"


rule pindel:
    input:
        ref=config["reference"]["fasta"],
        bam="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam",
        bai="{runid}_results/mark_duplicates/{id}/{id}_dedup.bam.bai",
        cfg="{runid}_results/pindel/{id}/{id}_pindel.cfg",
    output:
        "{runid}_results/pindel/{id}/{id}_BP",
        "{runid}_results/pindel/{id}/{id}_CloseEndMapped",
        "{runid}_results/pindel/{id}/{id}_D",
        "{runid}_results/pindel/{id}/{id}_INT_final",
        "{runid}_results/pindel/{id}/{id}_INV",
        "{runid}_results/pindel/{id}/{id}_LI",
        "{runid}_results/pindel/{id}/{id}_RP",
        "{runid}_results/pindel/{id}/{id}_SI",
        "{runid}_results/pindel/{id}/{id}_TD",
    params:
        B=60,
    log:
        "{runid}_results/pindel/log/{id}_pindel.log",
    container:
        config["tools"]["pindel"]
    threads: 40
    message:
        "Run pindel"
    shell:
        "pindel "
        "-f {input.ref} "
        "-i {input.cfg} "
        "-T {threads} "
        "-B {params.B} "
        "-o {wildcards.runid}_results/pindel/{wildcards.id}/{wildcards.id} &> {log}"


rule pindel_to_vcf:
    input:
        ref=config["reference"]["fasta"],
        pindel_files=expand(
            "{runid}_results/pindel/{id}/{id}_{out_type}",
            runid=config["samples"]["runid"],
            id=config["samples"]["barcodes"],
            out_type=[
                "BP",
                "CloseEndMapped",
                "D",
                "INT_final",
                "INV",
                "LI",
                "RP",
                "SI",
                "TD",
            ],
        ),
    output:
        expand(
            "{runid}_results/pindel/{id}/{id}_pindel.vcf",
            runid=config["samples"]["runid"],
            id=config["samples"]["barcodes"],
        ),
    params:
        prefix=expand(
            "{runid}_results/pindel/{id}/{id}",
            runid=config["samples"]["runid"],
            id=config["samples"]["barcodes"],
        ),
        refid="'Genome Reference Consortium Human Build 38'",
        refdate="20131217",
        e=10,
        mc=10,
        minsize=5,
    log:
        expand(
            "{runid}_results/pindel/log/{id}_pindel_to_vcf.log",
            runid=config["samples"]["runid"],
            id=config["samples"]["barcodes"],
        ),
    container:
        config["tools"]["pindel"]
    message:
        "Reformat pindel output into vcf"
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
