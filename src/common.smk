def linkSample2BarcodeFwd(wildcards):
    return expand(
        "{dir}/{runid}/{lane}/{runid}_{lane}_{barcode}_1.fq.gz",
        dir=config["samples"]["dir"],
        barcode=config["samples"]["barcodes"][wildcards.id],
        runid=config["samples"]["runid"],
        lane=config["samples"]["lane"],
    )


def linkSample2BarcodeRev(wildcards):
    return expand(
        "{dir}/{runid}/{lane}/{runid}_{lane}_{barcode}_2.fq.gz",
        dir=config["samples"]["dir"],
        barcode=config["samples"]["barcodes"][wildcards.id],
        runid=config["samples"]["runid"],
        lane=config["samples"]["lane"],
    )


def pindelOutputFiles(wildcards):
    return expand(
        "pindel/{runid}_{id}_{out_type}",
        runid=wildcards.runid,
        id=wildcards.id,
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
    )
