% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "diffn.mzn";


type Contract = var record ( var set of 0..1: assumptions, var set of 0..1: guarantees);

predicate conjunction(var Contract: c3,var Contract: c1,var Contract: c2) =
(c3.assumptions = c1.assumptions union c2.assumptions) /\( c3.guarantees = c1.guarantees intersect c2.guarantees);

int:n;
int:m;
array [tasks] of var int: d;
int:R;
int:Arch_size;

set of int:tasks=1..n;
set of int:Archs=1..Arch_size;

array [Archs] of int:alpha;
array [tasks] of Archs:beta;
array [tasks] of int:gamma;
array [1..n,Archs] of int:WCEC;
array [Archs,1..2] of int:ERate;
array [1..R] of int:mode; 

%%%%%%%%%%%%%%% app Contract  %%%%%%%%%%%%%%%%%%%%%
var Contract:C; 
var Contract:C1;
var Contract:C2;
var Contract:C3;
var Contract:C_con1; %c_conjuction1
var Contract:C_con2; %c_conjuction2

constraint (beta[1]=1) in C1.assumptions;
constraint (WCEC[1,1]=1000000) in C1.guarantees;  

constraint (beta[2]=1 ) in C2.assumptions;
constraint (WCEC[2,1]=2000000) in C2.guarantees;
    
constraint (beta[3]=1 ) in C3.assumptions; 
constraint (WCEC[3,1]=3000000) in C3.guarantees;

constraint conjunction(C_con1,C1,C2);
constraint conjunction(C_con2,C_con1,C3);


constraint forall(i in tasks) (beta[i]=1) in C.assumptions;

%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%
var Contract:C4;
var Contract:C5;
var Contract:C6;

constraint (mode[1]=1 \/ mode[1]=2  ) in C4.assumptions;
constraint (mode[1]=1 -> ERate[1,1]=1000000 \/ mode[1]=2-> ERate[1,2]=1000000 ) in C4.guarantees; 

constraint (mode[2]=1 \/ mode[2]=2  ) in C5.assumptions;
constraint (mode[2]=1 -> ERate[1,1]=1000000 \/ mode[2]=2-> ERate[1,2]=1000000) in C5.guarantees;

constraint (mode[3]=1 \/ mode[3]=2  ) in C6.assumptions;
constraint (mode[3]=1 -> ERate[1,1]=1000000 \/ mode[3]=2-> ERate[1,2]=1000000) in C6.guarantees;

                                                                                                                                                                                     
                                                                                                                                                                                     
constraint  forall(i in tasks)(mode[1]=1 -> d[i]= WCEC[i,1]  div ERate[1,1] );
constraint  forall(i in tasks)(mode[1]=2 -> d[i]= WCEC[i,1]  div ERate[1,2] );
constraint  forall(i in tasks)(mode[2]=1 -> d[i]= WCEC[i,1]  div ERate[1,1] );
constraint  forall(i in tasks)(mode[2]=2 -> d[i]= WCEC[i,1]  div ERate[1,2] );
constraint  forall(i in tasks)(mode[3]=1 -> d[i]= WCEC[i,1]  div ERate[1,1] );
constraint  forall(i in tasks)(mode[3]=2 -> d[i]= WCEC[i,1]  div ERate[1,2] );
%%%%%%%%%%%%%%%%%%%%%% scheduling%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var int:TIME=sum(d);
array[tasks]  of var 0..5 :start;
array [1..m,1..2]of tasks: next;

constraint forall (i in 1..m)
        (start[next[i,1]] + d[next[i,1]]
        <= start[next[i,2]]);

constraint cumulative(start,d,gamma,R);
constraint diffn(start,gamma,d,[1 | t in tasks]);
  
solve minimize max(t in tasks)
           (start[t] + d[t]);                                               