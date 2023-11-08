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
array [1..proce] of int:WCEC;
int:TIME=sum(d);
array[tasks] of var 0..TIME:start;
array[tasks] of var 1..R:r;
 
constraint forall (i in 1..m)
        (start[next[i,1]] + d[next[i,1]]
        <= start[next[i,2]]);
        
constraint cumulative(start,d,r,R);
constraint diffn(start,r,d,[1 | t in tasks]); 

var 1..n:T; 
var Contract:C1;
var Contract:C2;
var Contract:C3;

constraint (T=1 -> Arch[T]=1 ) in C1.assumptions /\ (WCEC[1]=100) in C1.guarantees;  
constraint (T=2 -> Arch[T]=0 ) in C2.assumptions /\ (WCEC[2]=200) in C2.guarantees; 
constraint (T=3 -> Arch[T]=2 ) in C3.assumptions /\ (WCEC[3]=300) in C3.guarantees; 

                                                                                              
solve minimize max(t in tasks)
           (start[t] + d[t]); 