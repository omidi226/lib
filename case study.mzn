% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "contract.mzn";


var -10..10:vs_env1; %sensed temperature
var 0..10:vs_occ;    %sensed occupancy
var -10..10:env1;    %Actual temperature
var 0..10:occ;       %Actual temperature
var int:act_int;     %actuation input
var int:act_out;
%%%%%%%%%%%%%%%%%%% physical environment %%%%%%%%%%%%%%%%%%%%
var Contract: physicalEnvironment= (

  assumptions:(true),
  guarantees: (0<=vs_occ \/ vs_occ<=10 \/ -10<= vs_env1 \/ vs_env1 <=10 \/ -10<= env1 \/ env1 <=10 \/ 0<=occ \/ occ<=10)%variable
);


%%%%%%%%%%%%%%%%%%%%%%  sensing   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: occupancy= (

  assumptions:(  0<=vs_occ \/ vs_occ<=10 \/ 0<=occ \/ occ<=10  ),
  guarantees: (abs( vs_occ-occ)<=1 )
);

var Contract: temperature= (

  assumptions:( -10<= vs_env1 \/ vs_env1 <=10 \/ -10<= env1 \/ env1 <=10 ),
  guarantees: (abs(vs_env1-env1)<=1 )
);

var Contract:sensing;
constraint sensing=compose(occupancy,temperature);
%%%%%%%%%%%%%%%%%%%%%%  actuation %%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: fanControl= (

  assumptions:( act_int>10  ),
  guarantees: (act_out=act_int*10 ) %active
);

%%%%%%%%%%%%%%%%%%%%%%%  app_HVAC1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var Contract:system;
var Contract:app_HVAC1;
var Contract:control;
constraint system=compose3(physicalEnvironment,sensing,fanControl);
constraint app_HVAC1=compose(system,control);
constraint control=quotient(app_HVAC1, system);

solve satisfy;