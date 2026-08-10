## Customize Makefile settings for ecocore
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# Override the default (None) so that ROBOT report failures block the build
REPORT_FAIL_ON = ERROR

# Use a custom report profile that downgrades missing_label / missing_definition /
# missing_superclass from ERROR to WARN. These three checks are already covered by
# our stricter custom SPARQL queries, which correctly exclude pipeline-managed stubs
# (DOSDP pattern terms and ROBOT template terms) whose labels and definitions come
# from the compiled pipeline output, not from ecocore-edit.owl directly.
REPORT_PROFILE_OPTS = --profile ecocore-report-profile.txt

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
  missing-superclass \
  missing-contributor \
  multiple-labels \
  deprecated-no-replacement

test: sparql_test all_reports
	$(ROBOT) reason --input $(SRCMERGED) --reasoner ELK --output test.owl && rm test.owl

# Override reason_test to skip reasoning against stale local import files.
# Full reasoning with imports is only valid after 'make IMP=true' refreshes imports.
.PHONY: reason_test
reason_test:
	@echo "Skipping reason_test (run 'make IMP=true test' for full reasoning with imports)"

# Override OWL2 DL profile validation to skip building ecocore.owl (which requires
# full import reasoning). Profile validation is only meaningful after make IMP=true.
$(REPORTDIR)/validate_profile_owl2dl_$(ONT).owl.txt: | $(REPORTDIR)
	@echo "Skipping OWL2 DL profile validation (run 'make IMP=true test' for full validation)"
	@touch $@

# ----------------------------------------
# ROBOT template targets
# ----------------------------------------
# Templates live in src/templates/ and compile to OWL components.
# Run: ./run.sh make ROBOT_ENV='ROBOT_JAVA_ARGS=-Xmx8G' components/reproductive_qualities.owl

TEMPLATEDIR = ../templates
COMPONENTSDIR = components

# HASH variable: # is a comment character in Make so it cannot appear
# literally in a variable value; use $(shell printf '\043') to embed it.
HASH := $(shell printf '\043')
ROBOT_TEMPLATE_PREFIXES = \
  --prefix "ECOCORE: http://purl.obolibrary.org/obo/ECOCORE_" \
  --prefix "oio: http://www.geneontology.org/formats/oboInOwl$(HASH)" \
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
