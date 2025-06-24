# Riskman Device Code Validation Pipeline

This repo contains binaries and short/full versions of ontologies and SHACL constraints for Riskman device code validation.

## Explanation

### Constraints  
Based on MAUDE data and risk reports, we extract **frequent device problem–patient problem pairs** for specific devices, identified by their GMDN codes. For example, we observe that for devices with **GMDN code 10403** (*Biopsy Kits, Ultrasonic Aspiration*), the **device problem** *IMDRF:A04* (*medical integrity problem*) and the **patient problem** *IMDRF:E20* (*injury*) frequently co-occur in the reports.  

From this observation, we derive a constraint:  
> **If** a device with GMDN 10403 is associated with a controlled risk where the device problem is *A04*,  
> **then** there must also be a controlled risk where the device problem is *A04* and the patient problem is *E20*.  

This constraint is encoded in SHACL in the file  
[`constraints_gmdn_fullmapping1_short.ttl`](inputs/constraints_gmdn_fullmapping1_short.ttl).

---

### GMDN–EMDN Mapping  
We map GMDN codes to their corresponding EMDN codes. For instance, **GMDN 10403** maps to **EMDN C04020201**. This mapping is defined in the ontology  
[`gmdn_emdn_fullmapping1_short.ttl`](inputs/gmdn_emdn_fullmapping1_short.ttl).

---

### IMDRF Ontology  
In a test scenario, we encounter a device with **EMDN code C04020201**, associated with:
- **Device problem:** *IMDRF:A040101*  
- **Patient problem:** *IMDRF:E0128*

Using the GMDN–EMDN mapping, we infer that **C04020201** corresponds to **GMDN 10403**.  
Because the IMDRF codes are hierarchical:
- *A040101* is a subclass of *A04*
- *E0128* is a subclass of *E20*

This means the observed device and problem combination satisfies the constraint, since it generalizes to the required *A04* and *E20* pair.  

The risk management data validating this is contained in the file  
[`test-abox-success.ttl`](inputs/test-abox-success.ttl). A failing example can be found in [`test-abox-fail.ttl`](inputs/test-abox-fail.ttl).


## Inputs

- `inputs/imdrf_ontology_short.ttl` (full: `imdrf_ontology.ttl`)  
- `inputs/gmdn_emdn_fullmapping1_short.ttl` (full: `gmdn_emdn_fullmapping1.ttl`)  
- `inputs/riskman-ontology.ttl`  
- `inputs/riskman-code-plugin.ttl`  
- `inputs/test-abox-success.ttl` (also `inputs/test-abox-fail.ttl`)  
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