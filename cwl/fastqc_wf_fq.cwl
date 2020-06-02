cwlVersion: v1.0
class: Workflow
label: "Run FastQC and summarize for Quanto database"
doc: "Run FastQC and summarize for Quanto database"

inputs:
  nthreads: int
  input_fastq: File[]

outputs:
  fastqc_result:
    type: File[]
    outputSource: fastqc/fastqc_result
  fastqc_summary_ttl:
    type: File[]
    outputSource: fastqc-util-ttl/fastqc_summary
  fastqc_summary_tsv:
    type: File[]
    outputSource: fastqc-util-tsv/fastqc_summary

steps:
  fastqc:
    run: fastqc.cwl
    in:
      seqfile: input_fastq
      nthreads: nthreads
    out:
      [fastqc_result]
  fastqc-util-tsv:
    run: fastqc-util-tsv.cwl
    in:
      fastqcResults: fastqc/fastqc_result
    out:
      [fastqc_summary]
  fastqc-util-ttl:
    run: fastqc-util-ttl.cwl
    in:
      fastqcResults: fastqc/fastqc_result
    out:
      [fastqc_summary]

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

s:license: https://spdx.org/licenses/Apache-2.0
s:codeRepository: https://github.com/pitagora-network/pitagora-cwl

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.18.owl
