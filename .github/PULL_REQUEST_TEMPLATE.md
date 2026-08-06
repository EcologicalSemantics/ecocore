# Pull request checklist

Please confirm each item before requesting review. Replace `[ ]` with `[x]` to check.

## Term IDs
- [ ] All new term IDs are within my assigned range in `src/ontology/ecocore-idranges.owl`
- [ ] No ID is reused from a previously deleted or deprecated term

## Content
- [ ] Every new term has an `IAO:0000115` definition
- [ ] Every new term has at least one reference (`IAO:0000119`) supporting the definition
- [ ] Every new term has an `IAO:0000117` term editor annotation (ORCID)
- [ ] Labels are in singular form and use lowercase (unless a proper noun)
- [ ] Exact synonyms are in the correct synonym field (not the label or comment)

## Axioms
- [ ] Every new class has at least one named superclass (`SubClassOf`)
- [ ] Equivalence axioms use only imported or pre-existing ecocore terms as components

## QC
- [ ] `make test IMP=false PAT=false` passes locally (or CI passes on this branch)
- [ ] No new `missing-definition`, `missing-contributor`, or `nolabels` violations

## Related issues
<!-- List any GitHub issues addressed by this PR (e.g. Closes #42) -->
