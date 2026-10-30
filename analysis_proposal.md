# EE282 Project Analysis Proposal: Chromatin Accessibility Dynamics During Early *Xenopus tropicalis* Development

## Introduction

For my final project, I will analyze how chromatin accessibility changes during early *Xenopus tropicalis* development. This follows my Topic Proposal, which focused on developmental accessibility patterns and the transcription factor motifs associated with them. ATAC-seq uses transposase-mediated sequencing to identify accessible DNA, providing information about candidate regulatory regions (Buenrostro et al. 2013). Studies in *Xenopus* have shown that maternal transcription factors contribute to chromatin remodeling during early development (Gentsch et al. 2019; Cui et al. 2025). I want to practice analyzing these data for future research in gene regulation. My main goals are to summarize peak reproducibility, compare accessibility across stages, and interpret groups of regions with similar patterns. Motif analysis will provide a smaller follow-up to these comparisons.

## Dataset and Acquisition

I will use the wild-type CANTAC-seq time course from Cui et al. (2025), deposited under GEO SuperSeries [GSE232071](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE232071) and CANTAC-seq subseries [GSE232068](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE232068). Stages 7, 8, and 9 represent blastula development, stage 10 marks the onset of gastrulation, and stage 13 marks the onset of neurulation. Each stage has two biological replicates (Cui et al. 2025). The samples are GSM7311370 and GSM7311371 for stage 7; GSM7311372 and GSM7311373 for stage 8; GSM7311374 and GSM7311375 for stage 9; GSM7311376 and GSM7311377 for stage 10; and GSM7311378 and GSM7311379 for stage 13.

The raw reads can be obtained through GEO’s SRA Run Selector and downloaded with the SRA Toolkit. The reference files are the *X. tropicalis* v10.0 genome and compatible Xenbase gene annotations.

## Analysis Strategy and Planned Results

### Peak Calling and Reproducibility

The first question is whether the accessible regions are reproducible between biological replicates. The workflow uses Bowtie2 for alignment, SAMtools for alignment processing, and MACS2 for peak calling (Langmead and Salzberg 2012; Li et al. 2009; Zhang et al. 2008). I will assess mapping rate, duplication, fragment-size distributions, and the fraction of reads in peaks. I will summarize peak counts for each replicate and pooled sample, and the number of narrow peaks passing an irreproducible discovery rate threshold of 0.05. IDR evaluates consistency in ranked signals between replicate experiments (Li et al. 2011). Narrow peaks will be the main input so that the developmental comparisons use one peak type consistently.

**Table 1** will list these results by stage and replicate. **Figure 1** will show replicate and IDR-filtered peak counts as bar plots. IDR plots will help assess differences in replicate agreement. A low number of passing peaks will be treated as a reason to examine the data and thresholds, rather than as direct evidence that a stage has little accessible chromatin. 

### Accessibility Across Developmental Stages

The second question is how accessibility patterns differ across stages 7, 8, 9, 10, and 13. I will use BEDTools to merge the union of IDR-filtered peaks across stages into a common region set (Quinlan and Hall 2010). Measuring signal at the same coordinates will allow comparison of regions detected in only some stages. A supporting table will summarize stage membership and overlap. I will also annotate regions relative to transcription start sites to distinguish promoter-proximal and distal regions.

For a direct comparison between replicates, I will count paired-end fragments from the processed BAM files over the common regions, counting each fragment once per overlapping region. I will divide each count by the total retained nuclear fragments in its sample and multiply by one million to calculate CPM. Log2(CPM + 1) values will be used for a sample correlation heatmap, included in **Figure 1**. CPM will support replicate comparisons, while RPKM-normalized bigWig tracks will show coverage around region centers. Neither normalization will be interpreted as an absolute measure of genome-wide accessibility.

Using deepTools `computeMatrix`, `plotHeatmap`, and `plotProfile`, I will summarize coverage around region centers (Ramírez et al. 2016). **Figure 2** will show the five-stage heatmap and average signal profiles. I will use k-means clustering to group regions with similar accessibility patterns across the five stages. I will start with six clusters and compare four- and five-cluster solutions on the same matrix, recording the random seed for each run. This check will show whether the main patterns persist across cluster numbers. Because coverage-based clustering can reflect signal intensity as well as temporal changes, I will consider both when interpreting the groups.

I will summarize mean RPKM within 100 bp on either side of region centers for each cluster and stage. **Table 2** will report these values and cluster sizes, and **Figure 3** will show the center-signal means as lines across stages. These summaries will help distinguish similar trends with different signal strengths. They demonstrate the course concepts of normalization, grouping, numerical summaries, and visualization. I will document scaling factors and distinguish exploratory patterns from statistically significant changes. 

### Motif Analysis

