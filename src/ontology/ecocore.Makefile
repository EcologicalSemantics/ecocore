## Customize Makefile settings for ecocore
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# Override the default (None) so that ROBOT report failures block the build
REPORT_FAIL_ON = ERROR

test: sparql_test all_reports
	$(ROBOT) reason --input $(SRC) --reasoner ELK --output test.owl && rm test.owl
