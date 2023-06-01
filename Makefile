data/lexmatch-fbbt-zfa.sssom.tsv:
	runoak -i sqlite:obo:fbbt -a sqlite:obo:zfa lexmatch i^FBbt: @ i^ZFA: -o $@

data/curated-fbbt-zfa.sssom.tsv:
	runoak -i sqlite:obo:fbbt -a sqlite:obo:zfa -i sqlite:obo:uberon -i sqlite:obo:cl lexmatch -R conf/curated-rules.yaml  i^FBbt: @ i^ZFA: -o $@

data/lexmatch-fbbt-ncit.sssom.tsv:
	runoak -i sqlite:obo:fbbt -a sqlite:obo:ncit lexmatch i^FBbt: @ i^NCIT: -o $@

data/%.owl:
	curl -L -s http://purl.obolibrary.org/obo/$*.owl > $@

results/gpt3-%.sssom.tsv: data/lexmatch-%.sssom.tsv
	ontogpt  categorize-mappings -i ../gpt-mapping-manuscript/data/lexmatch-fbbt-zfa.sssom.tsv -o $@

results/gpt4-%.sssom.tsv: data/lexmatch-%.sssom.tsv
	ontogpt  categorize-mappings --model gpt-4 -i ../gpt-mapping-manuscript/data/lexmatch-fbbt-zfa.sssom.tsv -o $@

# https://stackoverflow.com/questions/41265266/how-to-solve-inaccessibleobjectexception-unable-to-make-member-accessible-m
run-logmap:
	java --add-opens java.base/java.lang=ALL-UNNAMED -jar  tools/logmap-matcher-standalone-july-2021/logmap-matcher-4.0.jar MATCHER file:$(PWD)/data/zfa.owl  file:$(PWD)/data/fbbt.owl   $(PWD)/results/logmap/ false

# ./util/fix-logmap.pl results/logmap/logmap2_mappings.tsv > z
# zfa -a $db/fbbt.db fill-table z --relation "{primary_key: subject_id, dependent_column: subject_label, relation: label}" --relation "{primary_key: object_id, dependent_column: object_label, relation: label}" --missing-value-token NONE | egrep 'FBbt.*ZFA'

activate:
	conda activate manubot

nb:
	jupyter notebook
