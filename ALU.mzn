% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "ltl_lib.mzn";
include "contract.mzn";

int:a;
int:b;
bool:inst;
bool:r;

function var Contract: ALU(var Contract:c,var Contract:c1, var Contract:c2)=

  (
    assumptions:a ,
    guarantees:( if (r /\ not(inst)) then  a+b else a*b endif)
   );