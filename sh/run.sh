#!/bin/sh
#
# usage:
#   ./run.sh [|singularity]
#
set -eux

abspath(){
  cd $(dirname ${1}) && pwd -P
}

# The path to the directory to where the DRA storage attached
FASTQ_DIR="/usr/local/resources/dra/fastq"

# The path to the directory where this script exists
BASE_DIR=$(abspath ${0})
CWL_DIR="${BASE_DIR}/../cwl"

# The path to the directory where the result data are stored
RESULT_DIR="${BASE_DIR}/../data"
mkdir -p "${RESULT_DIR}"

# Create working directory
WORK_DIR="${RESULT_DIR}/$(date "+%Y%m%d")"
mkdir -p "${WORK_DIR}"

# Create a list of sequence data file name already calculated
LIST_QC_DONE="${WORK_DIR}/quanto.done.list"
find "${RESULT_DIR}" -name '*ttl' -type 'f' | xargs -I{} basename {} ".ttl" | sort -u > ${LIST_QC_DONE}

# Create array job configuration
cd ${WORK_DIR} && find ${FASTQ_DIR} -name '*.fastq.*' -printf "%T@ %p\n" | sort -nr | awk '{ print $NF }' | split -l 5000 -d - "array."

# If any argument is given, singularity mode is on
if [[ $# -eq 0 ]]; then
  # Load UGE settings for DBCLS node
  source "/home/geadmin/UGED/uged/common/settings.sh"
  JOB_SH="${BASE_DIR}/job.sh"
else
  JOB_SH="${BASE_DIR}/job.singularity.sh"
fi

# Execute array job
find ${WORK_DIR} -name "array.*" | sort | while read jobconf; do
  jobname=$(basename ${jobconf})
  qsub -j y -N "${jobname}" -o /dev/null -pe def_slot 16 -l s_vmem=32G -l mem_req=32G -t 1-5000:1 \
    ${JOB_SH} ${jobconf} ${CWL_DIR} ${WORK_DIR} ${LIST_QC_DONE}
done
