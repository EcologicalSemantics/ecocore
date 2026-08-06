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

ROBOT_TEMPLATE_PREFIXES = \
  --prefix "ECOCORE: http://purl.obolibrary.org/obo/ECOCORE_" \
  --prefix "oio: http://www.geneontology.org/formats/oboInOwl#" \
  --prefix "IAO: http://purl.obolibrary.org/obo/IAO_" \
  --prefix "PATO: http://purl.obolibrary.org/obo/PATO_" \
  --prefix "PCO: http://purl.obolibrary.org/obo/PCO_" \
  --prefix "OBI: http://purl.obolibrary.org/obo/OBI_"

$(COMPONENTSDIR)/reproductive_qualities.owl: $(TEMPLATEDIR)/reproductive_qualities.tsv | $(COMPONENTSDIR)
	$(ROBOT) template --template $< $(ROBOT_TEMPLATE_PREFIXES) \
	  --ontology-iri "$(ONTBASE)/components/reproductive_qualities.owl" \
	  annotate --ontology-iri "$(ONTBASE)/components/reproductive_qualities.owl" \
	  --output $@

$(COMPONENTSDIR)/mating_systems.owl: $(TEMPLATEDIR)/mating_systems.tsv | $(COMPONENTSDIR)
	$(ROBOT) template --template $< $(ROBOT_TEMPLATE_PREFIXES) \
	  --ontology-iri "$(ONTBASE)/components/mating_systems.owl" \
	  annotate --ontology-iri "$(ONTBASE)/components/mating_systems.owl" \
	  --output $@

$(COMPONENTSDIR)/biogeographic_status.owl: $(TEMPLATEDIR)/biogeographic_status.tsv | $(COMPONENTSDIR)
	$(ROBOT) template --template $< $(ROBOT_TEMPLATE_PREFIXES) \
	  --ontology-iri "$(ONTBASE)/components/biogeographic_status.owl" \
	  annotate --ontology-iri "$(ONTBASE)/components/biogeographic_status.owl" \
	  --output $@

$(COMPONENTSDIR)/diel_activity_patterns.owl: $(TEMPLATEDIR)/diel_activity_patterns.tsv | $(COMPONENTSDIR)
	$(ROBOT) template --template $< $(ROBOT_TEMPLATE_PREFIXES) \
	  --ontology-iri "$(ONTBASE)/components/diel_activity_patterns.owl" \
	  annotate --ontology-iri "$(ONTBASE)/components/diel_activity_patterns.owl" \
	  --output $@

$(COMPONENTSDIR)/oxygen_tolerance.owl: $(TEMPLATEDIR)/oxygen_tolerance.tsv | $(COMPONENTSDIR)
	$(ROBOT) template --template $< $(ROBOT_TEMPLATE_PREFIXES) \
	  --ontology-iri "$(ONTBASE)/components/oxygen_tolerance.owl" \
	  annotate --ontology-iri "$(ONTBASE)/components/oxygen_tolerance.owl" \
	  --output $@

.PHONY: all_templates
all_templates: $(COMPONENTSDIR)/reproductive_qualities.owl \
               $(COMPONENTSDIR)/mating_systems.owl \
               $(COMPONENTSDIR)/biogeographic_status.owl \
               $(COMPONENTSDIR)/diel_activity_patterns.owl \
               $(COMPONENTSDIR)/oxygen_tolerance.owl
