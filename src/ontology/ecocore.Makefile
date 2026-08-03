## Customize Makefile settings for ecocore
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# Override the default (None) so that ROBOT report failures block the build
REPORT_FAIL_ON = ERROR

# Expanded SPARQL validation checks (modeled on ECTO/MONDO)
# Each name here must have a corresponding <name>-violation.sparql in src/sparql/
SPARQL_VALIDATION_CHECKS = \
  owldef-self-reference \
  iri-range \
  label-with-iri \
  multiple-replaced_by \
  dc-properties \
  nolabels \
  obsolete \
  trailing-whitespace \
  redundant-subClassOf \
  xref-syntax \
  missing-definition \
  missing-superclass

test: sparql_test all_reports
	$(ROBOT) reason --input $(SRC) --reasoner ELK --output test.owl && rm test.owl

# ----------------------------------------
# ROBOT template targets
# ----------------------------------------
# Templates live in src/templates/ and compile to OWL components.
# Run: ./run.sh make ROBOT_ENV='ROBOT_JAVA_ARGS=-Xmx8G' components/reproductive_qualities.owl

TEMPLATEDIR = ../templates
COMPONENTSDIR = components

$(COMPONENTSDIR)/reproductive_qualities.owl: $(TEMPLATEDIR)/reproductive_qualities.tsv | $(COMPONENTSDIR)
	$(ROBOT) template --template $< \
	  --prefix "ECOCORE: http://purl.obolibrary.org/obo/ECOCORE_" \
	  --prefix "oio: http://www.geneontology.org/formats/oboInOwl#" \
	  --prefix "IAO: http://purl.obolibrary.org/obo/IAO_" \
	  --prefix "PATO: http://purl.obolibrary.org/obo/PATO_" \
	  --ontology-iri "$(ONTBASE)/components/reproductive_qualities.owl" \
	  annotate --ontology-iri "$(ONTBASE)/components/reproductive_qualities.owl" \
	  --output $@

.PHONY: all_templates
all_templates: $(COMPONENTSDIR)/reproductive_qualities.owl
