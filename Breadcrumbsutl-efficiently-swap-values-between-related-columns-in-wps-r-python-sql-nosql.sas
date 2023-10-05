%let pgm=utl-efficiently-swap-values-between-related-columns-in-wps-r-python-sql-nosql;

Efficiently swap values between related columns in wps r python sql nosql

   SOLUTIONS

       1 wps datastep hardcoded
       2 wps datastep dynamic
       3 wps sql
       4 wps r sql
       5 wps python sql
       6 wps base r


github
https://tinyurl.com/57nvrr8x
https://github.com/rogerjdeangelis/utl-efficiently-swap-values-between-related-columns-in-wps-r-python-sql-nosql/pulls

https://tinyurl.com/3d2p68mr
https://stackoverflow.com/questions/77240071/efficiently-swap-values-between-related-columns-in-r

Some of the solutions require that we compile and save two SWAP function;

%utl_submit_wps64x('
libname wps wpd "d:/wps";
options cmplib=(wps.functions);
proc fcmp outlib=wps.functions.swap;
  subroutine swapn(a,b);
  outargs a, b;
      h = a; a = b; b = h;
  endsub;
  subroutine swapc(a $,b $);
  outargs a, b;
      h = a; a = b; b = h;
  endsub;
run;quit;
');

 _                   _
(_)_ __  _ __  _   _| |_ ___
| | `_ \| `_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|

data sd1.have;
format
DATE date9.;
informat
DATE date9.;
;input
DATE P_A P_B R_A R_B C_A C_B T_A T_B;
cards4;
01JAN2001 1 2 1 2 1 2 1 2
02JAN2001 1 2 1 2 1 2 1 2
01JAN2001 1 2 1 2 1 2 1 2
02JAN2001 1 2 1 2 1 2 1 2
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                               |                    |                                                   */
/*  INPUT SD1.HAVE total obs=4                   |                    |                                                   */
/*             =======  ======= ========  =======| DATASTEP PROCESS   |  OUTPUT                                           */
/*     DATE   P_A P_B  R_A R_B  C_A C_B  T_A T_B |                    |     DATE   P_A P_B   R_A R_B   C_A C_B   T_A T_B  */
/*                                               |                    |                                                   */
/*  01JAN2001  1   2    1   2    1   2    1   2  | call swapn(P_A,P_B)|  01JAN2001  2   1     2   1     2   1     2   1   */
/*  02JAN2001  1   2    1   2    1   2    1   2  | call swapn(R_A,R_B)|  02JAN2001  2   1     2   1     2   1     2   1   */
/*  01JAN2001  1   2    1   2    1   2    1   2  | call swapn(C_A,C_B)|  01JAN2001  2   1     2   1     2   1     2   1   */
/*  02JAN2001  1   2    1   2    1   2    1   2  | call swapn(T_A,T_B)|  02JAN2001  2   1     2   1     2   1     2   1   */
/*                                               |                    |                                                   */
/*                                               | SQL PROCESS        |                                                   */
/*                                               |                    |                                                   */
/*                                               | select             |                                                   */
/*                                               | P_B as P_A         |                                                   */
/*                                               | P_A as P_B         |                                                   */
/*                                               |                    |                                                   */
/*                                               | R_B as R_A         |                                                   */
/*                                               | R_A as R_B         |                                                   */
/*                                               |                    |                                                   */
/*                                               | C_B as C_A         |                                                   */
/*                                               | C_A as C_B         |                                                   */
/*                                               |                    |                                                   */
/*                                               | T_B as T_A         |                                                   */
/*                                               | T_A as T_B         |                                                   */
/*                                               |                    |                                                   */
/* -----------------------------------------------------------------------------------------------------------------------*/
/*  YOU NEED TO ADD THIS SUBROUTINE TO YOUR TOOLS (SWAP pairs of variables)                                               */
/*                                                                                                                        */
/*  %utl_submit_wps64x('                                                                                                  */
/*  libname wps wpd "d:/wps";                                                                                             */
/*  options cmplib=(wps.functions);                                                                                       */
/*  proc fcmp outlib=wps.functions.swap;                                                                                  */
/*    subroutine swapn(a,b);                                                                                              */
/*    outargs a, b;                                                                                                       */
/*        h = a; a = b; b = h;                                                                                            */
/*    endsub;                                                                                                             */
/*    subroutine swapc(a $,b $);                                                                                          */
/*    outargs a, b;                                                                                                       */
/*        h = a; a = b; b = h;                                                                                            */
/*    endsub;                                                                                                             */
/*  run;quit;                                                                                                             */
/*  ');                                                                                                                   */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                            _       _            _              _                   _               _          _
/ | __      ___ __  ___    __| | __ _| |_ __ _ ___| |_ ___ _ __  | |__   __ _ _ __ __| | ___ ___   __| | ___  __| |
| | \ \ /\ / / `_ \/ __|  / _` |/ _` | __/ _` / __| __/ _ \ `_ \ | `_ \ / _` | `__/ _` |/ __/ _ \ / _` |/ _ \/ _` |
| |  \ V  V /| |_) \__ \ | (_| | (_| | || (_| \__ \ ||  __/ |_) || | | | (_| | | | (_| | (_| (_) | (_| |  __/ (_| |
|_|   \_/\_/ | .__/|___/  \__,_|\__,_|\__\__,_|___/\__\___| .__/ |_| |_|\__,_|_|  \__,_|\___\___/ \__,_|\___|\__,_|
             |_|                                          |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
libname wps wpd "d:/wps";
options cmplib=(wps.functions);
;
data sd1.want;

  set sd1.have;

  call swapn(P_A,P_B);
  call swapn(R_A,R_B);
  call swapn(C_A,C_B);
  call swapn(T_A,T_B);

proc print;
run;quit;
');

/*___                             _       _            _                  _                             _
|___ \  __      ___ __  ___    __| | __ _| |_ __ _ ___| |_ ___ _ __    __| |_   _ _ __   __ _ _ __ ___ (_) ___
  __) | \ \ /\ / / `_ \/ __|  / _` |/ _` | __/ _` / __| __/ _ \ `_ \  / _` | | | | `_ \ / _` | `_ ` _ \| |/ __|
 / __/   \ V  V /| |_) \__ \ | (_| | (_| | || (_| \__ \ ||  __/ |_) || (_| | |_| | | | | (_| | | | | | | | (__
|_____|   \_/\_/ | .__/|___/  \__,_|\__,_|\__\__,_|___/\__\___| .__/  \__,_|\__, |_| |_|\__,_|_| |_| |_|_|\___|
                 |_|                                          |_|           |___/
*/

%array(_as,values=%varlist(sd1.have,prx=/_A$/i));
%array(_bs,values=%varlist(sd1.have,prx=/_B$/i));

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x("

libname sd1 'd:/sd1';
libname wps wpd 'd:/wps';
options cmplib=(wps.functions);
options sasautos=('c:/otowps' sasautos);

data sd1.want;
  set sd1.have;
  %do_over(_as _bs,phrase=%str(call swapn(?_as,?_bs);));
run;quit;
");

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.WANT total obs=4                                                                                                   */
/*                                                                                                                        */
/* Obs    P_A    P_B    R_A    R_B    C_A    C_B    T_A    T_B                                                            */
/*                                                                                                                        */
/*  1      2      1      2      1      2      1      2      1                                                             */
/*  2      2      1      2      1      2      1      2      1                                                             */
/*  3      2      1      2      1      2      1      2      1                                                             */
/*  4      2      1      2      1      2      1      2      1                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____                                  _
|___ /  __      ___ __  ___   ___  __ _| |
  |_ \  \ \ /\ / / `_ \/ __| / __|/ _` | |
 ___) |  \ V  V /| |_) \__ \ \__ \ (_| | |
|____/    \_/\_/ | .__/|___/ |___/\__, |_|
                 |_|                 |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%array(_as,values=%varlist(sd1.have,prx=/_A$/i));
%array(_bs,values=%varlist(sd1.have,prx=/_B$/i));

%array(_as,values=%varlist(sd1.have,prx=/_A$/i));
%array(_bs,values=%varlist(sd1.have,prx=/_B$/i));

%utl_submit_wps64x("
libname sd1 'd:/sd1';
proc sql;
  create
     table sd1.want as
  select
     %do_over(_as _bs,phrase=%str(
               ?_bs as ?_as,
               ?_as as ?_bs), between=comma)
  from
     sd1.have
;quit;

proc print;
run;quit;
");


/*  _                                          _
| || |  __      ___ __  ___   _ __   ___  __ _| |
| || |_ \ \ /\ / / `_ \/ __| | `__| / __|/ _` | |
|__   _| \ V  V /| |_) \__ \ | |    \__ \ (_| | |
   |_|    \_/\_/ | .__/|___/ |_|    |___/\__, |_|
                 |_|                        |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%array(_as,values=%varlist(sd1.have,prx=/_A$/i));
%array(_bs,values=%varlist(sd1.have,prx=/_B$/i));

%utl_submit_wps64x("
libname sd1 'd:/sd1';
proc r;
export data=sd1.have r=have;
subm it;
library(sqldf);
want <- sqldf('
  select
     %do_over(_as _bs,phrase=%str(
               ?_bs as ?_as,
               ?_as as ?_bs), between=comma)
  from
     have
');
want;
endsubmit;
import data=sd1.want r=want;
run;quit;
");

proc print data=sd1.want width=min;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS R                                                                                                              */
/*                                                                                                                        */
/*   P_A P_B R_A R_B C_A C_B T_A T_B                                                                                      */
/* 1   2   1   2   1   2   1   2   1                                                                                      */
/* 2   2   1   2   1   2   1   2   1                                                                                      */
/* 3   2   1   2   1   2   1   2   1                                                                                      */
/* 4   2   1   2   1   2   1   2   1                                                                                      */
/*                                                                                                                        */
/* WPS                                                                                                                    */
/*                                                                                                                        */
/* Obs    P_A    P_B    R_A    R_B    C_A    C_B    T_A    T_B                                                            */
/*                                                                                                                        */
/*  1      2      1      2      1      2      1      2      1                                                             */
/*  2      2      1      2      1      2      1      2      1                                                             */
/*  3      2      1      2      1      2      1      2      1                                                             */
/*  4      2      1      2      1      2      1      2      1                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                     _   _                             _
| ___|  __      ___ __  ___   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
|___ \  \ \ /\ / / `_ \/ __| | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) |  \ V  V /| |_) \__ \ | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/    \_/\_/ | .__/|___/ | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
                 |_|         |_|    |___/                                |_|
*/
proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x("
options validvarname=any lrecl=32756;
libname sd1 'd:/sd1';
proc sql;select max(cnt) into :_cnt from (select count(nam) as cnt from sd1.have group by nam);quit;
%array(_unq,values=1-&_cnt);
proc python;
export data=sd1.have python=have;
submit;
from os import path;
import pandas as pd;
import numpy as np;
from pandasql import sqldf;
mysql = lambda q: sqldf(q, globals());
from pandasql import PandaSQL;
pdsql = PandaSQL(persist=True);
sqlite3conn = next(pdsql.conn.gen).connection.connection;
sqlite3conn.enable_load_extension(True);
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll');
mysql = lambda q: sqldf(q, globals());
want = pdsql('''
  select
     %do_over(_as _bs,phrase=%str(
               ?_bs as ?_as,
               ?_as as ?_bs), between=comma)
  from
     have
''');
print(want);
endsubmit;
run;quit;
"));

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The PYTHON Procedure                                                                                                   */
/*                                                                                                                        */
/*    P_A  P_B  R_A  R_B  C_A  C_B  T_A  T_B                                                                              */
/* 0  2.0  1.0  2.0  1.0  2.0  1.0  2.0  1.0                                                                              */
/* 1  2.0  1.0  2.0  1.0  2.0  1.0  2.0  1.0                                                                              */
/* 2  2.0  1.0  2.0  1.0  2.0  1.0  2.0  1.0                                                                              */
/* 3  2.0  1.0  2.0  1.0  2.0  1.0  2.0  1.0                                                                              */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*__                          _
 / /_   __      ___ __  ___  | |__   __ _ ___  ___   _ __
| `_ \  \ \ /\ / / `_ \/ __| | `_ \ / _` / __|/ _ \ | `__|
| (_) |  \ V  V /| |_) \__ \ | |_) | (_| \__ \  __/ | |
 \___/    \_/\_/ | .__/|___/ |_.__/ \__,_|___/\___| |_|
                 |_|
*/

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=example;
submit;
col_order <- names(example);
names(example) <- stringr::str_replace(
    names(example),
    "_A$|_B$",
    \(x) ifelse(x == "_A", "_B", "_A")
);
want <- example[col_order];
want;
endsubmit;
');

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS R                                                                                                              */
/*                                                                                                                        */
/*         DATE P_A P_B R_A R_B C_A C_B T_A T_B                                                                           */
/* 1 2001-01-01   2   1   2   1   2   1   2   1                                                                           */
/* 2 2001-01-02   2   1   2   1   2   1   2   1                                                                           */
/* 3 2001-01-01   2   1   2   1   2   1   2   1                                                                           */
/* 4 2001-01-02   2   1   2   1   2   1   2   1                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
