#!/bin/sh
#$ -S /bin/sh
set -eu

CONF_PATH=${1}
CWL_DIR=${2}
TMPDIR="/data1/inutano/work"
mkdir -p ${TMPDIR}

conf_line=$(awk -v id=${SGE_TASK_ID} 'NR == id' ${CONF_PATH})
fastq_path=$(echo ${conf_line} | cut -f 1)
dest_path=$(echo ${conf_line} | cut -f 2)

# load docker and venv
module load docker
source "/home/inutano/env/bin/activate"

# run cwltool
cwltool \
  --debug \
  --timestamps \
  --tmp-outdir-prefix ${TMPDIR} \
  --outdir ${dest_path} \
  "${CWL_DIR}/fastqc_wf_fq.cwl" \
  --nthreads 8 \
  --input_fastq ${fastq_path}
