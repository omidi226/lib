% Use this editor as a MiniZinc scratch book
include "globals.mzn";

int:n;
array[0..n] of var 0..1:q;  % trace=q0,q1,q2,...

%p
predicate p ( array[0..n] of var 0..1:q)=
forall(i in 0..n ) (   q[0] =1 );

%G
predicate G( array[0..n] of var 0..1:q)=
forall(i in 0..n ) (   q[i] =1 );

%F
predicate F( array[0..n] of var 0..1:q)=
exists(i in 0..n) (   q[i]=1  );

%X
predicate X( array[0..n] of var 0..1:q)=
exists(i in 0..n) (  q[i]=1 -> q[i+1]=1);

%U
predicate U( array[0..n] of var 0..1:q)=
forall(i in 0..n) (   exists(j in 0..n ) (   q[i] =1 /\ q[j]=1) );



% variables








