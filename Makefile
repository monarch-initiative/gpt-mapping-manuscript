RESULTDIR = results
DATADIR = data

TASKS = \
 fbbt-zfa \
 fbbt-wbbt \
 hsapdv-mmusdv \
 mondo-ncit-renal-subset

METHODS = lexmatch logmap gpt3 gpt4

.PHONY: all all-matches combined-matches curated-mappings combined-curated-mappings

all:
	echo "Generating all matches with the following methods: $(METHODS).."
	$(MAKE) all-matches
	echo "2/5 Generating combined results.."
	$(MAKE) combined-matches
	echo "3/5 Generating curated results"
	$(MAKE) curated-mappings
	echo "4/5 Generating combined results for curated data.."
	$(MAKE) combined-curated-mappings
	echo "5/5 Regenerate notebooks"
	$(MAKE) all-notebooks

all-matches: $(foreach method, $(METHODS), $(foreach task, $(TASKS), $(RESULTDIR)/$(method)-$(task).sssom.tsv))

combined-matches: $(MAKE) $(foreach method, $(METHODS), $(RESULTDIR)/$(method)-combined.sssom.tsv)

curated-mappings: $(foreach task, $(TASKS), $(DATADIR)/curated-$(task).sssom.tsv)

combined-curated-mappings: $(DATADIR)/curated-combined.sssom.tsv

###############################################
############ Combining results ################
###############################################

$(RESULTDIR)/%-combined.sssom.tsv:
	./util/concat-sssom.pl $(RESULTDIR)/$*-*.sssom.tsv > $@
.PRECIOUS: $(RESULTDIR)/%-combined.sssom.tsv

$(DATADIR)/%-combined.sssom.tsv:
	./util/concat-sssom.pl $(DATADIR)/$*-*.sssom.tsv > $@
.PRECIOUS: $(DATADIR)/%-combined.sssom.tsv

###############################################
############ Generate lexical matches #########
###############################################

# Dealing with MONDO NCIT subset (special case, becuase the name of the task is different)
$(RESULTDIR)/lexmatch-mondo-ncit-renal-subset.sssom.tsv: subsets/mondo-rare-renal.obo subsets/ncit-renal.obo
	runoak -i subsets/mondo-rare-renal.obo -a subsets/ncit-renal.obo lexmatch  i^mondo: @ i^ncit: -o $@

$(RESULTDIR)/lexmatch-%.sssom.tsv:
	$(eval ONT1=$(shell echo $* | cut -d- -f1))
	$(eval ONT2=$(shell echo $* | cut -d- -f2))
	$(eval DB1=$(shell echo sqlite:obo:$(ONT1)))
	$(eval DB2=$(shell echo sqlite:obo:$(ONT2)))
	runoak -i $(DB1) -a $(DB2) lexmatch  i^$(ONT1): @ i^$(ONT2): -o $@
.PRECIOUS: $(RESULTDIR)/lexmatch-%.sssom.tsv

$(RESULTDIR)/loom-%.sssom.tsv:
	$(eval ONT1=$(shell echo $* | cut -d- -f1))
	$(eval ONT2=$(shell echo $* | cut -d- -f2))
	$(eval DB1=$(shell echo sqlite:obo:$(ONT1)))
	$(eval DB2=$(shell echo sqlite:obo:$(ONT2)))
	runoak -i $(DB1) -a $(DB2) mappings -O sssom i^$(ONT1): .or i^$(ONT2) -M $(ONT2) --mapper bioportal: -o $@
.PRECIOUS: $(RESULTDIR)/loom-%.sssom.tsv

###############################################
############ Generate OntoGPT results #########
###############################################
SKIP_GPT = false

$(RESULTDIR)/gpt3-%.sssom.tsv: $(RESULTDIR)/lexmatch-%.sssom.tsv
	if [ $(SKIP_GPT) = false ]; then ontogpt categorize-mappings -i $< -o $@ --yaml-output $(RESULTDIR)/gpt3-$*.results.yaml; fi

$(RESULTDIR)/gpt4-%.sssom.tsv: $(RESULTDIR)/lexmatch-%.sssom.tsv
	if [ $(SKIP_GPT) = false ]; then ontogpt  categorize-mappings --model gpt-4 -i $< -o $@ --yaml-output $(RESULTDIR)/gpt3-$*.results.yaml; fi

###############################################
############ Generate LOGMAP results ##########
###############################################

# https://stackoverflow.com/questions/41265266/how-to-solve-inaccessibleobjectexception-unable-to-make-member-accessible-m
LOGMAP_JAR=tools/logmap-matcher-4.0.jar
RUN_LOGMAP = java --add-opens java.base/java.lang=ALL-UNNAMED -jar $(LOGMAP_JAR) MATCHER

$(RESULTDIR)/logmap/work-%/logmap2_mappings.tsv:
	$(eval ONT1=$(shell echo $* | cut -d- -f1))
	$(eval ONT2=$(shell echo $* | cut -d- -f2))
	$(MAKE) $(DATADIR)/$(ONT1).owl $(DATADIR)/$(ONT2).owl
	mkdir -p $(RESULTDIR)/logmap/work-$*/
	$(RUN_LOGMAP) file:$(PWD)/$(DATADIR)/$(ONT1).owl  file:$(PWD)/$(DATADIR)/$(ONT2).owl $(PWD)/$(RESULTDIR)/logmap/work-$* false
	test $@

# Due to only dealing with a subset of Mondo and NCIT, we have a special case here (because of the task name)
$(RESULTDIR)/logmap/work-mondo-ncit-renal-subset/logmap2_mappings.tsv: subsets/mondo-rare-renal.owl subsets/ncit-renal.owl
	mkdir -p $(RESULTDIR)/logmap/work-mondo-ncit-renal-subset/ ;\
	$(RUN_LOGMAP) file:$(PWD)/subsets/mondo-rare-renal.owl  file:$(PWD)/subsets/ncit-renal.owl $(PWD)/$(RESULTDIR)/logmap/work-mondo-ncit-renal-subset false

