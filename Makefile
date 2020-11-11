all: *.s
	which vasm
	vasm -Fhunkexe -o magsys -phxass -nosym magsys.s
