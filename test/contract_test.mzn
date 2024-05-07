% ----------------------------------------------------------------------------
% Filename: contract_test.mzn
% Description: Tests for the primitives defined in the assume/guarantee contracts library contract_lib.mzn.
% Author: Maryam Omidi
% Date: 2024
% ----------------------------------------------------------------------------

include "../lib/contract_lib.mzn";

%% Example from Section 2.2.1 of http://dx.doi.org/10.1561/1000000053
% c1 variables
var -10..10: x;
var -10..10: y;
var -10..10: z;

% c1 contract
var contract: c1 = (
  assumptions:(y!=0),
  guarantees: (z=x div y)
);

% check c1 consistency
% constraint enforce(c1)/\is_consistent2(c1, -10..10, x, -10..10, y) = false;

% cp1 contract
var contract: cp1 = (
  assumptions:(true),
  guarantees: (z=x div y)
);

% check cp1 consistency
constraint is_consistent2(cp1, -10..10, x, -10..10, y) = true;


% % variables
% var -10..10: i;
% var -10..10: o;
% var -10..10: o_p;
% % var -15..15: u;

% var contract: c1 = (
%   assumptions:(i<=10),
%   guarantees: (o<=i /\ i<=2*o+10)
% );

% var contract: c2 = (
%   assumptions:(o<=1),
%   guarantees: (o>=o_p)
% );

% var contract: c3;

% %constraint is_compatible(c1);
% %constraint is_consistent(c1);
% %constraint is_correct(c1);
% %constraint is_Complete(c2);
% constraint  c3=compose(c1,c2);
% %constraint c3.assumptions = c1.assumptions union c2.assumptions;
% %constraint c3.guarantees = c1.guarantees union c2.guarantees;
% %constraint compose (c3,c1,c2);
% %constraint c3=conjunction (c1,c2);
% %constraint is_quotient(c3,c1,c2);
% %constraint c3=is_refine(c2,c1);

% % Now say which contracts must hold
% constraint enforce(c3);

% % Which assumptions are valid from the environment?
% constraint assume(c3);

% % check some examples
% %constraint (i=1)/\(o_p=0); % satisfies both assumption and guarantee of cc
% %constraint (i=1)/\(o_p=3); % satisfies assumption, but violates gurantee of cc
% constraint (i=2)/\(o_p=0);

solve satisfy ;

output "All tests passed!";
output "\(dom(x)), \(dom(y)), \(dom(z))";