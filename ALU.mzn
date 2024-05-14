% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "ltl_lib.mzn";
include "contract.mzn";
type trace_int = array[1..MAX_TIME] of var int;


% function var Contract: ALU(var Contract:C,var Contract:C1)=

%   (
%     assumptions:true,
%     guarantees:(forall(i in 1..10) (if (inst[i]=0) then  C.guarantees=C1.assumptions\/ C1.assumptions 
%                        else C.guarantees=C1.assumptions/\ C1.assumptions endif))
%    );
var trace:a;
var trace:b;
var trace:out_int;
var trace:out;
var trace:r;
var trace:inst;
int:n=2;
var Contract: C1 = (

  assumptions:forall(z in 1..MAX_TIME)(r-> forall(k in 1..n where z+k<=MAX_TIME )(not(r[z+k]) /\ a[z+k]=a[z] /\b[z+k]=b[z])),
  guarantees: (forall(z in 1..MAX_TIME  where z+n<=MAX_TIME ) ( out_int[z+n]=a[z]+b[z]))
); 


var Contract: C = (

  assumptions:forall(z in 1..MAX_TIME)(r-> forall(k in 1..n where z+k<=MAX_TIME )(not(r[z+k]) /\ a[z+k]=a[z] /\b[z+k]=b[z] /\ inst[z+k]=inst[z])),
  guarantees: (forall(z in 1..MAX_TIME where z+n<=MAX_TIME) ( (r/\not(inst)->out_int[z+n]=a[z]+b[z]) /\ (r/\inst->out_int[z+n]=a[z]*b[z]))  )
);  
var Contract:C2;   
constraint C2=quotient(C,C1);   


solve satisfy;





  