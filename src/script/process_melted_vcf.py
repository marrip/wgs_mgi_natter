#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import sys

# Install and load pandas
subprocess.check_call([sys.executable, "-m", "pip", "install", "pandas"])
import pandas

def importTable(file):
    # Define column names and read seqtools table
    original_cn = ['SampleName', 'FILTER', 'CHROM', 'POS', 'REF', 'ALT', 'ID', 'IMPRECISE', 'SVTYPE', 'SVLEN', 'END', 'CIPOS.0', 'CIPOS.1', 'CIEND.0', 'CIEND.1', 'CIGAR', 'MATEID', 'EVENT', 'HOMLEN', 'HOMSEQ', 'SVINSLEN', 'SVINSSEQ', 'LEFT_SVINSSEQ', 'RIGHT_SVINSSEQ', 'BND_DEPTH', 'MATE_BND_DEPTH', 'ANN', 'LOF', 'NMD', 'SIMPLE_ANN', 'SV_HIGHEST_TIER', 'Tumor_Ref_PR', 'Tumor_Alt_PR', 'Tumor_Ref_SR', 'Tumor_Alt_SR']
    pandas.read_csv(str(file), sep='\t', encoding='latin-1', names=original_cn)

def modifyTable(table):
    # Retain non-filtered calls of BND-type
    table = table[(table['FILTER']=='.') & (table['SVTYPE']=='BND')]
    table = table.sort_values(by=['ID'])

    # Specify columns and calculate total alt reads 
    tumor_cn = ['Tumor_Ref_PR', 'Tumor_Alt_PR', 'Tumor_Ref_SR', 'Tumor_Alt_SR']
    table[tumor_cn] = table[tumor_cn].apply(pandas.to_numeric, errors='coerce', downcast='integer').fillna(0)
    table['Total_Tumor_Alt'] = table['Tumor_Alt_PR'] + table['Tumor_Alt_SR']

    # Expand ANN field to separate columns, select first annotation (16 columns) as there can be multiple
    anno_table = table["ANN"].str.split('|', expand=True)
    anno_table = anno_table[anno_table.columns[0:16]]
    anno_table.columns = ['Allele', 'Annotation', 'Annotation_Impact', 'Gene_Name', 'Gene_ID', 'Feature_Type', 'Feature_ID', 'Transcript_BioType', 'Rank', 'HGVS.c', 'HGVS.p', 'cDNA.pos / cDNA.length', 'CDS.pos / CDS.length', 'AA.pos / AA.length', 'Distance', 'ERRORS / WARNINGS / INFO']

    # Expand simple SV annotation to separate columns
    simplesv_table = table["SIMPLE_ANN"].str.split('|', expand=True)
    simplesv_table = simplesv_table[simplesv_table.columns[0:6]]
    simplesv_table.columns = ['SVTYPE', 'ANNOTATION', 'GENE(s)', 'TRANSCRIPT', 'DETAIL (exon losses, KNOWN_FUSION, ON_PRIORITY_LIST, NOT_PRIORITISED)', 'PRIORITY (1-3) ']
    
    # Merge DFs
    complete_table = pandas.concat([table, anno_table, simplesv_table], axis=1)

    # Replace ASCII errors for ;-sign
    complete_table['HGVS.c'] = complete_table['HGVS.c'].str.replace('%3B',';')

    # Select only columns of interest
    select_cn = ['SampleName', 'CHROM', 'POS', 'REF', 'ALT', 'Gene_Name', 'ID', 'MATEID', 'IMPRECISE', 'SVINSSEQ', 'BND_DEPTH', 'MATE_BND_DEPTH', 'SV_HIGHEST_TIER', 'Tumor_Ref_PR', 'Tumor_Alt_PR', 'Tumor_Ref_SR', 'Tumor_Alt_SR', 'Total_Tumor_Alt', 'Annotation', 'HGVS.c', 'DETAIL (exon losses, KNOWN_FUSION, ON_PRIORITY_LIST, NOT_PRIORITISED)']
    return complete_table[select_cn]

table = importTable(snakemake.input)

if table == None:
    with open(str(snakemake.output), 'a'):
        os.utime(str(snakemake.output), None)
elif len(table) > 0:
    formatted_table = modifyTable(table)
    formatted_table.to_csv('{}'.format(str(snakemake.output)), sep='\t', index=False)
