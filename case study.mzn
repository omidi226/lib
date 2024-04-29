% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "contract.mzn";


int:s;
var -10..10:vs_env_1;
var 0..10:vs_occ;
var 0..20:vs_env_2;


%%%%%%%%%%%%%%%%%%% physical environment %%%%%%%%%%%%%%%%%%%%
var Contract: App_HVAC1= (

  assumptions:(true),
  guarantees: (0<=vs_occ \/ vs_occ<=10 \/ -10<= vs_env_1 \/ vs_env_1 <=10 )
);

var Contract: App_HVAC2= (

  assumptions:(true),
  guarantees: ( 0<=vs_occ \/ vs_occ<=10 \/ 0<= vs_env_2 \/ vs_env_2 <=20 )
);

%%%%%%%%%%%%%%%%%%%%%%  sensor   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: occupancy1= (

  assumptions:( if s=1 then vs_occ >5 else vs_occ<2 endif ),
  guarantees: ( if s=1 then vs_env_1 <=0 else 0< vs_env_1   endif)
);

var Contract: occupancy2= (

  assumptions:( if s=1 then 5<= vs_occ else vs_occ<=2 endif),
  guarantees: ( if s=1 then 10<= vs_env_2 else vs_env_2<10 endif)
);

%%%%%%%%%%%%%%%%%%%%%%  control %%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: actuation= (

  assumptions:( if s=1 then vs_env_1 <=0 else 0< vs_env_1   endif ),
  guarantees: (App_HVAC1.assumptions=1 )
);

var Contract: actuation2= (

  assumptions:( if s=1 then 10<= vs_env_2 else vs_env_2<10 endif ),
  guarantees: (App_HVAC2.assumptions=1 )
);

solve satisfy;