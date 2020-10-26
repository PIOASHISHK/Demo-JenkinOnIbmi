SHELL=/QOpenSys/usr/bin/qsh
DBGVIEW=*SOURCE
DDSSRC=QDDSSRC
RPGLESRC=QRPGLESRC
DSPFSRC=QDSPFSRC
BIN_LIB=TESTLIB
LIBLIST=QTEMP $(BIN_LIB) QGPL

all: pgm

%.pgm: libsetup p_empmst.pf l_empmst.lf d_empmst.dspf

libsetup:
	system -qi "DLTLIB ($(BIN_LIB))"
	system -qi "CRTLIB ($(BIN_LIB))"
	system -qi "CRTSRCPF FILE($(BIN_LIB)/$(DDSSRC)) RCDLEN(112)"
	system -qi "CRTSRCPF FILE($(BIN_LIB)/$(DSPFSRC)) RCDLEN(112)"
	system -qi "CRTSRCPF FILE($(BIN_LIB)/$(RPGLESRC)) RCDLEN(112)"

%.rpgle:
	liblist -al $(LIBLIST);
	system -s "CHGATR OBJ('./qrpglesrc/$*.rpgle') ATR(*CCSID) VALUE(1252)"
	system -s "CRTBNDRPG OBJ($(BIN_LIB)/$*) SRCFILE('./qrpglesrc/$*.rpgle') COMMIT(*NONE) DBGVIEW(*SOURCE)"
	system "CPYFRMSTMF FROMSTMF('./qrpglesrc/$*.lf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/$(RPGLESRC).file/$*.mbr') MBROPT(*REPLACE)"
	
# %.sqlrpgle:
	# liblist -al $(LIBLIST);
	# system -s "CHGATR OBJ('./qrpglesrc/$*.sqlrpgle') ATR(*CCSID) VALUE(1252)"
	# system -s "CRTSQLRPGI OBJ($(BIN_LIB)/$*) SRCFILE('./qrpglesrc/$*.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE)"
	# system "CPYFRMSTMF FROMSTMF('./qrpglesrc/$*.lf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/$(RPGLESRC).file/$*.mbr') MBROPT(*REPLACE)"

%.dspf:
	liblist -al $(LIBLIST);
	system "CPYFRMSTMF FROMSTMF('./qdspfsrc/$*.dspf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/$(DSPFSRC).file/$*.mbr') MBROPT(*REPLACE)"
	system -qi "CHGPFM FILE($(BIN_LIB)/$(DSPFSRC)) MBR($*) SRCTYPE(DSPF)"
	system "CRTDSPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/$(DSPFSRC)) SRCMBR($*)"

%.pf:
	liblist -al $(LIBLIST);
	system "CPYFRMSTMF FROMSTMF('./qddssrc/$*.pf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/$(DDSSRC).file/$*.mbr') MBROPT(*REPLACE)"
	system -qi "CHGPFM FILE($(BIN_LIB)/$(DDSSRC)) MBR($*) SRCTYPE(PF)"
	system "CRTPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/$(DDSSRC)) SRCMBR($*)"

%.lf:
	liblist -al $(LIBLIST);
	system "CPYFRMSTMF FROMSTMF('./qddssrc/$*.lf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/$(DDSSRC).file/$*.mbr') MBROPT(*REPLACE)"
	system -qi "CHGPFM FILE($(BIN_LIB)/$(DDSSRC)) MBR($*) SRCTYPE(LF)"
	system "CRTLF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/$(DDSSRC)) SRCMBR($*)"