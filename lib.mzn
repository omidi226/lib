% Use this editor as a MiniZinc scratch book
include "globals.mzn";
type Contract = record (var bool: assumptions, var bool: guarantees);


%c2 << c1     AC1 implies AC2 , and 2) AC2 -> GC2 implies AC1-> GC1 
function var Contract: is_refine(var Contract:c2, var Contract:c1)=
(
  assumptions:c2.assumptions ->c1.assumptions,
  guarantees:c1.guarantees->c2.guarantees
 );
 
function var Contract: compose(var Contract: c1, var Contract: c2) = %:: promise_total=
( 
  assumptions: (c1.assumptions /\ c2.assumptions) \/ not(c1.guarantees /\ c2.guarantees),
  guarantees: (c1.guarantees /\ c2.guarantees)
);

function var Contract: conjunction(var Contract: c1, var Contract: c2) = 
(
  assumptions: c1.assumptions \/ c2.assumptions,
  guarantees: c1.guarantees /\ c2.guarantees
);

predicate enforce(var Contract: c) = (
  c.assumptions -> c.guarantees
);

predicate assume(var Contract: c) = 
  c.assumptions;
  
