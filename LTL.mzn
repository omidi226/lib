% Use this editor as a MiniZinc scratch book
include "globals.mzn";

int:n;
%type trace =  record (array[0..n] of var 0..1:q); % trace=q0,q1,q2,...
array[0..n] of var 0..1:q; % trace=q0,q1,q2,...

%p
predicate P ( array[0..n] of var 0..1:q)=
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



array[0..n] of var 0..1:Q;
%constraint (Q[0]=0);
%constraint P(Q);

%constraint (Q[0]=1) in Q;
%constraint G(Q);

%constraint forall(i in 0..n)(Q[i]=0);
%constraint F(Q);

%constraint (Q[0]=1 /\ Q[1]=0);
%constraint X(Q);

%constraint forall(i in 0..n)(Q[i]=1);
%constraint U(Q);


solve satisfy ;








