% Use this editor as a MiniZinc scratch book

include "globals.mzn";
include "contract.mzn";


var 1..3:s;
function var Contract: componenetContract(var Contract:Contract1,var Contract:Contract2,var Contract:Contract3)=(
 conjunction3(Contract1,Contract2,Contract3)
);
var Contract:componenetContract1;
var Contract:componenetContract2;
var Contract:componenetContract3;
var Contract:c1_3;
var Contract:c1_2;
var Contract:c1_1;
var Contract:c2_3;
var Contract:c2_2;
var Contract:c2_1;
var Contract:c3_3;
var Contract:c3_2;
var Contract:c3_1;
var Contract:conj1;
var Contract:conj2;
var Contract:conj3;
constraint componenetContract1=componenetContract(c1_1,c1_2,c1_3);
constraint componenetContract2=componenetContract(c2_1,c2_2,c2_3);
constraint componenetContract3=componenetContract(c3_1,c3_2,c3_3);
var Contract:systemcontract;
constraint systemcontract=compose3(componenetContract1,componenetContract2,componenetContract3);

/*var -10..10: I;
var -10..10: O;
var -10..10: m;
var -10..10: p;

var Contract: c1_1= (

  assumptions:(s=1 /\ I<=5),
  guarantees: (O=5  )
);
var Contract: c1_2 = (

  assumptions:(s=2 /\ I=6 ),
  guarantees: (O=6 )
);
var Contract: c1_3 = (

  assumptions:(s=3 /\ I=10 ),
  guarantees: (O=10 )
);

var Contract: c2_1 = (

  assumptions:(s=1 /\ O<=5 ),
  guarantees: (m=3 )
);
var Contract: c2_2 = (

  assumptions:(s=2 /\ O=6 ),
  guarantees: (m=6 )
);
var Contract: c2_3 = (

  assumptions:(s=3 /\ O=10 ),
  guarantees: (m=10 )
);

var Contract: c3_1 = (

  assumptions:(s=1 /\ m=3 ),
  guarantees: (p=3 )
);
var Contract: c3_2 = (

  assumptions:(s=2 /\ m=6 ),
  guarantees: (p=6 )
);
var Contract: c3_3 = (

  assumptions:(s=3 /\ m=10 ),
  guarantees: (p=10 )
);

var Contract: Contarct1;
var Contract: Contract2;
var Contract: Contract3;
var Contract:contractcompose1;
var Contract:contractcompose2;


constraint Contarct1=conjunction3(c1_1,c1_2,c1_3);%contract component1
 
constraint Contract2=conjunction3(c2_1,c2_2,c2_3);%contract component2

constraint Contract3=conjunction3(c3_1,c3_2,c3_3);%contract component3

constraint contractcompose1=compose(Contarct1,Contract2);
constraint contractcompose2=compose(contractcompose1,Contract3);
*/
solve satisfy;
%output ["Domain of Contarct1: \((Contarct1)),I: \((I)), O: \((O)), m: \(m), p: \((p))\n"];

