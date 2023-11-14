% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "diffn.mzn";


type Contract = var record ( var set of 0..1: assumptions, var set of 0..1: guarantees);

predicate conjunction(var Contract: c3,var Contract: c1,var Contract: c2) =
(c3.assumptions = c1.assumptions union c2.assumptions) /\( c3.guarantees = c1.guarantees intersect c2.guarantees);

int:n;
int:m;
array [tasks] of var int: d;
int:p;
int:Arch_size;

set of int:tasks=1..n;
set of int:Archs=1..Arch_size;

array [Archs] of int:alpha;
array [tasks] of Archs:beta;
array [tasks] of int:gamma;
array [1..n,Archs] of int:WCEC;
array [1..2] of Archs:mode; 

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
constraint (mode[1]=1 ) in C4.assumptions;
constraint (d[1]= WCEC[1,1] * 1 div 1000000) in C4.guarantees; 
constraint (d[2]= WCEC[2,1] * 1 div 2000000) in C4.guarantees;
constraint (d[3]= WCEC[3,1] * 1 div 3000000) in C4.guarantees;

                                                                                                                                                                                     constraint (mode[1]=2 ) in C5.assumptions;
                                                                                                                                                                                     constraint (d[1]= WCEC[1,1] * 1 div 1000000) in C5.guarantees; 
constraint (d[2]= WCEC[2,1] * 1 div 2000000) in C5.guarantees;
constraint (d[3]= WCEC[3,1] * 1 div 3000000) in C5.guarantees;
solve satisfy;                                                