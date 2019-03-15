## Customize Makefile settings for ecocore
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

test: sparql_test all_reports
	$(ROBOT) reason --input $(SRC) --reasoner ELK --output test.owl && rm test.owl
