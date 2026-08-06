# Contributing to EcoCore

Thank you for your interest in contributing to EcoCore (Ontology of Core Ecological Entities). This guide explains how to request new terms, report errors, and submit changes.

---

## Scope

EcoCore represents core ecological entities — concepts that are:

- **Ecological** in nature: trophic roles, ecological processes, interaction types, life history traits, habitat characteristics, biogeographic status
- **Missing or too coarse** in existing OBO ontologies (ENVO, GO, PATO, PCO, etc.)
- **Reusable** across ecological databases, trait repositories, and knowledge graphs

Before contributing a term, check whether it already exists in EcoCore or in a related OBO ontology:
- [EcoCore in OLS](https://www.ebi.ac.uk/ols4/ontologies/ecocore)
- [ENVO](https://www.ebi.ac.uk/ols4/ontologies/envo), [GO](https://www.ebi.ac.uk/ols4/ontologies/go), [PATO](https://www.ebi.ac.uk/ols4/ontologies/pato), [PCO](https://www.ebi.ac.uk/ols4/ontologies/pco)

If the concept exists elsewhere in OBO, EcoCore should import or reference it rather than duplicate it.

---

## How to contribute

### Requesting a new term

Open a [New Term Request](https://github.com/EcologicalSemantics/ecocore/issues/new?template=new_term_request.md) issue and fill in all fields:

- **Label** — singular form, lowercase (e.g., `predator`, `herbivory`)
- **Definition** — genus-differentia format (see below)
- **Parent class** — most specific existing term this falls under
- **References** — at least one peer-reviewed source (PMID, DOI, or ISBN)
- **Justification** — why this term belongs in EcoCore specifically

### Reporting an error

Open a [Bug Report](https://github.com/EcologicalSemantics/ecocore/issues/new?template=bug_report.md) describing the logical, structural, or annotation error.

### Proposing a change to an existing term

Open a [Term Revision Request](https://github.com/EcologicalSemantics/ecocore/issues/new?template=term_revision.md) with the current and proposed content.

---

## Definition style

All definitions must follow the **genus-differentia** pattern:

> A [parent class] that [differentiating characteristics].

Good examples:
- "A heterotroph that obtains nutrients by consuming plant material."
- "A trophic process in which an organism obtains energy from dead organic matter."

Avoid:
- Circular definitions that restate the label
- Definitions that reference the label (the definition must be intelligible on its own)
- Vague phrases like "related to" or "involved in"

---

## Citation requirements

Every term definition must be supported by at least one peer-reviewed reference:

- Use PubMed IDs where possible: `PMID:12345678`
- For books: ISBN in the form `ISBN:978-...`
- For DOIs: `https://doi.org/10.xxxx/...`

References go in the `IAO:0000119` (definition source) annotation, not in comments.

---

## Editor checklist (before submitting a PR)

Use the [PR template](.github/PULL_REQUEST_TEMPLATE.md) to confirm each item. Key requirements:

- [ ] All new term IDs are within your assigned range in `ecocore-idranges.owl`
- [ ] No ID is reused from a deleted or deprecated term
- [ ] Every new term has an `IAO:0000115` definition
- [ ] Every new term has at least one `IAO:0000119` reference
- [ ] Every new term has an `IAO:0000117` term editor annotation (your ORCID)
- [ ] Labels are in singular form and lowercase (unless a proper noun)
- [ ] Every new class has at least one named superclass
- [ ] `make test IMP=false PAT=false` passes locally (or CI passes on this branch)

---

## Editing methods

There are three ways to add terms (described in full in [`src/ontology/README-editors.md`](src/ontology/README-editors.md)):

1. **Protege** — for terms requiring bespoke OWL axioms; edit `src/ontology/ecocore-edit.owl`
2. **DOSDP patterns** — for terms that follow a repeating logical pattern; add a row to `src/patterns/data/default/<pattern>.tsv`
3. **ROBOT templates** — for annotation-heavy vocabulary terms; add a row to `src/templates/<template>.tsv`

---

## Questions

For questions about scope, definitions, or the submission process, open a [GitHub issue](https://github.com/EcologicalSemantics/ecocore/issues) or email the maintainers listed in the ontology metadata.
