% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "contract.mzn";


var -10..10:vs_env_1;
var 0..10:vs_occ;
var 0..20:vs_env_2;


%%%%%%%%%%%%%%%%%%% physical environment %%%%%%%%%%%%%%%%%%%%
var Contract: App_HVAC1= (

  assumptions:(true),
  guarantees: (0<=vs_occ \/ vs_occ<=10 \/ -10<= vs_env_1 \/ vs_env_1 <=10 )
);


%%%%%%%%%%%%%%%%%%%%%%  sensor   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: occupancy1= (

  assumptions:(  vs_occ >5  ),
  guarantees: (  vs_env_1 <=0 )
);


%%%%%%%%%%%%%%%%%%%%%%  control %%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: actuation= (

  assumptions:(  vs_env_1 <=0  ),
  guarantees: (App_HVAC1.assumptions=1 )
);



solve satisfy;