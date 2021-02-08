#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gridss-germline
label: gridss-germline
cwlVersion: v1.1

$namespaces:
  edam: http://edamontology.org/

requirements:
  DockerRequirement:
    dockerPull: ghcr.io/tafujino/jga-analysis/gridss:latest
  EnvVarRequirement:
    envDef:
      CRAM: $(inputs.cram.path)
      VCF: $(inputs.cram.nameroot).vcf
      ASSEMBLY: $(inputs.cram.nameroot).assembly.bam
      REFERENCE: $(inputs.reference.path)
      NUM_THREADS: $(inputs.num_threads)
      GRIDSS_JAR: /opt/gridss/gridss-2.9.4-gridss-jar-with-dependencies.jar
      JAVA_TOOL_OPTIONS: $(inputs.java_tool_options)
      JVM_HEAP: $(inputs.jvm_heap)

baseCommand: [ bash, /tools/gridss-germline.sh ]

inputs:
  reference:
    type: File
    format: edam:format_1929
    doc: FastA file for reference genome
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .alt
      - .fai
  cram:
    type: File
    format: edam:format_3462
    secondaryFiles:
      - .crai
  num_threads:
    type: int
    default: 1
  java_tool_options:
    type: string
    default: ''
  jvm_heap:
    type: string
    default: 25g

outputs:
  vcf:
    type: File
    format: edam:format_3016
    outputBinding:
      glob: $(inputs.cram.nameroot).vcf
  idx:
    type: File
    outputBinding:
      glob: $(inputs.cram.nameroot).vcf.idx
  log:
    type: stderr

stderr: $(inputs.cram.basename).vcf.log
