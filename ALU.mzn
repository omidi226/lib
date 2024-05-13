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
var bool:a;
var bool:b;
var bool:out_int;
var bool:out;
var trace:r;
var trace:inst;

var Contract: C1 = (

  assumptions:true,
  guarantees: (forall(z in 1..MAX_TIME) (out_int= a\/b))
); 

 var Contract: C2 = (

  assumptions:true,
  guarantees: (forall(m in 1..MAX_TIME) ( out_int=a/\b))
); 

var Contract: C = (

  assumptions:true,
  guarantees: (forall(n in 1..MAX_TIME) ( if inst[i]=0 then out=a\/b else out=a/\b endif))
);  
var Contract:cp;   
constraint cp=quotient(C,C1);   


solve satisfy;





  