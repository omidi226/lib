% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "ltl_lib.mzn";
include "contract.mzn";

bool:a;
bool:b;
bool:inst;
bool:r;

function var Contract: ALU(var Contract:C,var Contract:C1, var Contract:C2)=

  (
    assumptions:a /\ b /\ inst /\ r,
    guarantees:( if (r /\ not(inst)) then  a\/ b else a/\b endif)
   );
   
   
%%%test

var Contract: cp1 = (

  assumptions:a /\ b,
  guarantees: (a \/ b ) \/ not(a /\ b)
);

var Contract: cp2;
var Contract: cp = (

  assumptions:a /\ b /\ inst /\ r,
  guarantees: ( if (r /\ not(inst)) then  a\/ b else a/\b endif)
);
constraint  cp2=quotient(cp,cp1);



  