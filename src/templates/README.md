# ROBOT Templates

This directory contains ROBOT template files for creating new ecocore terms using a
tabular (spreadsheet-style) format. Templates are an alternative to editing
`ecocore-edit.owl` directly in Protege, and are especially well-suited for
annotation-heavy terms that share a common parent class.

## How to use

1. Open the relevant `.tsv` file in a spreadsheet editor or text editor.
2. Add a new row for each new term. Assign an ID from your personal ID range
   (see `ecocore-idranges.owl`).
3. Run the build to compile the template into OWL:

       cd src/ontology
       ./run.sh make ROBOT_ENV='ROBOT_JAVA_ARGS=-Xmx8G' components/reproductive_qualities.owl

4. The generated OWL component will be merged into the main ontology at release time.

## Files

| Template | Scope | Parent class |
|---|---|---|
| `reproductive_qualities.tsv` | Reproductive strategies and modes | PATO:0001434 (reproductive quality) |
| `mating_systems.tsv` | Mating systems (monogamy, polygyny, etc.) | ECOCORE:00000062 (mating system) |
| `biogeographic_status.tsv` | Biogeographic range status (endemic, introduced, etc.) | PCO:0000003 (population quality) |
| `diel_activity_patterns.tsv` | Diel activity patterns (nocturnal, diurnal, etc.) | PATO:0001995 (behavioral quality) |
| `oxygen_tolerance.tsv` | Oxygen tolerance strategies (aerobe, anaerobe, etc.) | OBI:0100026 (organism) |

### Notes on specific templates

- **biogeographic_status**: The `DisjointClasses(extinct, extant)` axiom cannot be expressed in ROBOT template syntax; it is retained in `ecocore-edit.owl`.
- **diel_activity_patterns**: The `crepuscular` definition was incorrectly stored in `IAO:0000117` (term editor) in `ecocore-edit.owl`; the template carries the corrected annotation in `IAO:0000115`.
- **oxygen_tolerance**: Parent class varies per row — aerobe subtypes use `ECOCORE:00000173`, anaerobe subtypes use `ECOCORE:00000172`, base terms use `OBI:0100026`.

## Column reference (ROBOT template syntax)

| Column header | ROBOT instruction | Meaning |
|---|---|---|
| `ID` | `ID` | Term IRI (e.g. `ECOCORE:00000XXX`) |
| `Label` | `A rdfs:label` | Primary term label |
| `Definition` | `A IAO:0000115` | Textual definition |
| `Definition source` | `A IAO:0000119` | Reference for definition (ISBN, URL, PMID) |
| `Editor note` | `A IAO:0000116` | Internal notes for editors |
| `Term editor` | `A IAO:0000117` | ORCID of term editor |
| `Exact synonym` | `A oio:hasExactSynonym SPLIT=\|` | Pipe-separated exact synonyms |
| `Parent class` | `SC %` | Named superclass |
