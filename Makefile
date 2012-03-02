all: build

build: plasmid.sqn

plasmid.fsa:
	genomer view fasta                                 \
		--identifier=PRJNA68653                          \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--topology='circular'                            \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> plasmid.fsa

plasmid.tbl:
	genomer view table                 \
		--identifier=PRJNA68653          \
		--reset_locus_numbering          \
		--prefix='I1A_'                  \
		--create_cds='gnl|BartonUAkron|' \
		> plasmid.tbl

plasmid.sqn: plasmid.fsa plasmid.tbl submission/template.sbt
	tbl2asn -p . -t submission/template.sbt

plasmid.gbf: plasmid.fsa plasmid.tbl submission/template.sbt
	tbl2asn -p . -V b -t submission/template.sbt

plasmid.log: plasmid.fsa plasmid.tbl submission/template.sbt
	tbl2asn -p . -V v -t submission/template.sbt
	mv errorsummary.val plasmid.log

clean:
	rm plasmid.*
