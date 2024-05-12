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
var trace_int:a;
var trace_int:b;
var trace_int:out_int;
var trace:r;
var trace:inst;
var Contract: c1p = (

  assumptions:true,
  guarantees: (p(G(r->X(X(out_int)) = add(a,b) ) ) ) \/ not(true)
);  
     
   
%%%test

%inst = [0,1,0,0,1,0,0,0,0,1];
var Contract: cp1 = (

  assumptions:true,
  guarantees: a\/ b
);
var Contract: cp2;
var Contract: cp3;
var Contract: cp = (

  assumptions:true,
  guarantees: ( (forall(m in 1..10) (if (inst[m]=0) then  a\/ b
                       else a/\ b endif)))
);
constraint cp2=ALU(cp,cp1);
constraint  cp2=quotient(cp,cp1);

constraint p(F(inst)) = true;

solve satisfy;





  