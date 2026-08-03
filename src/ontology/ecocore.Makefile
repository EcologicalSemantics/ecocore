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
