rule snpeff:
    input:
        vcf="{runid}_results/manta/{id}/results/variants/tumorSV_filtered.vcf.gz",
        cfile=config["snpeff"]["cfile"],
    output:
        vcf="{runid}_results/snpeff/{id}/tumorSV_annotated.vcf",
        html="{runid}_results/snpeff/{id}/tumorSV_annotated.html",
    params:
        config["snpeff"]["db"],
    log:
        "{runid}_results/snpeff/log/{id}_snpeff.log",
    container:
        config["tools"]["snpeff"]
    message:
        "Annotate manta vcf file with SnpEff"
    shell:
        "(java -jar /snpEff/snpEff.jar "
        "-v "
        "-c {input.cfile} "
        "-nodownload "
        "-canon "
        "-s {output.html} "
        "{params} "
        "{input.vcf} > {output.vcf}) &> {log}"
