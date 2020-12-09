# WGS-MGI-Natter :snake:

Snakemake workflow to process WGS sequencing data from MGI Instrument

## Requirements

To run this analysis, a couple of dependencies need to be met:

- python ≥ 3.8
- [snakemake](https://snakemake.readthedocs.io/en/stable/) ≥ 5.22.1
- [Singularity](https://sylabs.io/docs/) ≥ 3.7

In addition, the `template.cfg` needs to be modified to your individual
data. There are comments in the file for guidance. As an example, one
may check the `test.cfg`.

## Usage

The workflow may be started doing something like this:

```
snakemake \
  -s main.smk \
  --configfile test.cfg \
  --use-singularity \
  --singularity-args " --cleanenv --bind /Path/to/data/and/references"
```
