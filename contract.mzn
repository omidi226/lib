
% Use this editor as a MiniZinc scratch book
include "globals.mzn";
type Contract = record ( var int: input_vars, var int: output_vars,var bool: assumptions, var bool: guarantees);


%predicate is_consistent(var Contract: c) =
%  exists (g in c.guarantees) (g=1);

%predicate is_compatible(var Contract: c) =
%  exists (a in c.assumptions) (a=1);
  

%predicate is_correct( var Contract:c)=
% exists (g in c.guarantees) ( g=true);

%c2 << c1  (29)
%predicate is_refine(var Contract:c2, var Contract:c1)=
%forall(a1 in c1.assumptions) (a1=1) -> forall(a2 in c2.assumptions) (a2=1)  /\
%(forall (a2 in c2.assumptions) (a2=1) -> forall(g2 in c2.guarantees) (g2=1)) -> (forall (a1 in c1.assumptions) (a1=1) -> forall(g1 in c1.guarantees) (g1=1));
 
%c2 << c1     AC1 implies AC2 , and 2) AC2 -> GC2 implies AC1-> GC1 
function var Contract: is_refine(var Contract:c2, var Contract:c1)=
(%c1.assumptions -> c2.assumptions /\ (c2.assumptions -> c2.guarantees )->c1.assumptions->c1.guarantees
  input_vars:c1.input_vars,
  output_vars:c2.output_vars,
  assumptions:c2.assumptions ->c1.assumptions,
  guarantees:c1.guarantees->c2.guarantees
 );
 
function var Contract: compose(var Contract: c1, var Contract: c2) = %:: promise_total=
( input_vars:c1.input_vars,
  output_vars:c2.output_vars,
  assumptions: (c1.assumptions /\ c2.assumptions) \/ not(c1.guarantees /\ c2.guarantees),
  guarantees: (c1.guarantees /\ c2.guarantees)
);

function var Contract: conjunction(var Contract: c1, var Contract: c2) = (
  input_vars:c1.input_vars,
  output_vars:c2.output_vars,
  assumptions: c1.assumptions \/ c2.assumptions,
  guarantees: c1.guarantees /\ c2.guarantees
);

predicate enforce(var Contract: c) = (
  c.assumptions -> c.guarantees
);

predicate assume(var Contract: c) = 
  c.assumptions;

%FIXME
%predicate is_Complete( var Contract:c)= 
%forall ( a in c.assumptions,g in c.guarantees)(  g=true);

%C1/C2 = max{ C | C ⊗ C2 << C1}  
%predicate is_quotient(var Contract:c1, var Contract:c2, var Contract:c)=
%(compose1( c,c2)) -> is_refine(c3,c1);


%predicate  compose(var Contract: c3,var Contract: c1,var Contract: c2) =
%(c3.assumptions = c1.assumptions union c2.assumptions) /\( c3.guarantees = c1.guarantees union c2.guarantees);



% variables
var 0..10: i;
var 0..10: o;
var 0..10: o_p;
% var -15..15: u;

var Contract: c3;
var Contract: c1 = (
  input_vars:i,
  output_vars:o,
  assumptions:(i<=2),
  guarantees: (o<=3)
);

var Contract: c2 = (
  input_vars:o,
  output_vars:o_p,
  assumptions:(o <= 3),
  guarantees: (o_p<=o)
);
%constraint is_compatible(c1);
%constraint is_consistent(c1);
%constraint is_correct(c1);
%constraint is_Complete(c2);
constraint  c3=compose(c1,c2);
%constraint c3.assumptions = c1.assumptions union c2.assumptions;
%constraint c3.guarantees = c1.guarantees union c2.guarantees;
%constraint compose (c3,c1,c2);
%constraint c3=conjunction (c1,c2);
%constraint is_quotient(c3,c1,c2);
%constraint c3=is_refine(c2,c1);

% Now say which contracts must hold
constraint enforce(c3);

% Which assumptions are valid from the environment?
constraint assume(c3);

solve satisfy ;

output ["Domain of i: \(dom(i)), o: \(dom(o)), o_p: \(dom(o_p))\n"];

