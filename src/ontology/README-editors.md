# EcoCore Editors Guide

These notes are for the EDITORS of ecocore.

This project uses the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit). See the ODK documentation for full details.

---

## Getting started

### Prerequisites

- [Docker](https://www.docker.com/) — required to run the ODK container
- [git](https://git-scm.com/)
- [Protege](https://protege.stanford.edu/) — for manual OWL editing

### Clone the repository

```
git clone https://github.com/EcologicalSemantics/ecocore.git
cd ecocore
```

---

## ID Ranges

All new term IDs must fall within your assigned range in:

- [`src/ontology/ecocore-idranges.owl`](ecocore-idranges.owl)

**Only use IDs within your assigned range.**

If you do not have an assigned range, contact the head curator. To configure Protege to use your range, see the [OBO Protege tutorial](https://github.com/Planteome/protege-tutorial) (section "new entities").

---

## The editors file

The file to edit is [`src/ontology/ecocore-edit.owl`](ecocore-edit.owl). Open it in Protege.

**Do NOT edit the release files in the top-level directory** (`ecocore.owl`, `ecocore.obo`, `ecocore.json`, etc.). Those are generated automatically.

---

## Adding terms

There are three ways to add terms, depending on the type of content:

### 1. Direct Protege editing (`ecocore-edit.owl`)

Use Protege for terms that do not fit a design pattern and require bespoke axiomatization. Every term must have:

- `rdfs:label` — singular, lowercase (unless a proper noun)
- `IAO:0000115` — textual definition (genus-differentia style)
- `IAO:0000119` — at least one definition source (PMID, DOI, or ISBN)
- `IAO:0000117` — your ORCID as term editor
- At least one named superclass (`SubClassOf`)

### 2. DOSDP design patterns (`src/patterns/`)

Use DOSDP for terms that follow a repeating logical pattern (e.g., trophic roles, ecological processes). Patterns live in `src/patterns/dosdp-patterns/` and data in `src/patterns/data/default/`.

**To add a term using an existing pattern:**

1. Open the relevant TSV in `src/patterns/data/default/`
2. Add a row with the new ECOCORE ID, label, definition, filler values, and your ORCID
3. Run the pattern pipeline to verify:
   ```
   cd src/ontology
   ./run.sh make PAT=true IMP=false MIR=false patterns
   ```

**Available patterns:**

| Pattern | File | Use for |
|---------|------|---------|
| `trophic_organism_by_diet` | `trophic_organism_by_diet.tsv` | Heterotrophs defined by diet process |
| `trophic_organism_by_food_taxon` | `trophic_organism_by_food_taxon.tsv` | Heterotrophs defined by food taxon |
| `autotrophic_process_by_environment` | `autotrophic_process_by_environment.tsv` | Primary production in a named environment |
| `decomposition_process_by_substrate` | `decomposition_process_by_substrate.tsv` | Decomposition of a named substrate |
| `symbiotic_process_by_symbiont_taxon` | `symbiotic_process_by_symbiont_taxon.tsv` | Symbiosis with a named taxon |

**To create a new pattern**, add a YAML file to `src/patterns/dosdp-patterns/` following the [DOSDP specification](https://github.com/INCATools/dead_simple_owl_design_patterns).

### 3. ROBOT templates (`src/templates/`)

Use ROBOT templates for annotation-heavy term groups that do not need complex OWL axioms (e.g., vocabulary terms, traits, status categories). Templates are TSV files with ROBOT column headers.

**To add a term using an existing template:**

1. Open the relevant TSV in `src/templates/`
2. Add a row with the new ECOCORE ID and annotation values
3. Rebuild the template component:
   ```
   cd src/ontology
   ./run.sh make IMP=false components/mating_systems.owl   # or whichever component
   ```

**Available templates:**

| Template | File | Use for |
|----------|------|---------|
| Mating systems | `mating_systems.tsv` | Subtypes of mating system (ECOCORE:00000062) |
| Biogeographic status | `biogeographic_status.tsv` | Range/origin status terms |
| Diel activity patterns | `diel_activity_patterns.tsv` | Crepuscular, nocturnal, diurnal, etc. |
| Oxygen tolerance | `oxygen_tolerance.tsv` | Aerobe, anaerobe subtypes |

---

## Running tests locally

All build commands run inside the ODK Docker container via the wrapper script:

```
cd src/ontology
./run.sh make test IMP=false PAT=false MIR=false
```

- `IMP=false` — skips refreshing imports (much faster)
- `PAT=false` — skips rebuilding DOSDP patterns
- `MIR=false` — skips mirroring external ontologies

To run with full imports and patterns (slower, closer to CI):

```
./run.sh make test
```

CI runs automatically on every PR and push to master. Check the build status:
[![CI](https://github.com/EcologicalSemantics/ecocore/actions/workflows/qc.yml/badge.svg)](https://github.com/EcologicalSemantics/ecocore/actions/workflows/qc.yml)

---

## Release process

> **The GitHub Release is now created automatically.** Editors only need to build the artifacts locally, commit them, and push a tag.

### Steps

1. Ensure all queued PRs are merged and CI passes on master.

2. Build the release artifacts locally:
   ```
   cd src/ontology
   ./run.sh make IMP=false PAT=false MIR=false prepare_release
   ```
   This generates `ecocore.owl`, `ecocore-full.owl`, `ecocore-base.owl`, and their `.obo`/`.json` equivalents in the top-level directory.

3. Update [`CHANGELOG.md`](../../CHANGELOG.md) with a summary of changes for this release.

4. Commit everything and push to master:
   ```
   git add ecocore.owl ecocore.obo ecocore.json \
           ecocore-full.owl ecocore-full.obo ecocore-full.json \
           ecocore-base.owl ecocore-base.obo ecocore-base.json \
           CHANGELOG.md
   git commit -m "Release vYYYY-MM-DD"
   git push origin master
   ```

5. Push a date-stamped version tag:
   ```
   git tag vYYYY-MM-DD
   git push origin vYYYY-MM-DD
   ```

6. The [release workflow](https://github.com/EcologicalSemantics/ecocore/actions/workflows/release.yml) fires automatically. It runs QC, builds fresh artifacts, and publishes the GitHub Release with all files attached.

**Rules:**
- Tag format must be `vYYYY-MM-DD` (lowercase `v` required)
- No more than one release per day
- The tag must point to a commit that has already passed CI

### OBO Foundry PURLs

After release, the following PURLs resolve automatically:

- `http://purl.obolibrary.org/obo/ecocore.owl` — always the latest release
- `http://purl.obolibrary.org/obo/ecocore/releases/YYYY-MM-DD.owl` — versioned PURL
