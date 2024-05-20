% Use this editor as a MiniZinc scratch book
include "ltl_lib.mzn";
include "Contract.mzn";
include "ALU.mzn";
include "globals.mzn";

% set the maximum time
MAX_TIME =1;

% example traces
trace_int: a1 = [1];
trace_int: b1 = [2];
trace: r1 = [1];
trace: inst1 = [0];

var Contract: Cp1 ;
var Contract: Cp ;
var Contract: Cp2 ;
constraint Cp2=quotient(Cp,Cp1);

