% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "contract.mzn";


var -10..10:vs_env1; %sensed temperature
var 0..10:vs_occ;    %sensed occupancy
var -10..10:env1;    %Actual temperature
var 0..10:occ;       %Actual temperature


%%%%%%%%%%%%%%%%%%% physical environment %%%%%%%%%%%%%%%%%%%%
var Contract: App_HVAC1= (

  assumptions:(true),
  guarantees: (0<=vs_occ \/ vs_occ<=10 \/ -10<= vs_env1 \/ vs_env1 <=10 \/ -10<= env1 \/ env1 <=10 \/ 0<=occ \/ occ<=10)%variable
);


%%%%%%%%%%%%%%%%%%%%%%  sensor   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: sensor= (

  assumptions:(  0<=vs_occ \/ vs_occ<=10 \/ -10<= vs_env1 \/ vs_env1 <=10 \/ -10<= env1 \/ env1 <=10 \/ 0<=occ \/ occ<=10  ),
  guarantees: ( vs_occ-occ<=1 /\ vs_env1-env1<=1 )
);


%%%%%%%%%%%%%%%%%%%%%%  control %%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: actuation= (

  assumptions:(  vs_occ-occ>1 \/ vs_env1-env1>1 ),
  guarantees: (App_HVAC1.assumptions=0 ) %eror
);



solve satisfy;