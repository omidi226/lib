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
%var Contract: AppContracts;
%var AppContract:appcontract;

predicate AppContracts(var AppContract:appcontract,var Contract:appcontracts)=(

           forall(d in 1)( 

        appcontracts= compose4(appcontract[d],appcontract[d+1],appcontract[d+2],appcontract[d+3]))
        );

%constraint enforce(appcontracts);

%%%%%%%%%%%%%%% platform contract %%%%%%%%%%%%%%%%%

%array [1..Arch_size] of var 0..:alpha;

predicate PlatContracts(var PlatContract:platcontract,array [1..Arch_size] of var 0..:alpha)=(
      forall (i in 1..Arch_size,j in 1..R ) (
                  j<=alpha[i]
                  )
);


%%%%%%%%%%%%%%%%%%%%%% mapper contract%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicate allocation(array [1..Arch_size] of var 0..:alpha)=(
true
);
      
predicate binding(array [1..n] of  var 1..Arch_size:beta , array [1..n] of var 1..R:gamma)=(
true
);





