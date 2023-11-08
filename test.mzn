% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "diffn.mzn";
type Contract = var record ( var set of 0..1: assumptions, var set of 0..1: guarantees);
int:n;
int:m;
int:R;
int:proce;

set of int:tasks=1..n;
array [tasks] of int: d;


array [1..m,1..2]of tasks: next;

array [1..n] of int:Arch;
array [1..n] of int:WCEC;
array [1..proce] of int:mode;
int:TIME=sum(d);
array[tasks] of var 0..TIME:start;
array[tasks] of var 1..R:r;
 
constraint forall (i in 1..m)
        (start[next[i,1]] + d[next[i,1]]
        <= start[next[i,2]]);
        
constraint cumulative(start,d,r,R);
constraint diffn(start,r,d,[1 | t in tasks]); 
%%%%%%%%%%%%%%%app Contract  %%%%%%%%%%%%%%%%%%%%%
var 1..n:T; 
var Contract:C1;
var Contract:C2;
var Contract:C3;

constraint (T=1 -> Arch[T]=1 ) in C1.assumptions /\ (T=1 -> WCEC[T]=100) in C1.guarantees;  
constraint (T=2 -> Arch[T]=0 ) in C2.assumptions /\ (T=1 -> WCEC[T]=200) in C2.guarantees; 
constraint (T=3 -> Arch[T]=2 ) in C3.assumptions /\ (T=1 -> WCEC[T]=300) in C3.guarantees; 

%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%
var 1..proce:p;
var Contract:C4;
var Contract:C5;
var Contract:C6;
constraint (p=1-> mode[p]=1 ) in C4.assumptions;
constraint (p=0-> mode[p]=0 ) in C5.assumptions;
constraint (p=2-> mode[p]=0 ) in C6.assumptions;
                                                                                              
solve minimize max(t in tasks)
           (start[t] + d[t]); 