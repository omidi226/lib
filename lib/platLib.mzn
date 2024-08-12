% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "contract_lib.mzn";

int:n;
int:R;
int:Arch_size;
set of int:tasks=1..n;
set of int:Res=1..R;
set of int:Archs=1..Arch_size;


%%%%%%%%%%%%%%% app Contract  %%%%%%%%%%%%%%%%%%%%%

array[tasks] of var Contract:AppContract;
var Contract:AppContracts;

constraint AppContracts=compose3(AppContract[1],AppContract[2],AppContract[3]);
constraint enforce(AppContracts);

%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%

array[Archs,Res] of var Contract:PlatContract;

constraint enforce(PlatContract[1,1]);
constraint enforce(PlatContract[1,2]);
constraint enforce(PlatContract[1,3]);
constraint enforce(PlatContract[2,1]);
constraint enforce(PlatContract[2,2]);
constraint enforce(PlatContract[2,3]);
constraint enforce(PlatContract[3,1]);
constraint enforce(PlatContract[3,2]);
constraint enforce(PlatContract[3,3]);
%%%%%%%%%%%%%%%%%%%%%% mapper contract%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var Contract:allocationContarct;


var Contract:binderContarct;
var Contract:scheduleContarct;



