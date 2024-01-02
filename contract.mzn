% Use this editor as a MiniZinc scratch book
include "globals.mzn";
type Contract = var record ( var bool: assumptions, var bool: guarantees);

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
predicate is_refine(var Contract:c2, var Contract:c1)=
(c1.assumptions -> c2.assumptions /\ (c1.assumptions -> c1.guarantees )->c1.assumptions->c1.guarantees
 );
 
function var Contract: compose1(var Contract: c1,var Contract: c2) :: promise_total=
(
assumptions: (c1.assumptions /\ c2.assumptions)\/not(c1.guarantees /\ c2.guarantees) , guarantees: c1.guarantees /\ c2.guarantees

);

predicate conjunction(var Contract: c3,var Contract: c1,var Contract: c2) =
(c3.assumptions = c1.assumptions \/ c2.assumptions) /\( c3.guarantees = c1.guarantees /\ c2.guarantees);


%FIXME
%predicate is_Complete( var Contract:c)= 
%forall ( a in c.assumptions,g in c.guarantees)(  g=true);

%C1/C2 = max{ C | C ⊗ C2 << C1}  
%predicate is_quotient(var Contract:c1, var Contract:c2, var Contract:c)=
%(compose1( c,c2)) -> is_refine(c3,c1);


%predicate  compose(var Contract: c3,var Contract: c1,var Contract: c2) =
%(c3.assumptions = c1.assumptions union c2.assumptions) /\( c3.guarantees = c1.guarantees union c2.guarantees);



% variables
var -5..5: i;
var -5..5: o;
var -5..5: op;
var -5..5: u;

var Contract: c3;
var Contract: c1;
constraint  c1.assumptions=(-2<=i /\ i<=2);
constraint c1.guarantees=(o-i<=0 /\ i-2*o<=2);


var Contract: c2;
constraint  c2.assumptions=(o<=0.2 /\ -o<=1);
constraint c2.guarantees=(op-o<=0);



%constraint is_compatible(c1);
%constraint is_consistent(c1);
%constraint is_correct(c1);
%constraint is_Complete(c2);
constraint  c3=compose1(c1,c2);
%constraint c3.assumptions = c1.assumptions union c2.assumptions;
%constraint c3.guarantees = c1.guarantees union c2.guarantees;
%constraint compose (c3,c1,c2);
%constraint conjunction (c3,c1,c2);
%constraint is_quotient(c3,c1,c2);
%constraint is_refine(c1,c4);


solve satisfy ;