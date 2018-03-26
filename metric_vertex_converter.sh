#!/bin/bash

subj=$1
dataDir=/N/dc2/projects/lifebid/Concussion/concussion_real/cortex_mapping_test
metrics="fa md rd ad icvf od isovf"
hemi="lh rh"

export SUBJECTS_DIR=/N/dc2/projects/lifebid/Concussion/concussion_real/cortex_mapping_test

cd $dataDir/$subj;

for METRICS in $metrics
	do
		mkdir ./label/$METRICS
	done

for HEMI in $hemi
	do
		for METRICS in $metrics
			do
				mri_annotation2label --subject $subj --hemi $HEMI --surface midsurface.surf.gii --stat ./surf/${HEMI}.${METRICS}.func.gii --outdir ./label/$METRICS/			
			done
	done

for METRICS in $metrics
	do
		for i in $dataDir/$subj/label/$METRICS/*
			do
				tail "${i}" -n +3 > "${i}".txt
			done
	done
