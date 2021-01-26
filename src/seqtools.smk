rule seqtools:
    input:
        "{runid}_results/simple_sv_annotation/{id}/tumorSV_annotated.vcf",
    output:
        "{runid}_results/seqtools/{id}/tumorSV_annotated.txt",
    log:
        "{runid}_results/seqtools/log/{id}_seqtools.log",
    container:
        config["tools"]["seqtools"]
    message:
        "Melt simple_sv_annotation vcf file with seqtools"
    shell:
        "seqtool vcf melt "
        "--vcf {input} "
        "--samplename {wildcards.id} "
        "--outfile {output} &> {log}"


rule post_seqtools:
    input:
        "{runid}_results/seqtools/{id}/tumorSV_annotated.txt",
    output:
        "{runid}_results/seqtools/{id}/tumorSV_annotated_processed.txt",
    log:
        "{runid}_results/seqtools/log/{id}_post_seqtools.log",
    container:
        config["tools"]["python"]
    message:
        "Postprocess seqtools table"
    script:
        "script/process_melted_vcf.py"
