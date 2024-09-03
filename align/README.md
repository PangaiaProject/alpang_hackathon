# Running the pipeline

From this directory, run:
```shell
snakemake -p --use-conda -c1
```

# Accuracy Evaluation Pipeline (Andreas Rempel and Tizian Schulz)

**Input:** A human pangenome graph generated from a human reference genome and a variant file in VCF format
 
**Idea:** To evaluate the mapping accuracy of the tools, we first simulate reads for the genome sequences of human individuals we have restored from the VCF file and which have been used to create the graph. Afterwards, we map the simulated reads to the graph. From the mappings, we retrieve the start and end coordinates on the linear reference sequence (i.e. the genome sequence that served as a template to generate the read). Finally, we compare these coordinates to the actual location inside the reference from which the read was simulated.

## Accuracy Measure
Various measures are possible to evaluate the accuracy of a read mapper. A relatively relaxed one is to check if mapping positions somewhat match the positions a read originates from.

Given a read $r$ originating from a substring starting at position $r_s$ and ending at position $r_e$ in genome _g_, and a mapping $m$ of $r$ starting at position $m_s$ and ending at position $m_e$ in _g_. The overlap between $r$ and $m$ is defined as 

$$o(r,m):=
\begin{cases}
r_e-r_s                      &\text{if }m_s\leq r_s\wedge r_e\leq m_e\\
m_e-m_s                      &\textnormal{if }r_s\leq m_s\wedge m_e\leq r_e\\
\textnormal{max}(0, r_e-m_s) &\textnormal{if }r_s\leq m_s\wedge r_e\leq m_e\\
\textnormal{max}(0, m_e-r_s) &\textnormal{otherwise.}
\end{cases}
$$

Given some ratio $t\in\mathbb{R}$, a mapping $m$ of read $r$ is considered _correct_ if $o(r,m)\geq\lfloor{t\cdot \textnormal{max}(r_e-r_s, m_e-m_s)}\rfloor$.

For now, we are interested in the number of reads which have at least one correct mapping.