$(RESULTDIR)/logmap-%.sssom.tsv: $(RESULTDIR)/logmap/work-%/logmap2_mappings.tsv
	$(eval ONT1=$(shell echo $* | cut -d- -f1))
	$(eval ONT2=$(shell echo $* | cut -d- -f2))
	$(eval DB1=$(shell echo sqlite:obo:$(ONT1)))
	$(eval DB2=$(shell echo sqlite:obo:$(ONT2)))
	./util/fix-logmap.pl $< > $@.tmp && runoak -i $(DB1) -a $(DB2) fill-table $@.tmp --relation "{primary_key: subject_id, dependent_column: subject_label, relation: label}" --relation "{primary_key: object_id, dependent_column: object_label, relation: label}" --missing-value-token NONE | egrep -i '^(subject|$(ONT1).*$(ONT2))' > $@

###############################################
############ Rebuild notebooks ################
###############################################

.PHONY: notebook-% all-notebooks

notebook-%:
	cd notebooks && make Mapping-Evaluation-$*.ipynb

all-notebooks:
	$(MAKE) $(patsubst %, notebook-%, $(TASKS))
	$(MAKE) notebook-combined
	$(MAKE) content/vars.json

content/vars.json:
	python util/combine_tables.py

# NOTEBOOKS
notebooks/%:
	cd notebooks && make $*

###############################################
############ Test sets ########################
###############################################

# Instead of using the oak "mappings" command, this is using lexmatch with a strange intermedicate condition.
$(DATADIR)/curated-%.sssom.tsv:
	$(eval ONT1=$(shell echo $* | cut -d- -f1))
	$(eval ONT2=$(shell echo $* | cut -d- -f2))
	$(eval DB1=$(shell echo sqlite:obo:$(ONT1)))
	$(eval DB2=$(shell echo sqlite:obo:$(ONT2)))
	runoak -i $(DB1) -a $(DB2) -a sqlite:obo:uberon -a sqlite:obo:cl lexmatch -L $(DATADIR)/index-$*.yaml -R conf/curated-rules.yaml  i^$(ONT1): @ i^$(ONT2): -o $@

$(DATADIR)/curated-mondo-ncit-renal-subset.sssom.tsv: subsets/mondo-rare-renal.obo subsets/ncit-renal.obo
	runoak -i subsets/mondo-rare-renal.obo -a subsets/ncit-renal.obo lexmatch -L $(DATADIR)/index-mondo-ncit-renal-subset.yaml -R conf/curated-rules-mondo.yaml  i^mondo: @ i^ncit: -o $@

# Doesnt this make more sense here?
#$(DATADIR)/curated-mondo-ncit-renal-subset.sssom.tsv:
#	runoak -i sqlite:obo:mondo mappings .desc//p=i 'kidney disease' .and .desc//p=i 'hereditary disease' -O sssom -o $@


###############################################
############ Ontologies #######################
###############################################

subsets/mondo-rare-renal.obo:
	mkdir -p subsets/
	runoak -i sqlite:obo:mondo extract .desc//p=i 'kidney disease' .and .desc//p=i 'hereditary disease' -o $@

subsets/ncit-renal.obo:
	mkdir -p subsets/
	runoak -i sqlite:obo:ncit extract .desc//p=i 'Kidney Disorder' -o $@

subsets/%.owl: subsets/%.obo
	robot convert -i $< -o $@

$(DATADIR)/%.owl:
	curl -L -s http://purl.obolibrary.org/obo/$*.owl > $@

###############################################
############ Install pre-requisites ###########
###############################################

pip_uninstall:
	@read -p "This will uninstall _all_ python tools in your environment. Do you want to proceed? [Y/n] " REPLY; \
	if [ "$$REPLY" != "Y" ]; then \
		echo "Aborting."; \
		exit 1; \
	fi
	pip freeze > uninstall.txt
	pip uninstall -r uninstall.txt -y
	rm -f uninstall.txt

pip_install:
	pip install -r build/requirements.txt

LOGMAP=https://github.com/ernestojimenezruiz/logmap-matcher/releases/download/logmap-matcher-july-2021/logmap-matcher-standalone-july-2021.zip

install_logmap:
	mkdir -p tools
	mkdir -p tools/logmap
	rm -rf tools/logmap/*
	wget "$(LOGMAP)" -O tools/logmap.zip
	unzip tools/logmap.zip -d tools/logmap
	cp tools/logmap/logmap-matcher-4.0.jar $(LOGMAP_JAR)
	cp -r tools/logmap/java-dependencies tools/java-dependencies

###############################################
############# Development tools ###############
###############################################

# Section can be ignored
activate:
	conda activate manubot

ue:
	conda env update --file build/environment.yml --prune

nb:
	jupyter notebook


###############################################
############# Utilities #######################
###############################################

.PHONY: help
help:
	@echo "$$data"

define data
Usage: make [(IMP|MIR|IMP_LARGE|PAT)=(false|true)] command
----------------------------------------
	Explanation
----------------------------------------

To run the pipeline, first install pre-requisites. See below in the command reference,
but usually you would run "make pip_install install_logmap".

----------------------------------------
	Command reference
----------------------------------------

Core commands:
* task-all-combined:	Run the entire release pipeline. Use make IMP=false prepare_release to avoid rerunning the imports

Installing pre-requisites:
* pip_install: Installs are the python dependencies required by the MapperGPT pipeline
* install_logmap: Downloads the logmatch tool

endef
export data