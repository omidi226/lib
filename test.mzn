% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "diffn.mzn";


type Contract = var record ( var set of 0..1: assumptions, var set of 0..1: guarantees);

predicate conjunction(var Contract: c3,var Contract: c1,var Contract: c2) =
(c3.assumptions = c1.assumptions union c2.assumptions) /\( c3.guarantees = c1.guarantees intersect c2.guarantees);

int:n;
int:m;
int:R;
int:p;


set of int:tasks=1..n;

array [1..n] of var 1..p:Arch;
array [1..n,1..p] of var int:WCEC;
%array [1..p] of var int:mode; 

%%%%%%%%%%%%%%% app Contract  %%%%%%%%%%%%%%%%%%%%%

array [tasks] of var int: T;
var Contract:C; 
var Contract:C1;
var Contract:C2;
var Contract:C3;
var Contract:C_con1; %c_conjuction1
var Contract:C_con2; %c_conjuction2

constraint (Arch[T[1]]=1 ) in C1.assumptions;
constraint (WCEC[1,1]=100) in C1.guarantees;  
constraint (WCEC[1,2]=200) in C1.guarantees; 
constraint (WCEC[1,3]=300) in C1.guarantees; 

constraint (Arch[T[2]]=1 ) in C2.assumptions;
constraint (WCEC[2,1]=100) in C2.guarantees;
constraint (WCEC[2,2]=200) in C2.guarantees;
constraint (WCEC[2,3]=300) in C2.guarantees;
     
constraint (Arch[T[3]]=3 ) in C3.assumptions; 
constraint (WCEC[3,1]=100) in C3.guarantees;
constraint (WCEC[3,2]=200) in C3.guarantees;
constraint (WCEC[3,3]=300) in C3.guarantees;

constraint conjunction(C_con1,C1,C2);
constraint conjunction(C_con2,C_con1,C3);


constraint forall(i in tasks) (Arch[i]=1) in C.assumptions;

%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%


                                                                                                                                                                                            
solve satisfy; 