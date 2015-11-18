function sbest = TraditionalVision(A)

%% Maximizes x'*A*x/(x'x) where x is a vector of 0 and 1
%% patterned after pseudo code for simulated annealing on wikipedia
%% The input is a symmetric affinity matrix containing non-negative numbers
%% The output is a vector of 0 (non-salient) and 1 (salient) corresponding
%% to the primitives (edge segments), corresponding to the rows of the
%% matrix.
%% 
%% Copyright (c) 2011,  Sudeep Sarkar
%% All rights reserved
%%     This program is free software for research and educational purposes
%%     ONLY. For these purposes, you can redistribute it and/or modify it
%%     under the terms of the GNU General Public License as published by
%%     the Free Software Foundation, either version 3 of the License, or
%%     (at your option) any later version. This program is distributed in
%%     the hope that it will be useful, but WITHOUT ANY WARRANTY; without
%%     even the implied warranty of MERCHANTABILITY or FITNESS FOR A
%%     PARTICULAR PURPOSE.  See the GNU General Public License for more
%%     details. You should have received a copy of the GNU General Public
%%     License along with this program.  If not, see
%%     <http://www.gnu.org/licenses/>.

kmax = 100000; % max iterations of simulated programming

%% Initialize based on thresholding of the dominant eigenvector
[V, D] = eigs(A);
N = size(A, 1);
s = single(abs(V(:,1)) >= (1/(N))); 
d = diag(D);
%A = V(:,1)*diag(d(1))*V(:,1)';
e = (s'*A*s)./(s'*s); %Initial state, energy.

sbest = s; ebest = e; % Initial "best" solution

%% Find the best group that maximizes the quadratic global affiniity
%% form (average affinity) using simulated annealing of the initialized
%% group
T0 = e/100; %Temperature
k = 0; kupdate = 0;
rand('twister',sum(100*clock));

while k < kmax % time since last best value found.
    snew = s; i = ceil(N.*rand); snew(i) = 1 - snew(i); 
    %Pick some random id, flip the state of the component
    enew = (snew'*A*snew)./(snew'*snew);
    if (enew > ebest) 
        sbest = snew; ebest = enew; kupdate = k; % Is this a new best?
    end;
    T = T0*(k/kmax);
    if (exp((enew - ebest)/T) > rand) % Should we move to it? compare with best so far...
        s = snew; e = enew;  % Yes, change state.
    end;
    %if (rem(k, 100) == 1) plot(k, e, 'o'); plot(k, ebest, 'gx');hold on; pause (0.0001); end;
    k = k + 1;
end;


