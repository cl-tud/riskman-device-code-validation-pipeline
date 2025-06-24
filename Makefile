# Makefile for ontology processing pipeline

########################################
# Configuration

ROBOT := java -jar bin/robot.jar
PYSHACL := /home/piotr/anaconda3/envs/rdf/bin/pyshacl 
REASONER := java -jar bin/realization-wrapper-1.0.jar

# Input files

# IMDRF ontology
ONTOLOGY1 := inputs/imdrf_ontology_short.ttl
# ONTOLOGY1 := inputs/imdrf_ontology.ttl
# GMDN / EMDN mapping ontology
ONTOLOGY2 := inputs/gmdn_emdn_fullmapping1_short.ttl
# ONTOLOGY2 := inputs/gmdn_emdn_fullmapping1.ttl
# Riskman ontology 
ONTOLOGY3 := inputs/riskman-ontology.ttl
# Extra Plugin Ontology (GMDN/EMDN)
ONTOLOGY4 := inputs/riskman-code-plugin.ttl

# ABox
ABOX := inputs/test-abox.ttl

# SHACL constraints
# SHACL_CONSTRAINTS := inputs/constraints_emdn_fullmapping1.ttl
SHACL_CONSTRAINTS := inputs/constraints_emdn_fullmapping1_short.ttl


########################################


# Intermediate files
MERGED := merged.ttl
REALIZED := realized.ttl

# Main target
all: validate

# Combine all input files into one temporary Turtle file
$(MERGED): $(ONTOLOGY1) $(ONTOLOGY2) $(ONTOLOGY3) $(ONTOLOGY4) $(ABOX)
	$(ROBOT) merge \
	--input $(ONTOLOGY1) \
	--input $(ONTOLOGY2) \
	--input $(ONTOLOGY3) \
	--input $(ONTOLOGY4) \
	--input $(ABOX) \
	--output $(MERGED)

# Realize ontology using a reasoner through OWL-API wrapper
$(REALIZED): $(MERGED)
	$(REASONER) $(MERGED) $(REALIZED)


# Validate with pySHACL
validate: $(REALIZED)
	$(PYSHACL) -s $(SHACL_CONSTRAINTS) -f human $(REALIZED)


# Clean intermediate files
clean:
	rm -f $(MERGED) $(REALIZED)

.PHONY: all validate clean nemo
