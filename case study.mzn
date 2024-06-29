% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "contract.mzn";


var -10..10:vs_temp1; %sensed temperature
var 0..10:vs_occ;    %sensed occupancy
var -10..10:phy_temp1;    %Actual temperature
var 0..10:phy_occ;       %Actual temperature
var int:vs_act;     %actuation input
var int:phy_act;    %actuation output
%%%%%%%%%%%%%%%%%%% physical environment %%%%%%%%%%%%%%%%%%%%
var Contract: physicalEnvironment= (

  assumptions:(true),
  guarantees: (0<=vs_occ \/ vs_occ<=10 \/ -10<= vs_temp1 \/ vs_temp1 <=10 \/ -10<= phy_temp1 \/ phy_temp1 <=10 \/ 0<=phy_occ \/ phy_occ<=10)%variable
);


%%%%%%%%%%%%%%%%%%%%%%  sensing   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: occupancy= (

  assumptions:(  0<=vs_occ \/ vs_occ<=10 \/ 0<=phy_occ \/ phy_occ<=10  ),
  guarantees: (abs( vs_occ-phy_occ)<=1 )
);

var Contract: temperature= (

  assumptions:( -10<= vs_temp1 \/ vs_temp1 <=10 \/ -10<= phy_temp1 \/ phy_temp1 <=10 ),
  guarantees: (abs(vs_temp1-phy_temp1)<=1 )
);

var Contract:sensing;
constraint sensing=compose(occupancy,temperature);
%%%%%%%%%%%%%%%%%%%%%%  actuation %%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: fanControl= (

  assumptions:( vs_act>10  ),
  guarantees: (phy_act=vs_act*10 ) %active
);

%%%%%%%%%%%%%%%%%%%%%%%  app_HVAC1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var Contract:system;
var Contract:app_HVAC1;
var Contract:control;
constraint system=compose3(physicalEnvironment,sensing,fanControl);
constraint app_HVAC1=compose(system,control);
constraint control=quotient(app_HVAC1, system);

solve satisfy;