% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "../contract.mzn";

type AppContract =array[1..n] of var Contract;
type PlatContract =array[1..Arch_size,1..R] of var Contract;

int:n;
int:R;
int:Arch_size;

%set of int:tasks=1..n;
%set of int:Res=1..R;
%set of int:Archs=1..Arch_size;


%%%%%%%%%%%%%%% app Contract  %%%%%%%%%%%%%%%%%%%%%
var Contract: AppContracts;
var AppContract:appcontract;

constraint forall( s in 1..n where n<=4)(

        AppContracts= compose4(appcontract[1],appcontract[2],appcontract[3],appcontract[4])
        );

constraint enforce(AppContracts);

%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%
var PlatContract:platcontract;
array [1..Arch_size] of var 0..:alpha;
constraint forall (i in 1..Arch_size,j in 1..R ) (
                  j<=alpha[i]
                  );



%%%%%%%%%%%%%%%%%%%%%% mapper contract%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicate allocation(array [1..Arch_size] of var 0..:alpha)=(
true
);
      
predicate binding(array [1..n] of  var 1..Arch_size:beta , array [1..n] of var 1..R:gamma)=(
true
);





