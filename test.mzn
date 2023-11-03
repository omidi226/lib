% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "diffn.mzn";
array [tasks] of int: d;
int:n;
int:m;
int:R;

set of int:tasks=1..n;
array [1..R] of 0..1:performance;
array [1..n]of 0..1:Contract;
array [1..m,1..2]of tasks: next;
array [1..n] of var 1..R:map;

int:TIME=sum(d);
array[tasks] of var 0..TIME:start;
array[tasks] of var 1..R:r;  
 
  
constraint forall (i in 1..m)
        (start[next[i,1]] + d[next[i,1]]
        <= start[next[i,2]]);

constraint cumulative(start,d,r,R);
constraint diffn(start,r,d,[1 | t in tasks]); 

constraint forall(i in tasks, j in 1..R where Contract[i]=1 /\ performance[j]=1)(map[i] = j);                     
                                                    
solve minimize max(t in tasks)
           (start[t] + d[t]);