% ----------------------------------------------------------------------------
% Filename: ltl_lib.mzn
% Description: Primitives for linear temporal logic assertions in MiniZinc.
% Author: SBU CPS Lab
% Date: 2024
% ----------------------------------------------------------------------------

include "globals.mzn";

% Maximum time for traces
int: MAX_TIME;

% The trace type used by the LTL operators
type trace = array[1..MAX_TIME] of var 0..1;

% extend the normal propositional logic aserion for traces (only check the first instance)
predicate p(var trace: t) = 
    t[1]=1;

%% LTL operators


% Globally/Always function
function var trace: G(var trace: t) =
    G_step(t, 1);

% Globally/Always starting from time t0
function var trace: G_step(var trace: t, var int: t0) :: promise_total =
let {
    var trace: gtrace;
    constraint gtrace[t0] = forall(i in t0..MAX_TIME) (t[i]=1);
    constraint forall(i in t0+1..MAX_TIME) (gtrace[i]=G_step(t, i)[i]);
} in gtrace;

% Finally/Eventually function
function var trace: F(var trace: t) =
    F_step(t, 1);

% Finally/Eventually starting from time t0
function var trace: F_step(var trace: t, var int: t0) :: promise_total =
let {
    var trace: ftrace;
    constraint ftrace[t0] = exists(i in t0..MAX_TIME) (t[i]=1);
    constraint forall(i in t0+1..MAX_TIME) (ftrace[i]=F_step(t, i)[i]);
} in ftrace;

% Until function
function var trace: U(var trace: t1, var trace: t2) =
    U_step(t1, t2, 1);

% Until starting from time t0
function var trace: U_step(var trace: t1, var trace: t2, var int: t0) :: promise_total =
let {
    var trace: utrace;
    constraint utrace[t0] = exists(i in t0..MAX_TIME) (
        forall(j in t0..i-1) (t1[j]=1) /\ t2[i]=1
    );
    constraint forall(i in t0+1..MAX_TIME) (utrace[i]=U_step(t1, t2, i)[i]);
} in utrace;

% Next function
function var trace: X(var trace: t1) =
    X_step(t1, 1);

% Next starting from time t0
function var trace: X_step(var trace: t1, var int: t0) :: promise_total =
let {
    var trace: xtrace;
    constraint xtrace[t0] = if t0=MAX_TIME then true else (t1[t0+1]=1) endif;
    constraint forall(i in t0+1..MAX_TIME) (xtrace[i]=X_step(t1, i)[i]);
} in xtrace;
