% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "lib.mzn";

int:n;
int:m;
array [tasks] of var 0..: d;
int:R;
int:Arch_size;

set of int:tasks=1..n;
set of int:Res=1..R;
set of int:Archs=1..Arch_size;
array [Archs] of var 0..:alpha;
array [tasks] of  var Archs:beta;
array [tasks] of var Res:gamma;
array [1..n] of var int:WCEC;
array [1..n,Archs] of int:WCECtable;
array [Archs,Res] of var int:ERate;
array [Archs,1..2] of int:ERatetable;
array [Archs,Res] of var 1..2:mode; 

%%%%%%%%%%%%%%% app Contract  %%%%%%%%%%%%%%%%%%%%%

array[tasks] of var Contract:AppContract;

constraint forall(i in tasks) (
   AppContract[i].assumptions= true /\ % beta[1]=1 \/beta[1]=2  
  (WCEC[i]=WCECtable[i,beta[i]]) ->  AppContract[i].guarantees=WCEC[i]);  

constraint forall( i,j,k in tasks) (AppContract[k]=conjunction(AppContract[i],AppContract[j]));

%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%

array[Archs,Res] of var Contract:PlatContract;

constraint forall (i in Archs,j in Res where j<=alpha[i]) (   
  PlatContract[i,j].assumptions=true /\ 
  (ERate[i,j]=ERatetable[i,mode[i,j]]) -> PlatContract[i,j].guarantees=ERate[i,j]
);%mode[1,?]!=2


                                                                                                                                                                                   
                                                                                                                                                                                 
%%%%%%%%%%%%%%%%%%%%%% mapper%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%constraint diffn(start,gamma,d,[1 | t in tasks]);
constraint 
  let {array [tasks] of var 1..Arch_size*3: r = [(beta[i]-1)*3+gamma[i]|i in tasks]; 
  } in 
    diffn(start,r,d,[1 | t in tasks]);
  
solve minimize max(t in tasks)
           (start[t] + d[t]);