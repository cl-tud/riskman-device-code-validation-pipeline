# Riskman Device Code Validation Pipeline

This repo contains binaries and short/full versions of ontologies and SHACL constraints for Riskman device code validation.

## Inputs

- `inputs/imdrf_ontology_short.ttl` (full: `imdrf_ontology.ttl`)  
- `inputs/gmdn_emdn_fullmapping1_short.ttl` (full: `gmdn_emdn_fullmapping1.ttl`)  
- `inputs/riskman-ontology.ttl`  
- `inputs/riskman-code-plugin.ttl`  
- `inputs/test-abox.ttl`  
- `inputs/constraints_emdn_fullmapping1_short.ttl` (full: `constraints_emdn_fullmapping1.ttl`)  

## Makefile Targets

- `make` or `make all`  
  Merge all ontologies + ABox, run reasoner, then SHACL validation.

- `make validate`  
  Run SHACL validation on the realized ontology (`realized.ttl`).

- `make clean`  
  Remove intermediate files (`merged.ttl`, `realized.ttl`).

## Workflow

1. Merge input files → `merged.ttl`  
2. Reason over `merged.ttl` → `realized.ttl`  
3. Validate `realized.ttl` with SHACL constraints  

## Notes

- Short and full versions of ontologies and constraints are provided for quick testing or full detail.

