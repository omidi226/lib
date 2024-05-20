
% Use this editor as a MiniZinc scratch book
include "globals.mzn";
%type Contract = record ( var int: input_vars, var int: output_vars,var bool: assumptions, var bool: guarantees);
type Contract = record (var bool: assumptions, var bool: guarantees);


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
let {
  Contract: c1_can = (assumptions: c1.assumptions,guarantees:c1.guarantees\/not c1.assumptions);
  Contract: c2_can = (assumptions: c2.assumptions,guarantees:c2.guarantees\/not c2.assumptions)
  } in
  (%c1.assumptions -> c2.assumptions /\ (c2.assumptions -> c2.guarantees )->c1.assumptions->c1.guarantees
  %   input_vars:c1.input_vars,
  %   output_vars:c2.output_vars,
    assumptions:c2_can.assumptions ->c1_can.assumptions,
    guarantees:c1_can.guarantees->c2_can.guarantees
   );
 
function var Contract: compose(var Contract: c1, var Contract: c2) = %:: promise_total=
let {
  Contract: c1_can = (assumptions: c1.assumptions,guarantees:c1.guarantees\/not c1.assumptions);
  Contract: c2_can = (assumptions: c2.assumptions,guarantees:c2.guarantees\/not c2.assumptions)
  } in
  (
    assumptions: (c1_can.assumptions /\ c2_can.assumptions) \/ (not (c1_can.guarantees /\ c2_can.guarantees)) ,
    guarantees: (c1_can.guarantees /\ c2_can.guarantees )
  );

function var Contract: conjunction(var Contract: c1, var Contract: c2) = 
let {
  Contract: c1_can = (assumptions: c1.assumptions,guarantees:c1.guarantees\/not c1.assumptions);
  Contract: c2_can = (assumptions: c2.assumptions,guarantees:c2.guarantees\/not c2.assumptions)
  } in

  (
    assumptions: c1_can.assumptions \/ c2_can.assumptions ,
    guarantees: c1_can.guarantees /\ c2_can.guarantees
  );
  
  function var Contract: conjunction3(var Contract: c1, var Contract: c2,var Contract: c3) = 
let {
  Contract: c1_can = (assumptions: c1.assumptions,guarantees:c1.guarantees\/not c1.assumptions);
  Contract: c2_can = (assumptions: c2.assumptions,guarantees:c2.guarantees\/not c2.assumptions);
  Contract: c3_can = (assumptions: c3.assumptions,guarantees:c3.guarantees\/not c3.assumptions)
  } in

  (
    assumptions: c1_can.assumptions \/ c2_can.assumptions \/ c3_can.assumptions ,
    guarantees: c1_can.guarantees /\ c2_can.guarantees/\ c3_can.guarantees
  );

predicate enforce(var Contract: c) = (
 c.assumptions->c.guarantees 
);

predicate assume(var Contract: c) = 
  c.assumptions;
  
% canonicalize (saturate) contract c
function var Contract: canonicalize(var Contract: c) =
(
  assumptions: c.assumptions,
  guarantees: c.guarantees \/ not c.assumptions
);

% Quotient of c and c1 (c1/c2) according to https://doi.org/10.1109/MEMCOD.2018.8556872
function var Contract: quotient(var Contract: c, var Contract: c1) = 
let {
  Contract: c_can = (assumptions: c.assumptions,guarantees:c.guarantees\/not c.assumptions);
  Contract: c1_can = (assumptions: c1.assumptions,guarantees:c1.guarantees\/not c1.assumptions)
  } in
  (
    assumptions: c_can.assumptions /\ c1_can.guarantees,
    guarantees: c1_can.assumptions /\ c.guarantees \/ not (c.assumptions /\ c1.guarantees)
  );

%FIXME
%predicate is_Complete( var Contract:c)= 
%forall ( a in c.assumptions,g in c.guarantees)(  g=true);

%C1/C2 = max{ C | C ⊗ C2 << C1}  
%predicate is_quotient(var Contract:c1, var Contract:c2, var Contract:c)=
%(compose1( c,c2)) -> is_refine(c3,c1);


%predicate  compose(var Contract: c3,var Contract: c1,var Contract: c2) =
%(c3.assumptions = c1.assumptions union c2.assumptions) /\( c3.guarantees = c1.guarantees union c2.guarantees);



% variables
var -10..10: i;
var -10..10: o;
%var -10..10: I;
%var -10..10: O;
var -10..10: o_p;
% var -15..15: u;

var Contract: c3;
var Contract: c1 = (
%   input_vars:i,
%   output_vars:o,
  assumptions:(i<=10),
  guarantees: (o<=i /\ i<=2*o+10  )
);

var Contract: c2 = (
%   input_vars:o,
%   output_vars:o_p,
  assumptions:(o<=1 ),
  guarantees: (o>=o_p )
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

% check some examples
%constraint (i=1)/\(o_p=0); % satisfies both assumption and guarantee of cc
%constraint (i=1)/\(o_p=3); % satisfies assumption, but violates gurantee of cc
constraint (i=2)/\(o_p=0);



%output ["Domain of i: \((i)), o: \((o)), o_p: \(o_p)\n"];

