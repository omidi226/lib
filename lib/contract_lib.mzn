% ----------------------------------------------------------------------------
% Filename: contract_lib.mzn
% Description: Definitions and primitive operations for assume/guarantee contracts.
% Author: Maryam Omidi
% Date: 2024
% ---------------------------------------------------------------------------- 

include "globals.mzn";

% a contract is a set of assumptions and guarantees
type contract = record (var bool: assumptions, var bool: guarantees);

% check whether contract c is compatible
predicate is_compatible(var contract: c) =
  c.assumptions == true;

% check whether contract c is consistent
% predicate is_consistent(var contract: c) =
%   c.guarantees \/ not c.assumptions;
predicate is_consistent1(var contract: c, var set of $$i1domT: i1dom, var $$i1T: i1) =
  (c.guarantees /\
    (dom(i1) = i1dom)
  ) \/ not c.assumptions
;

predicate is_consistent2(var contract: c,
                        var set of $$i1domT: i1dom,
                        var $$i1T: i1,
                        var set of $$i2domT: i2dom,
                        var $$i2T: i2) =
  forall (i1val in i1dom, i2val in i2dom) (
     (c.assumptions -> c.guarantees)
  );

predicate is_consistent3(var contract: c,
                        var set of $$i1domT: i1dom,
                        var $$i1T: i1,
                        var set of $$i2domT: i2dom,
                        var $$i2T: i2,
                        var set of $$i3domT: i3dom,
                        var $$i3T: i3) =
  (c.guarantees \/ not c.assumptions) /\
  (dom(i1) = i1dom) /\
  (dom(i2) = i2dom) /\
  (dom(i3) = i3dom)
;

predicate is_consistent4(var contract: c,
                        var set of $$i1domT: i1dom,
                        var $$i1T: i1,
                        var set of $$i2domT: i2dom,
                        var $$i2T: i2,
                        var set of $$i3domT: i3dom,
                        var $$i3T: i3,
                        var set of $$i4domT: i4dom,
                        var $$i4T: i4) =
  (c.guarantees \/ not c.assumptions) /\
  (dom(i1) = i1dom) /\
  (dom(i2) = i2dom) /\
  (dom(i3) = i3dom) /\
  (dom(i4) = i4dom)
;

% canonicalize (saturate) contract c
function var contract: canonicalize(var contract: c) =
(
  assumptions: c.assumptions,
  guarantees: c.guarantees \/ not c.assumptions
);

% check whether c2 refines c1
predicate refines(var contract:c2, var contract:c1) =
let {
  contract: c1_can = canonicalize(c1);
  contract: c2_can = canonicalize(c2)
  } in
    (c2_can.assumptions -> c1_can.assumptions) /\
    (c1_can.guarantees  -> c2_can.guarantees);

% composition of c1 and c2
function var contract: compose(var contract: c1, var contract: c2) =
let {
  contract: c1_can = canonicalize(c1);
  contract: c2_can = canonicalize(c2)
  } in
  (
    assumptions: (c1_can.assumptions /\ c2_can.assumptions) \/ (not (c1_can.guarantees /\ c2_can.guarantees)) ,
    guarantees: (c1_can.guarantees /\ c2_can.guarantees )
  );

% conjunction of c1 and c2
function var contract: conjunct(var contract: c1, var contract: c2) = 
let {
  contract: c1_can = canonicalize(c1);
  contract: c2_can = canonicalize(c2)
  } in

  (
    assumptions: c1_can.assumptions \/ c2_can.assumptions ,
    guarantees: c1_can.guarantees /\ c2_can.guarantees
  );

% Quotient of c and c1 (c1/c2) according to https://doi.org/10.1109/MEMCOD.2018.8556872
function var contract: quotient(var contract: c, var contract: c1) = 
let {
  contract: c_can = canonicalize(c);
  contract: c1_can = canonicalize(c1)
  } in
  (
    assumptions: c_can.assumptions /\ c1_can.guarantees,
    guarantees: c1_can.assumptions /\ c.guarantees \/ not (c.assumptions /\ c1.guarantees)
  );

% 
predicate enforce(var contract: c) =
  c.assumptions -> c.guarantees 
;

predicate assume(var contract: c) = 
  c.assumptions;


%% Auxiliary definitions

% three-way conjunction of c1, c2 and c3 based on conjunt
function var contract: conjunct3(var contract: c1, var contract: c2, var contract: c3) = 
let {
  contract: ct = conjunct(c1, c2)
  } in
    conjunct (ct, c3);

% three-way composition of c1, c2 and c3 based on compose
function var contract: compose3(var contract: c1, var contract: c2, var contract: c3) = 
let {
  contract: ct = compose(c1, c2)
  } in
    compose (ct, c3);