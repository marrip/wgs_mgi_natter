rule simple_sv_annotation:
    input:
        vcf="{runid}_results/snpeff/{id}/tumorSV_annotated.vcf",
        fusion=config["simple_sv_annotation"]["fusion"],
        panel=config["simple_sv_annotation"]["panel"],
    output:
        "{runid}_results/simple_sv_annotation/{id}/tumorSV_annotated.vcf",
    log:
        "{runid}_results/simple_sv_annotation/log/{id}_simple_sv_annotation.log",
    container:
        config["tools"]["simple_sv_annotation"]
    message:
        "Annotate SnpEff vcf file with simple_sv_annotation"
    shell:
        "simple_sv_annotation.py "
        "--known_fusion_pairs {input.fusion} "
        "--gene_list {input.panel} "
        "--output {output} "
        "{input.vcf} &> {log}"
