# Changelog

All notable changes to EcoCore are documented here.
Releases are tagged `vYYYY-MM-DD` and published on [GitHub Releases](https://github.com/EcologicalSemantics/ecocore/releases).

---

## Unreleased

### Infrastructure
- Upgraded ODK to v1.6.1
- Modernized GitHub Actions CI (multi-job QC + reporting workflow)
- Added automated release workflow triggered by version tags
- Added four DOSDP design patterns: `trophic_organism_by_diet`, `trophic_organism_by_food_taxon`, `autotrophic_process_by_environment`, `decomposition_process_by_substrate`, `symbiotic_process_by_symbiont_taxon`
- Added ROBOT template pipeline for annotation-heavy term groups: mating systems, biogeographic status, diel activity patterns, oxygen tolerance
- Expanded SPARQL QC to 15 checks (added `missing-definition`, `missing-superclass`, `missing-contributor`, `multiple-labels`, `deprecated-no-replacement`, and others)
- Added GitHub issue templates (new term request, term revision, bug report) and PR checklist

### New terms
- Terrestrial primary production (ECOCORE:00000183)
- Marine primary production (ECOCORE:00000184)
- Marine benthic primary production (ECOCORE:00000185)
- Litter decomposition (ECOCORE:00000186)
- Mycorrhizal symbiosis (ECOCORE:00000188)
- Nitrogen-fixing symbiosis (ECOCORE:00000189)
- Coral-zooxanthellae symbiosis (ECOCORE:00000190)

---

## How to create a release

1. Ensure all PRs for the release are merged into `master` and CI passes.
2. Run the release build locally:
   ```
   cd src/ontology
   ./run.sh make IMP=false PAT=false MIR=false prepare_release
   ```
   Or without Docker if ROBOT is installed locally:
   ```
   cd src/ontology
   make IMP=false PAT=false MIR=false prepare_release
   ```
3. Commit the updated release files:
   ```
   git add ecocore.owl ecocore.obo ecocore.json \
           ecocore-full.owl ecocore-full.obo ecocore-full.json \
           ecocore-base.owl ecocore-base.obo ecocore-base.json
   git commit -m "Release vYYYY-MM-DD"
   git push origin master
   ```
4. Update `CHANGELOG.md` with a summary of changes for this release and commit.
5. Push a date-stamped tag:
   ```
   git tag vYYYY-MM-DD
   git push origin vYYYY-MM-DD
   ```
6. The [release workflow](https://github.com/EcologicalSemantics/ecocore/actions/workflows/release.yml) fires automatically, runs QC, builds artifacts, and publishes the GitHub Release.

---

## Past releases

See [GitHub Releases](https://github.com/EcologicalSemantics/ecocore/releases) for the full list of tagged releases and their attached files.
