OBO=http://purl.obolibrary.org/obo
ONT=ecocore
BASE=$(OBO)/$(ONT)
SRC=$(ONT)-edit.owl
RELEASEDIR=../..
ROBOT= robot
OWLTOOLS= owltools
USECAT= --use-catalog

all: all_imports $(ONT).owl # removed $(ONT).obo 
test: all

# Below, modifed *{owl,obo} to *owl and removed $(ONT).obo wherever $(ONT).owl occurs
prepare_release: all
	cp $(ONT).owl $(RELEASEDIR) &&\
	mkdir -p $(RELEASEDIR)/imports &&\
	cp imports/*owl $(RELEASEDIR)/imports &&\
	git add $(RELEASEDIR)/imports/*owl &&\
	(test -f subsets/*owl && cp subsets/*owl $(RELEASEDIR)/subsets && git add $(RELEASEDIR)/subsets/* || echo "no subsets") &&\
	echo "Release files are now in $(RELEASEDIR) - now you should commit, push and make a release on github"

$(ONT).owl: $(SRC)
	$(ROBOT)  reason -i $< -r ELK relax reduce -r ELK annotate -V $(BASE)/releases/`date +%Y-%m-%d`/$(ONT).owl -o $@
$(ONT).obo: $(ONT).owl
	$(ROBOT) convert -i $< -f obo -o $(ONT).obo.tmp && mv $(ONT).obo.tmp $@


IMPORTS = pco ro bfo pato envo chebi go uberon po iao sdgio nbo ido
IMPORTS_OWL = $(patsubst %, imports/%_import.owl,$(IMPORTS)) #$(patsubst %, imports/%_import.obo,$(IMPORTS))

# Make this target to regenerate ALL
all_imports: $(IMPORTS_OWL)

# Use ROBOT, driven entirely by terms lists NOT from source ontology
imports/%_import.owl: mirror/%.owl imports/%_terms.txt
	$(ROBOT) extract -i $< -T imports/$*_terms.txt --method BOT -O $(BASE)/$@ -o $@
.PRECIOUS: imports/%_import.owl

imports/%_import.obo: imports/%_import.owl
	$(OWLTOOLS) $(USECAT) $< -o -f obo $@


# clone remote ontology locally, perfoming some excision of relations and annotations
mirror/%.owl: $(SRC)
	$(OWLTOOLS) $(OBO)/$*.owl --remove-annotation-assertions -l -s -d --remove-dangling-annotations  -o $@
.PRECIOUS: mirror/%.owl

mirror/ro.owl: mirror/ro-relations.owl mirror/ro-classes.owl
	$(OWLTOOLS) $^ --merge-support-ontologies -o $@
mirror/ro.owl:
	$(OWLTOOLS) $(OBO)/ro.owl --merge-imports-closure -o $@
.PRECIOUS: mirror/ro.owl

mirror/ro-relations.owl: ecocore-edit.owl
	$(OWLTOOLS) $(OBO)/ro.owl --merge-imports-closure --remove-tbox --remove-dangling -o $@
mirror/ro-classes.owl: ecocore-edit.owl
	$(OWLTOOLS) $(OBO)/ro.owl --merge-imports-closure --make-subset-by-properties -f // --remove-external-classes -k RO --remove-annotation-assertions -l -s -d  -o $@

mirror/sdgio.owl: $(SRC)
	$(OWLTOOLS) http://purl.unep.org/sdg/sdgio.owl --remove-annotation-assertions -l -s -d --remove-dangling-annotations  -o $@
.PRECIOUS: mirror/sdgio.owl
	
# Release routines 

release: $(ONT).owl # disabled $(ONT).obo
	cp $^ $(RELEASEDIR) && cp imports/* $(RELEASEDIR)/imports
