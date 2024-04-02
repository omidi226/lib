% Use this editor as a MiniZinc scratch book

include "globals.mzn";
include "contract.mzn";


var 1..3:s;
var -10..10: I;
var -10..10: O;
var -10..10: m;
var -10..10: p;

var Contract: contract1 = (

  assumptions:(s=1 /\ I<=10),
  guarantees: (O<=I /\ I<=2*O+10  )
);
var Contract: contract2 = (

  assumptions:(s=2 /\ I=1 ),
  guarantees: (O>=1 )
);
var Contract: contract3 = (

  assumptions:(s=3 /\ I=4 ),
  guarantees: (O>=4 )
);

var Contract: contract4 = (

  assumptions:(s=1 /\ O=1 ),
  guarantees: (m=1 )
);
var Contract: contract5 = (

  assumptions:(s=2 /\ O=5 ),
  guarantees: (m=5 )
);
var Contract: contract6 = (

  assumptions:(s=3 /\ O<=5 ),
  guarantees: (m>=5 )
);

var Contract: contract7 = (

  assumptions:(s=1 /\ m<=5 ),
  guarantees: (p>=5 )
);
var Contract: contract8 = (

  assumptions:(s=2 /\ m=7 ),
  guarantees: (p=5 )
);
var Contract: contract9 = (

  assumptions:(s=3 /\ m=8 ),
  guarantees: (p=10 )
);

var Contract: C1;
var Contract: Contarct1;
var Contract: C2;
var Contract: Contract2;
var Contract: C3;
var Contract: Contract3;

constraint C1=conjunction(contract1,contract2); 
constraint Contarct1=conjunction(C1,contract3);%contract component1

constraint C2=conjunction(contract4,contract5); 
constraint Contract2=conjunction(C2,contract6);%contract component2

constraint C3=conjunction(contract7,contract8); 
constraint Contract3=conjunction(C3,contract9);%contract component3

solve satisfy;
output ["Domain of I: \((I)), O: \((O)), m: \(m), p: \((p))\n"];

