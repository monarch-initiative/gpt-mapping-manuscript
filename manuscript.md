---
title: 'MapperGPT: Large Language Models for Linking and Mapping Entities'
keywords:
- GPT
- Large Language Models
- OWL
- Mapping
- Ontologies
- SSSOM
lang: en-US
date-meta: '2023-06-01'
author-meta:
- John Doe
- Chris Mungall
header-includes: |
  <!--
  Manubot generated metadata rendered from header-includes-template.html.
  Suggest improvements at https://github.com/manubot/manubot/blob/main/manubot/process/header-includes-template.html
  -->
  <meta name="dc.format" content="text/html" />
  <meta property="og:type" content="article" />
  <meta name="dc.title" content="MapperGPT: Large Language Models for Linking and Mapping Entities" />
  <meta name="citation_title" content="MapperGPT: Large Language Models for Linking and Mapping Entities" />
  <meta property="og:title" content="MapperGPT: Large Language Models for Linking and Mapping Entities" />
  <meta property="twitter:title" content="MapperGPT: Large Language Models for Linking and Mapping Entities" />
  <meta name="dc.date" content="2023-06-01" />
  <meta name="citation_publication_date" content="2023-06-01" />
  <meta property="article:published_time" content="2023-06-01" />
  <meta name="dc.modified" content="2023-06-01T01:55:03+00:00" />
  <meta property="article:modified_time" content="2023-06-01T01:55:03+00:00" />
  <meta name="dc.language" content="en-US" />
  <meta name="citation_language" content="en-US" />
  <meta name="dc.relation.ispartof" content="Manubot" />
  <meta name="dc.publisher" content="Manubot" />
  <meta name="citation_journal_title" content="Manubot" />
  <meta name="citation_technical_report_institution" content="Manubot" />
  <meta name="citation_author" content="John Doe" />
  <meta name="citation_author_institution" content="Department of Something, University of Whatever" />
  <meta name="citation_author_orcid" content="XXXX-XXXX-XXXX-XXXX" />
  <meta name="twitter:creator" content="@johndoe" />
  <meta name="citation_author" content="Chris Mungall" />
  <meta name="citation_author_institution" content="Environmental Genomics and Systems Biology Division, Lawrence Berkeley National Laboratory, Berkeley, CA, 94720" />
  <meta name="citation_author_orcid" content="0000-0002-6601-2165" />
  <link rel="canonical" href="https://cmungall.github.io/gpt-mapping-manuscript/" />
  <meta property="og:url" content="https://cmungall.github.io/gpt-mapping-manuscript/" />
  <meta property="twitter:url" content="https://cmungall.github.io/gpt-mapping-manuscript/" />
  <meta name="citation_fulltext_html_url" content="https://cmungall.github.io/gpt-mapping-manuscript/" />
  <meta name="citation_pdf_url" content="https://cmungall.github.io/gpt-mapping-manuscript/manuscript.pdf" />
  <link rel="alternate" type="application/pdf" href="https://cmungall.github.io/gpt-mapping-manuscript/manuscript.pdf" />
  <link rel="alternate" type="text/html" href="https://cmungall.github.io/gpt-mapping-manuscript/v/ed03cbf92522b4a8ffdb5d09279905699af3d80d/" />
  <meta name="manubot_html_url_versioned" content="https://cmungall.github.io/gpt-mapping-manuscript/v/ed03cbf92522b4a8ffdb5d09279905699af3d80d/" />
  <meta name="manubot_pdf_url_versioned" content="https://cmungall.github.io/gpt-mapping-manuscript/v/ed03cbf92522b4a8ffdb5d09279905699af3d80d/manuscript.pdf" />
  <meta property="og:type" content="article" />
  <meta property="twitter:card" content="summary_large_image" />
  <link rel="icon" type="image/png" sizes="192x192" href="https://manubot.org/favicon-192x192.png" />
  <link rel="mask-icon" href="https://manubot.org/safari-pinned-tab.svg" color="#ad1457" />
  <meta name="theme-color" content="#ad1457" />
  <!-- end Manubot generated metadata -->
bibliography:
- content/manual-references.json
manubot-output-bibliography: output/references.json
manubot-output-citekeys: output/citations.tsv
manubot-requests-cache-path: ci/cache/requests-cache
manubot-clear-requests-cache: false
...






