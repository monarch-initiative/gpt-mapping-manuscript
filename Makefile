w1 = $(word 1,$(subst -, ,$1))
w2 = $(word 2,$(subst -, ,$1))
ONT1 = $(call w1,$*)
ONT2 = $(call w2,$*)
DB1 = sqlite:obo:$(call w1,$*)
DB2 = sqlite:obo:$(call w2,$*)
RESULTDIR = results

EXTRA = -a sqlite:obo:uberon -a sqlite:obo:cl

TASKS = \
 fbbt-zfa \
 fbbt-wbbt \
 hsapdv-mmusdv \
 mondo-ncit-renal-subset

METHODS = lexmatch logmap gpt3 gpt4

all: task-all-combined

task-all-%: $(RESULTDIR)/logmap-%.sssom.tsv $(RESULTDIR)/lexmatch-%.sssom.tsv $(RESULTDIR)/gpt3-%.sssom.tsv $(RESULTDIR)/gpt4-%.sssom.tsv  $(RESULTDIR)/lexmatch-%.sssom.tsv data/curated-%.sssom.tsv
	echo $(RESULTDIR)/logmap-$*.sssom.tsv

data/%.owl:
	curl -L -s http://purl.obolibrary.org/obo/$*.owl > $@

$(RESULTDIR)/%-combined.sssom.tsv:
	./util/concat-sssom.pl $(RESULTDIR)/$*-*.sssom.tsv > $@
.PRECIOUS: $(RESULTDIR)/%-combined.sssom.tsv

data/%-combined.sssom.tsv:
	./util/concat-sssom.pl data/$*-*.sssom.tsv > $@
.PRECIOUS: data/%-combined.sssom.tsv

# special cases:

DISEASE_RENAL_INPUTS = -i data/mondo-hededitary-kidney.obo -a data/ncit-kidney-disorder.obo
$(RESULTDIR)/lexmatch-%-renal-subset.sssom.tsv:
	runoak $(DISEASE_RENAL_INPUTS)  lexmatch  i^$(ONT1): @ i^$(ONT2): -o $@

data/curated-%-renal-subset.sssom.tsv:
	runoak $(DISEASE_RENAL_INPUTS) lexmatch -L data/index-mondo-ncit-renal-subset.yaml -R conf/curated-rules-mondo.yaml  i^$(ONT1): @ i^$(ONT2): -o $@

$(RESULTDIR)/logmap/work-%-renal-subset/logmap2_mappings.tsv:
	mkdir -p $(RESULTDIR)/logmap/work-$*/ ;\
	$(RUN_LOGMAP) file:$(PWD)/subsets/mondo-rare-renal.owl  file:$(PWD)/subsets/ncit-renal.owl $(PWD)/$(RESULTDIR)/logmap/work-$*-renal-subset false

# generic anatomy cases

$(RESULTDIR)/lexmatch-%.sssom.tsv:
	runoak -i $(DB1) -a $(DB2) lexmatch  i^$(ONT1): @ i^$(ONT2): -o $@
.PRECIOUS: $(RESULTDIR)/lexmatch-%.sssom.tsv

$(RESULTDIR)/loom-%.sssom.tsv:
	runoak -i $(DB1) -a $(DB2) mappings -O sssom i^$(ONT1): .or i^$(ONT2) -M $(ONT2) --mapper bioportal: -o $@
.PRECIOUS: $(RESULTDIR)/loom-%.sssom.tsv


data/curated-%.sssom.tsv:
	runoak -i $(DB1) -a $(DB2) $(EXTRA) lexmatch -L data/index-$*.yaml -R conf/curated-rules.yaml  i^$(ONT1): @ i^$(ONT2): -o $@

$(RESULTDIR)/gpt3-%.sssom.tsv: $(RESULTDIR)/lexmatch-%.sssom.tsv
	ontogpt categorize-mappings -i $< -o $@ --yaml-output $(RESULTDIR)/gpt3-%.results.yaml

$(RESULTDIR)/gpt4-%.sssom.tsv: $(RESULTDIR)/lexmatch-%.sssom.tsv
	ontogpt  categorize-mappings --model gpt-4 -i $< -o $@ --yaml-output $(RESULTDIR)/gpt3-%.results.yaml

# https://stackoverflow.com/questions/41265266/how-to-solve-inaccessibleobjectexception-unable-to-make-member-accessible-m
RUN_LOGMAP = java --add-opens java.base/java.lang=ALL-UNNAMED -jar  tools/logmap-matcher-standalone-july-2021/logmap-matcher-4.0.jar MATCHER

$(RESULTDIR)/logmap/work-%/logmap2_mappings.tsv:
	mkdir -p $(RESULTDIR)/logmap/work-$*/ ;\
	$(RUN_LOGMAP) file:$(PWD)/data/$(ONT1).owl  file:$(PWD)/data/$(ONT2).owl $(PWD)/$(RESULTDIR)/logmap/work-$* false

$(RESULTDIR)/logmap-%.sssom.tsv: ./$(RESULTDIR)/logmap/work-%/logmap2_mappings.tsv
	./util/fix-logmap.pl $< > $@.tmp && runoak -i $(DB1) -a $(DB2) fill-table $@.tmp --relation "{primary_key: subject_id, dependent_column: subject_label, relation: label}" --relation "{primary_key: object_id, dependent_column: object_label, relation: label}" --missing-value-token NONE | egrep -i '^(subject|$(ONT1).*$(ONT2))' > $@


notebook-%:
	cd notebooks && make Mapping-Evaluation-$*.ipynb

all-notebooks: notebook-combined $(patsubst %, notebook-%, $(TASKS)) vars

vars:
	python util/combine_tables.py

# NOTEBOOKS
notebooks/%:
	cd notebooks && make $*


# ==
# TEST SETS
# ==

subsets/mondo-rare-renal.obo:
	runoak -i sqlite:obo:mondo extract .desc//p=i 'kidney disease' .and .desc//p=i 'hereditary disease' -o $@

subsets/ncit-renal.obo:
	runoak -i sqlite:obo:ncit extract .desc//p=i 'Kidney Disorder' -o $@

subsets/%.owl: subsets/%.obo
	robot convert -i $< -o $@

activate:
	conda activate manubot

ue:
	conda env update --file build/environment.yml --prune

nb:
	jupyter notebook
