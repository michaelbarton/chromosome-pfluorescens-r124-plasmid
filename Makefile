SCAFFOLD=assembly/scaffold.yml
SEQUENCE=assembly/sequence.fna
ANNTTION=assembly/annotations.gff
TEMPLATE=submission/template.sbt


TABLE=plasmid.tbl

GENOME=plasmid.fsa

GENOMESQN=plasmid.sqn
GENOMEGBF=plasmid.gbf

LOG=plasmid.val

all: $(AGP) $(GENOMESQN) $(LOG)

$(LOG): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -M n -t $(TEMPLATE) -Z $@
	rm -f errorsummary.val

$(GENOMEGBF): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -V b -t $(TEMPLATE)

$(GENOMESQN): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -t $(TEMPLATE) -i $(GENOME) -c b

$(GENOME): $(SCAFFOLD) $(SEQUENCE)
	genomer view fasta 	                                 \
		--identifier='PRJNA46289'                        \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--topology='circular'                            \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> $@

$(TABLE): $(SCAFFOLD) $(SEQUENCE) $(ANNTTION)
	genomer view table					\
		--identifier=PRJNA46289                         \
		--reset_locus_numbering                        \
		--prefix='E1A_'                                 \
		--generate_encoded_features='gnl|BartonUAkron|' \
		> $@

clean:
	rm -f plasmid.*
