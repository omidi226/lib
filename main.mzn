% Use this editor as a MiniZinc scratch book
include "globals.mzn";

type Contract = var record ( var set of 0..1: assumptions, var set of 0..1: guarantees);

predicate conjunction(var Contract: c3,var Contract: c1,var Contract: c2) =
(c3.assumptions = c1.assumptions union c2.assumptions) /\( c3.guarantees = c1.guarantees intersect c2.guarantees);

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
array [Archs,Res] of var int:mode; 

%%%%%%%%%%%%%%% app Contract  %%%%%%%%%%%%%%%%%%%%%

var Contract:C_con1; %c_conjuction1
var Contract:C_con2; %c_conjuction2
array[tasks] of var Contract:AppContract;
constraint (true) in AppContract[1].assumptions;% beta[1]=1 \/beta[1]=2  
constraint (WCEC[1]=WCECtable[1,beta[1]]) in AppContract[1].guarantees;  

constraint (true ) in AppContract[2].assumptions;
constraint (WCEC[2]=WCECtable[2,beta[2]]) in AppContract[2].guarantees;
    
constraint (true ) in AppContract[3].assumptions; 
constraint (WCEC[3]=WCECtable[3,beta[3]]) in AppContract[3].guarantees;

constraint conjunction(C_con1,AppContract[1],AppContract[2]);
constraint conjunction(C_con2,C_con1,AppContract[3]);

%constraint forall(i in tasks) (beta[i]=1) in AppContract[4].assumptions;
%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%

array[Archs,Res] of var Contract:PlatContract;
constraint forall (i in Archs,j in Res where j<=alpha[i]) (   
  (true  ) in PlatContract[i,j].assumptions /\ 
  (ERate[i,j]=ERatetable[i,mode[i,j]]) in PlatContract[i,j].guarantees
);%mode[1,?]!=2;


                                                                                                                                                                                     
                                                                                                                                                                                     


%%%%%%%%%%%%%%%%%%%%%% mapper%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint  forall(i in tasks)(d[i]= WCEC[i ]  div ERate[beta[i],gamma[i]] );
var int:TIME=sum(d);
%array [Archs] of int:cost;
array[tasks]  of var 0..5 :start;
array [1..m,1..2]of tasks: next;
var Contract:Cm;
constraint (true) in Cm.assumptions;
constraint (true) in Cm.guarantees; % cost gurartee constraint 

%constraint (cost[1]=1 /\ cost[2]=1 /\cost[3]=1 ) in Cm.guarantees;
constraint forall (i in 1..m)
        (start[next[i,1]] + d[next[i,1]]
        <= start[next[i,2]]);

constraint cumulative(start,d,[1 | t in tasks],sum(alpha));
%constraint diffn(start,gamma,d,[1 | t in tasks]);
constraint 
  let {array [tasks] of var 1..Arch_size*3: r = [(beta[i]-1)*3+gamma[i]|i in tasks]; 
  } in 
    diffn(start,r,d,[1 | t in tasks]);
  
solve minimize max(t in tasks)
           (start[t] + d[t]);