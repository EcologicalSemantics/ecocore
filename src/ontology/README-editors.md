These notes are for the EDITORS of ecocore

This project uses the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit). See the ODK documentation for full details.

For more details on ontology management, please see the [OBO tutorial](https://github.com/jamesaoverton/obo-tutorial) or the [Protege Planteome Tutorial](https://github.com/Planteome/protege-tutorial)

## Editors Version

Make sure you have an ID range in the [idranges file](ecocore-idranges.owl)

If you do not have one, get one from the head curator.

The editors version is [ecocore-edit.owl](ecocore-edit.owl)

** DO NOT EDIT ecocore.obo OR ecocore.owl in the top level directory **

[../../ecocore.owl] is the release version

To edit, open the file in Protege. First make sure you have the repository cloned, see [the GitHub project](https://github.com/EcologicalSemantics/an-ontology-of-core-ecological-entities) for details.

## ID Ranges

These are stored in the file

 * [ecocore-idranges.owl](ecocore-idranges.owl)

** ONLY USE IDs WITHIN YOUR RANGE!! **

If you have only just set up this repository, modify the idranges file
and add yourself or other editors. Note Protege does not read the file
- it is up to you to ensure correct Protege configuration.


## Setting ID ranges in Protege

We aim to put this up on the technical docs for OBO on http://obofoundry.org/

For now, consult the [Protege Planteome Tutorial](https://github.com/Planteome/protege-tutorial/blob/master/presentations/protege_planteome_tutorial.doc?raw=true) and look for the section "new entities"


## Release Manager notes

You should only attempt to make a release AFTER the edit version is
committed and pushed, and the GitHub Actions CI passes.

### Running the build locally

All build commands should be run inside the ODK Docker container using the wrapper script:

    cd src/ontology
    ./run.sh make test

If the test passes, prepare the release:

    ./run.sh make prepare_release

This generates derived files such as ecocore.owl and ecocore.obo and places
them in the top level (../..). The versionIRI will be added.

Commit and push these files.

    git commit -a -m "YYYY-MM-DD release"
    git push origin master

### Creating a GitHub Release

IMMEDIATELY AFTERWARDS (do *not* make further modifications) create a date-stamped tag:

    git tag vYYYY-MM-DD
    git push origin vYYYY-MM-DD

The value of the tag MUST be `vYYYY-MM-DD`. The initial lowercase "v" is REQUIRED.
The YYYY-MM-DD *must* match what is in the versionIRI of the derived ecocore.owl
(data-version in ecocore.obo).

Then go to https://github.com/EcologicalSemantics/ecocore/releases and create a new
release from the tag. The release title should be YYYY-MM-DD, optionally followed
by a brief description (e.g. "January release").

__IMPORTANT__: NO MORE THAN ONE RELEASE PER DAY.

The PURLs are already configured to pull from github. This means that
BOTH ontology purls and versioned ontology purls will resolve to the
correct ontologies.

 * http://purl.obolibrary.org/obo/ecocore.owl — current ontology PURL
 * http://purl.obolibrary.org/obo/ecocore/releases/YYYY-MM-DD.owl — versioned PURL

For questions email obo-admin AT obofoundry.org

# GitHub Actions Continuous Integration

CI runs automatically on every push and pull request to master.

Check the build status here: [![CI](https://github.com/EcologicalSemantics/ecocore/actions/workflows/qc.yml/badge.svg)](https://github.com/EcologicalSemantics/ecocore/actions/workflows/qc.yml)

The workflow runs two jobs:
- **Ontology QC** — runs `make test` (reasoning + SPARQL checks + ROBOT report) on every PR and push
- **Generate reports** — generates and archives SPARQL export TSVs on pushes to master only

