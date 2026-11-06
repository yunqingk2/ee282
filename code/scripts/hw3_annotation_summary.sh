#!/usr/bin/env bash
set -eo pipefail

gtf=$1
if [ "${2:-features}" = genes ]; then
    printf 'chromosome_arm\tgenes\n'
    bioawk -c gff '$feature == "gene" && $seqname ~ /^(X|Y|2L|2R|3L|3R|4)$/ {print $seqname}' "$gtf" \
    | sort | uniq -c \
    | awk '{print $2 "\t" $1}'
else
    printf 'feature\tcount\n'
    bioawk -c gff '{print $feature}' "$gtf" \
    | sort | uniq -c | sort -rn \
    | awk '{print $2 "\t" $1}'
fi