The third question is whether selected accessibility patterns are associated with different transcription factor motifs. I will use HOMER to examine two or three informative cluster groups (Heinz et al. 2010). Sequences will use a consistent window around region centers, with backgrounds accounting for sequence length and GC content. Where group sizes permit, I will analyze promoter-proximal and distal regions separately, defining proximal regions as overlapping −1,000 to +100 bp around an annotated transcription start site (Cui et al. 2025). **Figure 4** will summarize selected enriched motifs in a heatmap or dot plot, supported by target frequencies, background frequencies, and enrichment statistics. The interpretation will focus on candidate factor families, since motif enrichment alone cannot establish protein binding or regulatory function. Separate stage-specific motif analyses will be optional if time permits.

## Conclusions

This project will describe how chromatin accessibility varies across early Xenopus tropicalis development and identify candidate transcription factor motifs associated with selected patterns. The main results will include replicate quality and peak-count summaries, a correlation heatmap based on normalized fragment counts, a developmental accessibility heatmap with k-means clusters, and profiles showing signal changes across stages. These outputs will connect the biological questions to the course concepts of data processing, normalization, clustering, and visualization. The analysis is feasible because it uses ten publicly available samples, established bioinformatics tools, and HPC3 computing resources. I will complete quality assessment and peak comparisons first, followed by fragment counting, normalization, and clustering. Motif analysis will focus on a small number of informative groups after the main accessibility figures are complete. I will reserve time before the deadline to check results, improve figure labels, and organize reproducible scripts under `code/scripts` in the ee282 repository. This scope keeps the work focused on the original research questions while demonstrating exploratory data analysis, visualization, and reproducibility.

## References

Buenrostro JD, Giresi PG, Zaba LC, Chang HY, Greenleaf WJ. 2013. Transposition of native chromatin for fast and sensitive epigenomic profiling of open chromatin, DNA-binding proteins and nucleosome position. *Nat Methods* **10**: 1213–1218. doi: [10.1038/nmeth.2688](https://doi.org/10.1038/nmeth.2688).

Cui H, Liang W, Shi Z, Zhang L, Li G, Chen R, Tian C, Gan D, Shi X, Sun Z, et al. 2025. CANTAC-seq analysis reveals E2f1 and Otx1 coordinate zygotic genome activation in *Xenopus tropicalis*. *Nat Commun* **16**: 10101. doi: [10.1038/s41467-025-65146-8](https://doi.org/10.1038/s41467-025-65146-8).

Gentsch GE, Spruce T, Owens NDL, Smith JC. 2019. Maternal pluripotency factors initiate extensive chromatin remodelling to predefine first response to inductive signals. *Nat Commun* **10**: 4269. doi: [10.1038/s41467-019-12263-w](https://doi.org/10.1038/s41467-019-12263-w).

Heinz S, Benner C, Spann N, Bertolino E, Lin YC, Laslo P, Cheng JX, Murre C, Singh H, Glass CK. 2010. Simple combinations of lineage-determining transcription factors prime cis-regulatory elements required for macrophage and B cell identities. *Mol Cell* **38**: 576–589. doi: [10.1016/j.molcel.2010.05.004](https://doi.org/10.1016/j.molcel.2010.05.004).

Langmead B, Salzberg SL. 2012. Fast gapped-read alignment with Bowtie 2. *Nat Methods* **9**: 357–359. doi: [10.1038/nmeth.1923](https://doi.org/10.1038/nmeth.1923).

Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R, 1000 Genome Project Data Processing Subgroup. 2009. The Sequence Alignment/Map format and SAMtools. *Bioinformatics* **25**: 2078–2079. doi: [10.1093/bioinformatics/btp352](https://doi.org/10.1093/bioinformatics/btp352).

Li Q, Brown JB, Huang H, Bickel PJ. 2011. Measuring reproducibility of high-throughput experiments. *Ann Appl Stat* **5**: 1752–1779. doi: [10.1214/11-AOAS466](https://doi.org/10.1214/11-AOAS466).

Quinlan AR, Hall IM. 2010. BEDTools: a flexible suite of utilities for comparing genomic features. *Bioinformatics* **26**: 841–842. doi: [10.1093/bioinformatics/btq033](https://doi.org/10.1093/bioinformatics/btq033).

Ramírez F, Ryan DP, Grüning B, Bhardwaj V, Kilpert F, Richter AS, Heyne S, Dündar F, Manke T. 2016. deepTools2: a next generation web server for deep-sequencing data analysis. *Nucleic Acids Res* **44**: W160–W165. doi: [10.1093/nar/gkw257](https://doi.org/10.1093/nar/gkw257).

Zhang Y, Liu T, Meyer CA, Eeckhoute J, Johnson DS, Bernstein BE, Nusbaum C, Myers RM, Brown M, Li W, et al. 2008. Model-based analysis of ChIP-Seq (MACS). *Genome Biol* **9**: R137. doi: [10.1186/gb-2008-9-9-r137](https://doi.org/10.1186/gb-2008-9-9-r137).