<small><em>
This manuscript
([permalink](https://cmungall.github.io/gpt-mapping-manuscript/v/ed03cbf92522b4a8ffdb5d09279905699af3d80d/))
was automatically generated
from [cmungall/gpt-mapping-manuscript@ed03cbf](https://github.com/cmungall/gpt-mapping-manuscript/tree/ed03cbf92522b4a8ffdb5d09279905699af3d80d)
on June 1, 2023.
</em></small>



## Authors



+ **John Doe**
  <br>
    ![ORCID icon](images/orcid.svg){.inline_icon width=16 height=16}
    [XXXX-XXXX-XXXX-XXXX](https://orcid.org/XXXX-XXXX-XXXX-XXXX)
    · ![GitHub icon](images/github.svg){.inline_icon width=16 height=16}
    [johndoe](https://github.com/johndoe)
    · ![Twitter icon](images/twitter.svg){.inline_icon width=16 height=16}
    [johndoe](https://twitter.com/johndoe)
    · ![Mastodon icon](images/mastodon.svg){.inline_icon width=16 height=16}
    [\@johndoe@mastodon.social](https://mastodon.social/@johndoe)
    <br>
  <small>
     Department of Something, University of Whatever
     · Funded by Grant XXXXXXXX
  </small>

+ **Chris Mungall**
  ^[✉](#correspondence)^<br>
    ![ORCID icon](images/orcid.svg){.inline_icon width=16 height=16}
    [0000-0002-6601-2165](https://orcid.org/0000-0002-6601-2165)
    · ![GitHub icon](images/github.svg){.inline_icon width=16 height=16}
    [cmungall](https://github.com/cmungall)
    <br>
  <small>
     Environmental Genomics and Systems Biology Division, Lawrence Berkeley National Laboratory, Berkeley, CA, 94720
  </small>


::: {#correspondence}
✉ — Correspondence possible via [GitHub Issues](https://github.com/cmungall/gpt-mapping-manuscript/issues)
or email to
Chris Mungall \<cjmungall@lbl.gov\>.


:::


## Abstract {.page_break_before}

Mapping...


## Introduction

The unification of diverse knowledge bases, lexicons, and ontologies necessitates the interrelation or mapping of entities. An instance of this process can be seen when merging multiple disease terminologies, where it's crucial to ascertain the equivalence of a disease concept across different vocabularies. This challenge is commonly referred to as the ontology matching problem.

The procedure of ontology matching generally employs a combination of automated processes and human intervention. The automated part usually comprises lexical matches of labels, synonyms, or other vocabulary components. This strategy can yield high recall; however, due to lexical ambiguities and homonyms, its precision may suffer depending on the sources. Consequently, a manual filtration step, usually undertaken by a domain expert, is often mandated. Nonetheless, this final filtration phase can prove laborious, as lexical methods typically generate an abundance of potential mappings.

Our team has developed a method that conducts automatic filtration and categorization of prospective mappings using large language models. We approach this as an in-context learning challenge where the model is presented with assorted concept pairs, accompanied by the correct elucidation of their relationship.

We subsequently put this methodology to the test on an anatomy ontology matching task.


The method....


## Methods

### GPT-based mapping agent

We generate a prompt according to the following template:
    

```
What is the relationship between the two specified concepts?

Give your answer in the form:

category: <one of: EXACT_MATCH, BROADER_THAN, NARROWER_THAN, RELATED_TO, DIFFERENT>
confidence: <one of: LOW, HIGH, MEDIUM>
similarities: <semicolon-separated list of similarities>
differences: <semicolon-separated list of differences>

Make use of all provided information, including the concept names, definitions, and relationships.

Examples:

{{ examples }}

Here are the two concepts:

{{ describe(conceptA) }}
{{ describe(conceptB) }}
```


We use a few-shot learning approach. Examples are provided in-context in the following form:

```
[Concept A]
id: FOO:125
name: wing
def: part of a bird that is flapped to enable flight
is_a: Limb
relationship: part_of Bird
relationship: has_part Feather

[Concept B]
id: BAR:458
name: wing
relationship: part_of Aeroplane

category: DIFFERENT
confidence: HIGH
similarities: function
differences: A is an anatomical part; B is a part of a vehicle
```

For each candidate mapping between concepts A and B, we generate a description of each concept,
incorporating key elements: name, synonyms, definition, relationships. 

The prompt is then passed to a GPT model, which generates a response. The response is parsed to retrieve
the key data model elements: category, confidence, similarities, differences.

### Example

As an example, two concepts from the fruitfly and zebrafish anatomy ontologies are candidate matches
due to sharing a lexical element (abbreviation). This is a false positive match in reality,
as the concept are entirely different.

The two concept descriptions are generated from respective ontologies as follows:

```yaml
[Concept A]
id: FBbt:00001906
name: embryonic/larval Malpighian tubule Type I cell
def: Type I cell of the embryonic/larval Malpighian tubules.
synonyms:  PC ;  embryonic/larval Malpighian tubule Type I cell ;  larval Malpighian tubule Type I cell ;  larval Malpighian tubule principal cell ; 
is_a:  embryonic/larval specialized Malpighian tubule cell ;  Malpighian tubule Type I cell ; 

[Concept B]
id: ZFA:0000320
name: caudal commissure
def: Diencephalic tract which is located in the vicinity of the dorsal diencephalon and mesencephalon and connects the pretectal nuclei. From Neuroanatomy of the Zebrafish Brain.
synonyms:  PC ;  caudal commissure ;  posterior commissure ; 
is_a:  diencephalic white matter ; 
relationship: part of synencephalon
relationship: start stage unknown
relationship: end stage adult
```

The payload for this using gpt-3.5-turbo is:

```yaml
category: DIFFERENT
confidence: HIGH
similarities: NONE
differences: A is a type of cell in the embryonic/larval Malpighian tubules; B is a diencephalic tract in the zebrafish brain.
subject: FBbt:00001906
object: ZFA:0000320
```

This is then parsed to a YAML object:

```yaml
predicate: DIFFERENT
confidence: HIGH
similarities:
  - NONE
differences:
  - A is a type of cell in the embryonic/larval Malpighian tubules
  - B is a diencephalic tract in the zebrafish brain.
```

### Implementation

We use the OAK library to binding to ontologies.

the overall framework is implemented in OntoGPT.

The input is an SSSOM file. The output is SSSOM with predicate_id filled with predicted value.

```bash
ontogpt categorize-mappings --model gpt-4 -i foo.sssom.tsv -o bar.sssom.tsv
```

### Evaluation

We evaluate against LogMap, which is one of the top-performing mappers in the OAEI.

We convert LogMap results to SSSOM [doi@10.1093/database/baac035]. (Harshad to write)

To generate anatomy test sets, we generated pairwise mappings between species-specific anatomy ontologies,
using the Uberon and CL mappings as the gold standard. i.e. if a pair of concepts are transitively linked
via Uberon or CL, then they are considered a match.

To evaluate against the gold standard we only considered "best" mappings from each method

LogMap produces a score with each mapping, so we scanned all scores to determine the optimal score threshold
in terms of accuracy (F1) (note this gives LogMap an advantage over our method, which does not produce a score).

For the MapperGPT method, we filtered any mapping that is not predicted to be EXACT.



## Results

### Task

We generated 325 candidate lexical matches between FBbt and ZFA (see methods).

We ran these through MapperGPT.

We also ran LogMap over these two ontologies.

We treat entities linked via Uberon and CL as the Gold Standard.

### Core Results

|    | method   |           f1 |        P |            R |
|---:|:---------|-------------:|---------:|-------------:|
|  0 | lexmatch |      0.34957 | 0.220217 | **0.847222** |
|  1 | logmap   |      0.48913 | 0.401786 |        0.625 |
|  2 | gpt3     |     0.435484 | 0.519231 |        0.375 |
|  3 | gpt4     | **0.651163** | **0.56** |     0.777778 |

### LogMap

LogMap returns a score rather than a binary answer - we took
the best performing cutoff:

![img](logmap-scatter-plot.pdf)

## Discussion

Unlike traditional ontology mapping tools, MapperGPT can provide narrative explanations
of why two concepts are predicted to be related in a certain way.

### Future Work

MapperGPT is expensive to run with GPT-4. We recommend its use in cases where simpler lexical methods
should suffice. We are exploring use of open models that can be executed locally.

We are planning to integrate MapperGPT into our Boomer pipeline to make BoomerGPT,
a hybrid neurosymbolic mapping tool that integrates probabilistic inference, description logic
reasoning, lexical methods, rule-based methods, and LLMs.


## Conclusions

blah


## References {.page_break_before}

<!-- Explicitly insert bibliography here -->
<div id="refs"></div>

