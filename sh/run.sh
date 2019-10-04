#!/bin/sh
set -eux

abspath(){
  cd $(dirname ${1}) && pwd -P
}

BASE_DIR=$(abspath ${0})
DATA_DIR=$(abspath ${1})/$(basename ${1})
DEST_DIR=$(abspath ${2})/$(basename ${1})
CWL_DIR="${BASE_DIR}/../cwl"
JOB_CONF="${DEST_DIR}/array.conf"

# Create array job configuration
find ${DATA_DIR} -name '*fastq*' > ${JOB_CONF}

# Execute array job
source "/home/geadmin/UGED/uged/common/settings.sh"
qsub -t 1:$(wc -l ${JOB_CONF}) -j y -o ${DEST_DIR} \
  ${BASE_DIR}/job.sh ${JOB_CONF} ${CWL_DIR}
