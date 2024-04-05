% Use this editor as a MiniZinc scratch book

include "globals.mzn";
include "contract.mzn";


var 1..3:s;
var -10..10: I;
var -10..10: O;
var -10..10: m;
var -10..10: p;

var Contract: contract1 = (

  assumptions:(s=1 /\ I<=5),
  guarantees: (O=5  )
);
var Contract: contract2 = (

  assumptions:(s=2 /\ I=6 ),
  guarantees: (O=6 )
);
var Contract: contract3 = (

  assumptions:(s=3 /\ I=10 ),
  guarantees: (O=10 )
);

var Contract: contract4 = (

  assumptions:(s=1 /\ O<=5 ),
  guarantees: (m=3 )
);
var Contract: contract5 = (

  assumptions:(s=2 /\ O=6 ),
  guarantees: (m=6 )
);
var Contract: contract6 = (

  assumptions:(s=3 /\ O=10 ),
  guarantees: (m=10 )
);

var Contract: contract7 = (

  assumptions:(s=1 /\ m=3 ),
  guarantees: (p=3 )
);
var Contract: contract8 = (

  assumptions:(s=2 /\ m=6 ),
  guarantees: (p=6 )
);
var Contract: contract9 = (

  assumptions:(s=3 /\ m=10 ),
  guarantees: (p=10 )
);

var Contract: C1;
var Contract: Contarct1;
var Contract: C2;
var Contract: Contract2;
var Contract: C3;
var Contract: Contract3;
var Contract:contractcompose1;
var Contract:contractcompose2;

constraint C1=conjunction(contract1,contract2); 
constraint Contarct1=conjunction(C1,contract3);%contract component1

constraint C2=conjunction(contract4,contract5); 
constraint Contract2=conjunction(C2,contract6);%contract component2

constraint C3=conjunction(contract7,contract8); 
constraint Contract3=conjunction(C3,contract9);%contract component3

constraint contractcompose1=compose(Contarct1,Contract2);
constraint contractcompose2=compose(contractcompose1,Contract3);

solve satisfy;
%output ["Domain of Contarct1: \((Contarct1)),I: \((I)), O: \((O)), m: \(m), p: \((p))\n"];

