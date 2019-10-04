#!/bin/sh
#$ -S /bin/sh
set -eux

CONF_PATH=${1}
CWL_DIR=${2}
DEST_DIR=${3}
TMPDIR="/data1/inutano/work/quanto2"
mkdir -p ${TMPDIR}

fastq_path=$(awk -v id=${SGE_TASK_ID} 'NR == id { print $0 }' ${CONF_PATH})
dest_path=${DEST_DIR}/$(basename ${fastq_path} | sed -e 's:\..*$::g')
mkdir -p ${dest_path}

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
