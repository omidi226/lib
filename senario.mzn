% Use this editor as a MiniZinc scratch book

include "globals.mzn";

type Contract = var record ( var bool: assumptions, var bool: guarantees);

function var Contract: conjunction(var Contract: c1, var Contract: c2) = 
let {
  Contract: c1_can = (assumptions: c1.assumptions,guarantees:c1.guarantees\/not c1.assumptions);
  Contract: c2_can = (assumptions: c2.assumptions,guarantees:c2.guarantees\/not c2.assumptions)
  } in

  (
    assumptions: c1_can.assumptions \/ c2_can.assumptions,
    guarantees: c1_can.guarantees /\ c2_can.guarantees
  );

var bool :s1;
var bool:s2;
var bool:s3;

predicate senario(var Contract: c1,var Contract: c2,var Contract: c3) = (
 c1.assumptions=true -> s1 \/
 c2.assumptions=true -> s2 \/
 c3.assumptions=true -> s3
 
);




