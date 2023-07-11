% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "diffn.mzn";
%enum TASK;

array [tasks] of int: d;

int:n;
int:m;
int:R;
set of int:tasks=1..n;

array [1..m,1..2]of tasks: next;

int:TIME=sum(d);
array[tasks] of var 0..TIME:start;
array[tasks] of var 1..R:r;  
     
constraint forall (i in 1..m)
        (start[next[i,1]] + d[next[i,1]]
        <= start[next[i,2]]);

constraint cumulative(start,d,r,R);

constraint diffn(start,r,d,[1 | t in tasks]);                      
                                                    
solve minimize max(t in tasks)
           (start[t] + d[t]);

