% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "contract.mzn";


var -10..10:vs_temp1; %sensed temperature
var 0..10:vs_occ;    %sensed occupancy
var -10..10:phy_temp1;    %Actual temperature
var 0..10:phy_occ;       %Actual temperature
var 0..20:vs_act;     %actuation input
var 0..:phy_act;    %actuation output
int:p=10;           %fan
%%%%%%%%%%%%%%%%%%% physical environment %%%%%%%%%%%%%%%%%%%%
var Contract: physicalEnvironment= (

  assumptions:(true),
  guarantees: (0<=vs_occ /\ vs_occ<=10 /\ -10<= vs_temp1 /\ vs_temp1 <=10 /\ -10<= phy_temp1 /\ phy_temp1 <=10 /\ 0<=phy_occ /\ phy_occ<=10)%variable
);


%%%%%%%%%%%%%%%%%%%%%%  sensing   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: occupancy= (

  assumptions:(  0<=vs_occ /\ vs_occ<=10 /\ 0<=phy_occ /\ phy_occ<=10  ),
  guarantees: (abs( vs_occ-phy_occ)<=1 )
);

var Contract: temperature= (

  assumptions:( -10<= vs_temp1 /\ vs_temp1 <=10 /\ -10<= phy_temp1 /\ phy_temp1 <=10 ),
  guarantees: (abs(vs_temp1-phy_temp1)<=1 )
);

var Contract:sensing;
constraint sensing=compose(occupancy,temperature);

%%%%%%%%%%%%%%%%%%%%%%  control %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%var Contract:control=(
%  assumptions:(abs( vs_occ-phy_occ)<=1 /\ abs(vs_temp1-phy_temp1)<=1 ),
% guarantees: (( abs( vs_occ-phy_occ)<=1 /\ abs(vs_temp1-phy_temp1)<=1) -> vs_act>10)
%);
%%%%%%%%%%%%%%%%%%%%%%  actuation %%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract: fanControl= (

  assumptions:( vs_act>10  ),
  guarantees: (phy_act=10* p) %active
);


%%%%%%%%%%%%%%%%%%%%%%%  HVAC1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var Contract:system=(
  assumptions:( 0<=vs_occ /\ vs_occ<=10 /\ -10<= vs_temp1 /\ vs_temp1 <=10 /\ -10<= phy_temp1 /\ phy_temp1 <=10 /\ 0<=phy_occ /\ phy_occ<=10 ),
  guarantees: (abs( vs_occ-phy_occ)<=1 /\ abs(vs_temp1-phy_temp1)<=1 /\ (( abs( vs_occ-phy_occ)<=1 /\ abs(vs_temp1-phy_temp1)<=1) -> vs_act>10)/\ (vs_act>10 ->phy_act=10* p))
);

var Contract:system2=( 
 assumptions:( 0<=vs_occ /\ vs_occ<=10 /\ -10<= vs_temp1 /\ vs_temp1 <=10 /\ -10<= phy_temp1 /\ phy_temp1 <=10 /\ 0<=phy_occ /\ phy_occ<=10 ),
 guarantees: (abs( vs_occ-phy_occ)<=1 /\ abs(vs_temp1-phy_temp1)<=1  /\ (vs_act>10 ->phy_act=10* p))
);
%constraint enforce(system);
%constraint enforce(system2);
constraint enforce(fanControl);
var Contract:control;
%var Contract:system;
%var Contract:system2;
%constraint system=compose4(physicalEnvironment,sensing,fanControl,control);
%constraint system2=compose3(physicalEnvironment,sensing,fanControl);
constraint control=quotient(system,system2);

% example
vs_temp1=3;
vs_occ=0;
phy_temp1=10;
phy_occ=0;
solve satisfy;