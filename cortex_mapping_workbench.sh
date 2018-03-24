#!/bin/bash

## This script will create a midthickness surface, map tensor and NODDI values to this surface, and compute stats for each ROI from Freesurfer parcellation

# Set subject directory in Freesurfer
export SUBJECTS_DIR=/N/dc2/projects/lifebid/Concussion/concussion_real/cortex_mapping_test

# Variables
subj=$1;
HEMI="lh rh";
METRIC="fa md rd ad icvf od isovf";


cd $SUBJECTS_DIR/$subj;
mkdir metric;

echo "File name conversion"
# Tensor
if [ -f "./tensor/${subj}_fa.nii.gz" ]; then
	cd tensor;
	for i in *
		do
			out=`echo "${i}" | sed "s/......//"`;		
			cp -v "${i}" ../metric/"${out}";
		done
	cd $SUBJECTS_DIR/$subj;
else
	echo "Subject number removed from tensor filename. Moving on"
fi

# NODDI
if [ -f "./noddi/FIT_ICVF_NEW.nii.gz" ]; then
	cd noddi
	metricFile=('FIT_ICVF_NEW' 'FIT_OD_NEW' 'FIT_ISOVF_NEW');
	metricConv=('icvf' 'od' 'isovf');
	for ((idx=0; idx<${#metricFile[@]}; ++idx)); do cp -v "${metricFile[idx]}".nii.gz ../metric/"${metricConv[idx]}".nii.gz; done
else
	echo "NODDI file name made cleaner. Moving on"
fi

echo "File name conversion complete";

cd $SUBJECTS_DIR/$subj;

for hemi in $HEMI
	do
		mris_convert surf/${hemi}.pial surf/${hemi}.pial.surf.gii;
		mris_convert surf/${hemi}.white surf/${hemi}.white.surf.gii;
		wb_command -surface-cortex-layer surf/${hemi}.white.surf.gii surf/${hemi}.pial.surf.gii 0.5 surf/${hemi}.midsurface.surf.gii;
	done

for hemi in $HEMI
	do
		for metric in $METRIC
			do
				wb_command -volume-to-surface-mapping ./metric/${metric}.nii.gz ./surf/${hemi}.midsurface.surf.gii ./surf/${hemi}.${metric}.func.gii -ribbon-constrained ./surf/${hemi}.white.surf.gii ./surf/${hemi}.pial.surf.gii;
				mri_segstats --annot $subj ${hemi} aparc --i ./surf/${hemi}.${metric}.func.gii --sum ./stats/${hemi}.${metric}.sum;
			done
	done
