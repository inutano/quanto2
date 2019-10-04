#!/bin/sh
set -eux

abspath(){
  cd $(dirname ${1}) && pwd -P
}

BASE_DIR=$(abspath ${0})
DATA_DIR=$(abspath ${1})/$(basename ${1})
DEST_DIR=$(abspath ${2})/$(basename ${2})
CWL_DIR="${BASE_DIR}/../cwl"
JOB_CONF="${DEST_DIR}/array.conf"

# Create array job configuration
if [[ ! -e ${JOB_CONF} ]]; then
  find ${DATA_DIR} -name '*.fastq.*' > ${JOB_CONF}
fi

# Execute array job
source "/home/geadmin/UGED/uged/common/settings.sh"
qsub -j y -o ${DEST_DIR} -t 1-$(wc -l ${JOB_CONF}):1 \
  ${BASE_DIR}/job.sh ${JOB_CONF} ${CWL_DIR}
