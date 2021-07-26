[![Build Status](https://travis-ci.org/EcologicalSemantics/ecocore.svg?branch=master)](https://travis-ci.org/EcologicalSemantics/ecocore)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.846451.svg)](https://zenodo.org/record/846451)

# ecoCore: An ontology of core ecological entities
## In brief


Key|Value
---|---
Title | Ecology Core Ontology
Home page | https://github.com/EcologicalSemantics/ecocore 
Main contacts | [A Thesen](http://orcid.org/0000-0002-2908-3327) @diatomsRcool & [PL Buttigieg](http://orcid.org/0000-0002-4366-3088) @pbuttigieg
Discussion mailing-list | [click here](mailto:ecology-core-ontology@googlegroups.com)
Forum | https://groups.google.com/d/forum/ecology-core-ontology 
Issue tracker link | https://github.com/EcologicalSemantics/ecocore/issues 
 
## About
This ontology aims to provide core terms for ecological entities at the organism level, such as ecological functions (for predators, prey, etc), food webs, and ecological interactions. Through ECOCORE, we look forward to facilitating a standard vocabulary for the ecological community, a need expressed repeatedly over the past few years at workshops focused on ecological, environmental, and population-based semantics.  We're working closely with the [Environment Ontology (ENVO)](http://www.obofoundry.org/ontology/envo.html), [Population and Community Ontology (PCO)](http://www.obofoundry.org/ontology/pco.html), the [Ontology of Biological Attributes (OBA)](www.obofoundry.org/ontology/oba.html), and the [Neuro Behavior Ontology (NBO)](http://www.obofoundry.org/ontology/nbo.html) to build an interoperating resource. 

Working in ecological semantics? Please join ECOCORE's efforts by sending an e-mail [via this link](mailto:ecology-core-ontology@googlegroups.com). 

## What terms are appropriate for ecocore?
Ecocore contains subclasses of organism (OBI:0100026), organismal entity (PCO:0000031), biological process (GO:0008150), and organismal quality (PATO:0001995). All material entities, processes, and qualities in ecocore can be applied to a single organism, such as "autotroph" or "carnivory". Terms that are applied to populations or communities should be added to PCO. Organismal qualities that are "EQ style" such as femur length or fur color should be added to OBA.

## Versions

Alpha release online. Some minor bugs, but content is available.

### Stable release versions

The latest version of the ontology can always be found at:
http://purl.obolibrary.org/obo/ecocore.owl


### Editors' version

Editors of this ontology should use the edit version, [src/ontology/ecocore-edit.owl](src/ontology/ecocore-edit.owl)

# Requests for new content or revision

Please use this GitHub repository's [Issue tracker](https://github.com/EcologicalSemantics/an-ontology-of-core-ecological-entities/issues) to request new terms/classes or report errors or specific concerns related to the ontology.

# Making a New Release
There are three major steps involved in creating a new release:

Preparation 1. Make sure that all pull requests that are supposed to be merged are merged 2. Make sure that all changes to master are committed to Github (git status should say that there are no modified files) 3. Wait for the travis QC to finish 4. On you local machine, go to the master branch and run git pull to ensure that all your remote changes are available locally. 5. Make sure you have the latest ODK installed by running docker pull obolibrary/odkfull

Building the ontology 

1. Open a command line terminal window and navigate to the src/ontology directory (cd myecocoredir/src/ontology) 

2. Create a new branch (ecocore-release-20200131 or similar) 

3. If you have recently modified your patterns, run sh run.sh make IMP=false patterns once. This will be run again in the next step, but there is a bit of a bug in the ODK (as of January 2020) that it does not understand to look for imported terms in pattern that have just been added. 

4. Run the build script: sh run.sh make prepare_release -B. This command will compile the patterns, refresh the imports and build the ontology release files. Note that this step can take between 45 and 90 minutes - so make sure you do it over night or befor you go to the gym. 

5. If everything went well, you should see the following output on your machine. Release files are now in ../.. - now you should commit, push and make a release on github

6. Open the file myecocorerdir/ecocore.owl in Protege and sanity check for classes with missing labels (on the top level of the hierarchy) and general weirdnesses. In particular, you want to know wether your latest changes to pattern are what you expected. 

7. If it looks sane, (go to the commit everything to the new branch you have created, push and create a pull request. Wait for travis to run one last time, but that should not reveal surprises. 

8. In an ideal world, let at least one other person sanity check the ecocore release. A good file to sanity check is ecocore-base.obo, and perhaps even ecocore.obo: they are easy to review. 

9. Merge the changes into master. 

10. Delete the branch.

Creating a GitHub release 1. Go to ecocore releases on GitHub, click "Draft new release" 2. As the tag version you need to choose the date on which your ontologies were build. You can find this, for example, by looking at the ecocore.obo file and check the data-version: property. The date needs to be prefixed with a v, so, for example v2020-02-06. 3. You can write whatever you want in the release title, but I typically write the date again. The description underneath should contain a concise list of changes or term additions - Chris has a whole philosophy on this. For now, I recommend you to simply summarising the changed, in particular, which terms have been added or removed. 4. Click "Publish release". Done.

Cleaning the repo 1. Delete the branch locally. 2. Do a Git pull on the master branch. 3. Go to each issue that has been resolved by the most recent PR and tag the PR in a comment. Then close the issue.

# Acknowledgements

The first version of ECOCORE was built at the NSF-funded [ClearEarth Hackathon](http://instaar.colorado.edu/~jenkinsc/postings/BioHackathon/), organised by Chris Jenkins and [Anne Thesen](http://orcid.org/0000-0002-2908-3327), with input from ecologists, ontologists, and experts in natural language processing. The ontology was seeded with lists of terms generated as part of the hackathon.

This ontology repository was created using the [ontology starter kit](https://github.com/INCATools/ontology-starter-kit) then updated to the ontology development kit on 2020-03-15.
