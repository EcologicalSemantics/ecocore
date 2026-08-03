# EcoCore Development Process Modernization Plan

This document outlines a plan to modernize the ecocore development workflow to align with the practices used by mature OBO Foundry ontologies such as [ECTO](https://github.com/EnvironmentOntology/environmental-exposure-ontology) and [MONDO](https://github.com/monarch-initiative/mondo). It is intended as a roadmap for editors and maintainers.

---

## Current State Summary

| Area | Current Status |
|---|---|
| ODK version | v1.3.0 (outdated) |
| CI system | GitHub Actions (basic), Travis CI references still in docs |
| DOSDP patterns | 1 pattern (`abnormalAnatomicalEntity`) — not ecology-relevant |
| ROBOT templates | None |
| Components | None |
| SPARQL QC | Minimal (3 checks) |
| GitHub issue templates | None |
| Release process | Manual |
| `use_dosdps` | Inconsistent: `FALSE` in `ecocore-odk.yaml`, `true` in `project.yaml` |
| `ido_import` | Present in import files but missing from `IMPORTS` in Makefile |

---

## Priority 1: ODK Upgrade

### Goal
Upgrade from ODK v1.3.0 to the current stable release (v1.5+).

### Rationale
Both ECTO and MONDO use current ODK versions, which bring a significantly improved Makefile structure, better import handling, updated ROBOT versions, and native support for components, pattern pipelines, and automated QC profiles.

### Steps
1. Update `odk/odk.Dockerfile` (or run `odk.py update_repo`) to pull the latest ODK image.
2. Regenerate `src/ontology/Makefile` using `python3 seed-via-docker.sh -C ecocore-odk.yaml` from the updated ODK.
3. Update the container version in `.github/workflows/qc.yml` from `obolibrary/odkfull:v1.3.0` to the current release.
4. Review and reconcile `ecocore.Makefile` custom targets against the new generated Makefile to avoid conflicts.

### Reference files
- `src/ontology/ecocore-odk.yaml` — primary configuration; all ODK regeneration is driven from here
- `src/ontology/Makefile` — do not edit directly; regenerate via ODK
- `.github/workflows/qc.yml` — update container tag

---

## Priority 2: Fix Configuration Inconsistencies

### Goal
Resolve conflicts between `ecocore-odk.yaml` and `project.yaml`, and fix the missing `ido` import.

### Steps
1. In `ecocore-odk.yaml`, change `use_dosdps: FALSE` to `use_dosdps: TRUE` (or decide definitively whether DOSDP will be used — see Priority 4).
2. Add `ido` to the `import_group.products` list in `ecocore-odk.yaml` so it is consistent with the import files already present.
3. Consider whether `project.yaml` is still used or is a legacy file — if the ODK now drives everything from `ecocore-odk.yaml`, remove or clearly deprecate `project.yaml`.
4. Set `report_fail_on: ERROR` (currently `none`) to make CI actually fail on ontology quality violations.

---

## Priority 3: GitHub Actions Modernization

### Goal
Replace the minimal single-step CI workflow with a multi-job workflow modeled on ECTO and MONDO.

### Rationale
The current workflow runs only `make test IMP=false PAT=false`, which skips imports and patterns entirely. ECTO and MONDO use richer pipelines that validate the full ontology on PRs and run separate jobs for reports and release preparation.

### Steps
1. Remove all references to Travis CI from `src/ontology/README-editors.md`.
2. Rewrite `.github/workflows/qc.yml` to include:
   - A QC job that runs `make test` with imports and patterns enabled (at minimum on pushes; can be skipped for drafts).
   - A separate reporting job that generates and uploads SPARQL export TSVs as artifacts.
   - A lint/validation job using `robot report` with a stricter fail-on level.
3. Add a `.github/workflows/release.yml` workflow (modeled on MONDO) that:
   - Triggers on a version tag push (e.g., `vYYYY-MM-DD`).
   - Runs `make prepare_release` inside the ODK container.
   - Creates a GitHub Release and attaches the release artifacts automatically.
4. Add branch protection rules on `master` requiring the QC check to pass before merging.

### Suggested workflow structure
```
.github/
  workflows/
    qc.yml           # Runs on every PR and push to master
    release.yml      # Runs on vYYYY-MM-DD tag push
```

---

## Priority 4: DOSDP Pattern Library

### Goal
Develop a set of DOSDP design patterns that cover the core term-creation patterns in ecocore, replacing ad hoc term construction with systematic, template-driven axiomatization.

### Rationale
ECTO uses DOSDP patterns heavily to generate exposure and treatment terms. MONDO uses them for disease patterns. Patterns reduce inconsistency and make it easier for new editors to add terms correctly.

### Relevant ecology patterns to develop
The current `abnormalAnatomicalEntity` pattern is borrowed from uPheno and is not relevant to ecological concepts. It should be removed or replaced. New patterns to consider:

| Pattern name | Description | Key variables |
|---|---|---|
| `ecological_process` | A process occurring in an ecological context | process, environment |
| `ecological_interaction` | Interaction between two ecological roles/taxa | participant_1, participant_2, interaction_type |
| `trophic_relationship` | A predator–prey or consumer–resource relationship | consumer, resource |
| `habitat_characteristic` | A measurable property of a habitat | quality, environment |
| `disturbance_type` | A disturbance to an ecosystem | disturbance, ecosystem |
| `ecological_role` | Role played by an organism in an ecosystem | organism_type, role |

### Steps
1. Audit all existing terms in `ecocore-edit.owl` to identify recurring logical patterns.
2. For each pattern identified, create a YAML file in `src/patterns/dosdp-patterns/`.
3. Create corresponding TSV data files in `src/patterns/data/default/`.
4. Enable `use_dosdps: TRUE` in `ecocore-odk.yaml` and regenerate the Makefile.
5. Remove `abnormalAnatomicalEntity.yaml` as it is not relevant to ecocore's scope.

---

## Priority 5: ROBOT Templates

### Goal
Add ROBOT template files for term types that do not fit the DOSDP pattern model but benefit from tabular, spreadsheet-style curation (e.g., annotation-heavy metadata terms, subsets, or external mappings).

### Rationale
MONDO uses ROBOT templates alongside DOSDP patterns. Templates are easier for domain experts to edit without Protege and can be version-controlled as TSV files.

### Steps
1. Create `src/templates/` directory.
2. Identify candidate term sets: e.g., ecological roles, biome types, interaction types that are straightforwardly described.
3. Create one or more `.tsv` template files with proper ROBOT column headers.
4. Add a `robotemplate_group` entry in `ecocore-odk.yaml` pointing to `src/templates/`.
5. Regenerate the Makefile to include template build targets.

---

## Priority 6: Enhanced SPARQL QC

### Goal
Expand quality control SPARQL queries to catch domain-specific issues in ecocore.

### Current checks
```
owldef-self-reference
iri-range
label-with-iri
```

### Additional checks to add (modeled on ECTO/MONDO)
| Query | Purpose |
|---|---|
| `missing-definition` | Flag any class without a `IAO:0000115` definition |
| `missing-contributor` | Flag terms without a `dcterms:contributor` or ORCID annotation |
| `multiple-labels` | Detect terms with more than one `rdfs:label` |
| `deprecated-no-replacement` | Obsolete terms that lack `oboInOwl:replacedBy` or a comment |
| `xref-syntax` | Validate that cross-references use `DB:id` format |
| `missing-superclass` | Detect terms not placed under a named parent |

### Steps
1. Add SPARQL files to `src/sparql/` (one per check).
2. List new checks in `SPARQL_VALIDATION_CHECKS` in `ecocore.Makefile`.
3. Set `report_fail_on: ERROR` so failures block the build.

---

## Priority 7: GitHub Issue Templates and Project Management

### Goal
Add structured GitHub issue templates to guide term requests and bug reports, and introduce milestone-based release planning.

### Rationale
MONDO uses detailed issue templates and project boards to manage a high volume of community term requests. Even at smaller scale, templates reduce the back-and-forth needed to gather sufficient information.

### Steps
1. Create `.github/ISSUE_TEMPLATE/` with the following templates:
   - `new_term_request.md` — label, definition, synonyms, parent class, references (PMIDs/DOIs)
   - `term_revision.md` — existing term IRI, current content, proposed change, rationale
   - `bug_report.md` — description of the logical or structural error
2. Create a `PULL_REQUEST_TEMPLATE.md` requiring editors to confirm:
   - ID is within their assigned range
   - Definition is present
   - At least one reference is cited
   - QC check passes locally
3. Use GitHub Milestones to plan quarterly releases and tag issues accordingly.

---

## Priority 8: Release Process Automation

### Goal
Move from a fully manual release process to an automated one triggered by a Git tag.

### Current process
Editors manually run `make prepare_release`, commit, push, and then create a GitHub Release through the web interface.

### Target process (ECTO/MONDO style)
1. Editor merges all queued PRs into `master`.
2. Editor creates and pushes a date-stamped tag: `git tag vYYYY-MM-DD && git push origin vYYYY-MM-DD`.
3. The `release.yml` GitHub Actions workflow fires automatically, runs `make prepare_release` inside the ODK container, and publishes the release artifacts to GitHub Releases.
4. No manual file copying or web interface interaction is required.

---

## Priority 9: Documentation Update

### Goal
Bring `src/ontology/README-editors.md` and `CONTRIBUTING.md` up to date.

### Steps
1. **README-editors.md**:
   - Remove all Travis CI references; replace with GitHub Actions links.
   - Update the release instructions to reflect the automated tag-based process.
   - Add a section on DOSDP pattern authoring and ROBOT template editing.
   - Add a section on running `make test` locally using the ODK Docker container.
2. **CONTRIBUTING.md**:
   - Expand to match MONDO/ECTO style: include a section on ontology scope, a section on how definitions must be written (genus-differentia), and citation expectations.
   - Link to the DOSDP pattern documentation.
   - Add a checklist for editors before submitting a PR.

---

## Suggested Implementation Order

| Phase | Items | Notes |
|---|---|---|
| Phase 1 | Priority 2 (config fixes), Priority 1 (ODK upgrade) | Must come first; ODK regeneration will touch many files |
| Phase 2 | Priority 3 (GitHub Actions), Priority 6 (SPARQL QC) | CI modernization; can run in parallel |
| Phase 3 | Priority 4 (DOSDP patterns), Priority 5 (ROBOT templates) | Content work; requires editor agreement on which patterns to build |
| Phase 4 | Priority 7 (issue templates), Priority 9 (documentation) | Community-facing improvements |
| Phase 5 | Priority 8 (release automation) | Finalizes the new workflow end-to-end |

---

## Reference Repositories

- **ECTO**: https://github.com/EnvironmentOntology/environmental-exposure-ontology
- **MONDO**: https://github.com/monarch-initiative/mondo
- **ODK documentation**: https://github.com/INCATools/ontology-development-kit
- **DOSDP documentation**: https://github.com/INCATools/dead_simple_owl_design_patterns
- **ROBOT documentation**: https://robot.obolibrary.org
