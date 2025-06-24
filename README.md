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

## Plugin ontology
Note that this approach requires a plugin ontology, introducing additional Riskman classes and properties, contained in the [inputs/riskman-code-plugin.ttl](inputs/riskman-code-plugin.ttl). The ontology looks as follows:

```
@prefix : <https://w3id.org/riskman/ontology#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@base <https://w3id.org/riskman/ontology#> .
                              

#################################################################
#    Object Properties
#################################################################

###  https://w3id.org/riskman/ontology#hasDeviceCode
:hasDeviceCode rdf:type owl:ObjectProperty ;
        rdfs:domain :RMF ;
        rdfs:range :DeviceCode ;
        rdfs:label "has device code" .


###  https://w3id.org/riskman/ontology#hasControlledRisk
:hasControlledRisk rdf:type owl:ObjectProperty ;
        rdfs:domain :RMF ;
        rdfs:range :ControlledRisk ;
        rdfs:label "has controlled risk" .

#################################################################
#    Classes
#################################################################

###  https://w3id.org/riskman/ontology#RMF
:RMF rdf:type owl:Class ;
    rdfs:label "RMF" ;
    rdfs:comment "Risk Management File" .

###  https://w3id.org/riskman/ontology#DeviceCode
:DeviceCode rdf:type owl:Class ;
    rdfs:label "Device Code" ;
    rdfs:comment "Device code to be supplied to an RMF (primarily EMDN / GMDN)" .

```