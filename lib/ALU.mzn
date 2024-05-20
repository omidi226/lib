% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "ltl_lib.mzn";

include "../Contract.mzn";


type trace_int = array[1..MAX_TIME] of var int;


var trace_int:a;
var trace_int:b;
var trace_int:out_int;
var trace_int:out;
var trace:r;
var trace:inst;
int:n=2;
var Contract: C1 = (

  assumptions:forall(z in 1..MAX_TIME)(r[z]=1 -> forall(k in 1..n where z+k<=MAX_TIME )(r[z+k]=0 /\ a[z+k]=a[z] /\b[z+k]=b[z])),
  guarantees: (forall(z in 1..MAX_TIME  where z+n<=MAX_TIME ) ( out_int[z+n]=a[z]+b[z]))
); 


 
var Contract:C= (  
   

  assumptions:forall(z in 1..MAX_TIME)(r[z]=1 -> forall(k in 1..n where z+k<=MAX_TIME )(r[z+k]=0 /\ a[z+k]=a[z] /\b[z+k]=b[z] /\ inst[z+k]=inst[z])),
  guarantees: (forall(z in 1..MAX_TIME where z+n<=MAX_TIME) ( (r[z]=1/\inst[z]=0 -> out[z+n]=a[z]+b[z]) /\ (r[z]=1/\inst[z]=1->out[z+n]=a[z]*b[z]))  )
);  
var Contract:C2;   
   



solve satisfy;





  