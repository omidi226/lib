% ----------------------------------------------------------------------------
% Filename: ltl_test.mzn
% Description: Tests for the primitives defined in the linear temporal logic assertions library ltl_lib.mzn.
% Author: SBU CPS Lab
% Date: 2024
% ----------------------------------------------------------------------------

include "../lib/ltl_lib.mzn";

% set the maximum time
MAX_TIME = 10;

% example traces
trace: t1 = [0,0,0,0,0,0,0,0,0,0];
trace: t2 = [1,1,1,1,1,1,1,1,1,1];
trace: t3 = [0,1,0,0,1,0,0,0,0,1];
trace: t4 = [0,0,0,0,0,0,1,1,1,1];
trace: t5 = [0,0,1,1,1,1,1,1,1,1];

% check some examples
constraint p(G(t1)) = false;
constraint p(G(t2)) = true;
constraint p(F(t1)) = false;
constraint p(F(t3)) = true;
constraint p(X(t3)) = true;
constraint p(X(t4)) = false;
constraint p(G(F(t2))) = true;
constraint p(U(t2,t3)) = true;
constraint p(U(t3,t4)) = false;
constraint p(X(X(G(t5)))) = true;
constraint p(X(G(X(t5)))) = true;

output ["All checks passed!"];

solve satisfy;