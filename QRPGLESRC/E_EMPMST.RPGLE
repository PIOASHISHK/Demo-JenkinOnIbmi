**free

ctl-opt option(*NoDebugIo: *srcStmt) debug;
ctl-opt dftActGrp(*no);

dcl-f L_EMPMST DISK(*EXT) USAGE(*INPUT) rename(P_EMPMSTA: L_EMPMSTA) KEYED;
dcl-f D_EMPMST WORKSTN sfile(EMPSFL: rrn1);

dcl-s rrn1 packed(4) inz;

dcl-c TRUE '1';
dcl-c FALSE '0';

*inlr = true;

processEmployeeMasterInfo();

return;

dcl-proc processEmployeeMasterInfo;

   clearSfl();
   loadSfl();
   dow not *in03;
      checkSfl();
      write EMPFOT;
      exfmt EMPCTL;

   enddo;

end-proc;

dcl-proc clearSfl;

   clear EMPCTL;
   clear rrn1;
   *in73 = TRUE;
   write EMPCTL;
   *in73 = FALSE;

end-proc;

dcl-proc loadSfl;

   setll *loval L_EMPMST;
   read L_EMPMST;
   dow not %eof(L_EMPMST);
      rrn1 += 1;
      S1_NUM = EM_NUM;
      S1_NAM = getName(%len(S1_NAM):
                       EM_LNAME:
                       EM_FNAME:
                       EM_MNAME);
      evalr S1_PHN = %char(EM_PHONEH);
      S1_PHN = '(' + %subst(S1_PHN: 4: 3) + ')' +
               %subst(S1_PHN: 7: 3) + '-' +
               %subst(S1_PHN: 10);
      S1_EML = getName(%len(S1_EML):
                       EM_EMAILH);
      write EMPSFL;
      read L_EMPMST;
   enddo;

end-proc;

dcl-proc checkSfl;

   *in71 = FALSE;
   *in72 = TRUE;
   if rrn1 > *zeros;
      *in71 = TRUE;
   endif;

end-proc;

dcl-proc getName;
   dcl-pi getName varchar(500) rtnParm;
      parm_len packed(3) const;
      parm1 varchar(100) const options(*trim);
      parm2 varchar(100) const options(*trim: *noPass);
      parm3 varchar(100) const options(*trim: *noPass);
      parm4 varchar(100) const options(*trim: *noPass);
      parm5 varchar(100) const options(*trim: *noPass);
   end-pi;

   dcl-s return_name varchar(500) inz;

   dcl-c space ' ';

   return_name = parm1;

   if %parms() >= %parmNum(parm2);
      return_name += space + parm2;
   endif;
   if %parms() >= %parmNum(parm3);
      return_name += space + parm3;
   endif;
   if %parms() >= %parmNum(parm4);
      return_name += space + parm4;
   endif;
   if %parms() >= %parmNum(parm5);
      return_name += space + parm5;
   endif;

   if %len(return_name) > parm_len;
      return_name = %subst(return_name: 1: parm_len-3) + '...';
   endif;

   return return_name;

end-proc;

