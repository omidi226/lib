% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "lib/contract_lib.mzn";

int:n;
int:m;
array [tasks] of var 0..: d;
int:R;
int:max_app_scens;
int:Arch_size;

set of int:tasks=1..n;
set of int:Res=1..R;
set of int:Archs=1..Arch_size;
set of int:app_scens=1..max_app_scens;
array [Archs] of var 0..:alpha;
array [tasks] of  var Archs:beta;
array [tasks] of var Res:gamma;
array [1..n] of var int:WCEC;
array [1..n] of var int:cost;
array [1..2,1..n,Archs] of int:WCECtable;
array [Archs,Res] of var int:ERate;
array [Archs,1..2] of int:ERatetable;
array [Archs,Res] of var 1..2:mode; 
var app_scens: app_scen;

%%%%%%%%%%%%%%% app Contract  %%%%%%%%%%%%%%%%%%%%%

array[tasks] of var Contract:AppContract;
var Contract:AppContracts;
constraint forall(i in tasks) (

   AppContract[i].assumptions=(beta[1]=1 \/beta[1]=2) /\ % assuming task 1 cannot be bound to Arch 3
   AppContract[i].guarantees= (WCEC[i]=WCECtable[app_scen,i,beta[i]])
  );  
%constraint enforce(AppContract[1]);
%constraint enforce(AppContract[2]);
%constraint enforce(AppContract[3]);

constraint AppContracts=compose3(AppContract[1],AppContract[2],AppContract[3]);
constraint enforce(AppContracts);
%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%

array[Archs,Res] of var Contract:PlatContract;
constraint forall (i in Archs,j in Res where j<=alpha[i]) (   
  PlatContract[i,j].assumptions=(true) /\ 
  PlatContract[i,j].guarantees= ( ERate[i,j]=ERatetable[i,mode[i,j]]  )
  );%mode[1,?]!=2
  
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
var Contract:allocationContarct=(
      assumptions:(forall(i in tasks)(cost[i]<=3)),
      guarantees:(alpha[1]=3 /\ alpha[2]=3 /\ alpha[3]=3)

);
constraint enforce(allocationContarct);

var Contract:binderContarct=(
      assumptions:(true),
      guarantees:(beta[1]=3 /\ beta[2]=3 /\ beta[3]=3)

);
var Contract:scheduleContarct;


constraint  forall(i in tasks)(d[i]= WCEC[i ]  div ERate[beta[i],gamma[i]] );
%var int:TIME=sum(d);
%array [Archs] of int:cost;
array[tasks]  of var 0..5 :start;
array [1..m,1..2]of tasks: next;
var Contract:Cm;
constraint  Cm.assumptions=true;
constraint  Cm.guarantees=true; % cost gurartee constraint 

 

%constraint (cost[1]=1 /\ cost[2]=1 /\cost[3]=1 ) in Cm.guarantees;
constraint forall (i in 1..m)
        (start[next[i,1]] + d[next[i,1]]
        <= start[next[i,2]]);

constraint cumulative(start,d,[1 | t in tasks],sum(alpha));
constraint sum(alpha)>0;

constraint 

  let {array [tasks] of var 1..Arch_size*3: r = [(beta[i]-1)*3+gamma[i]|i in tasks]; 
  } in 
    diffn(start,r,d,[1 | t in tasks]);
  
solve minimize max(t in tasks)
           (start[t] + d[t]);