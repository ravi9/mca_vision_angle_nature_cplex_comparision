function A = sparsifyWithStrongEdges(A, p)
%SPARSIFY  lowest p matrix elements to zero.
%          S = sparsifyWithStrongEdges(A, P) is A with weakest 100*p percent elements set to zero
%          Thus 100*P percent of the weakest elements of A will be zeroed.
%          Default: P = 0.25.

if nargin < 2, p = 0.25; end
if p<0 | p>1, error('Second parameter must be between 0 and 1 inclusive.'), end

[sortedValues,sortIndex] = sort(A(:),'descend');

totalEdges = size(sortedValues,1);
numEdgesToKeep = totalEdges - round(p*totalEdges);
edgeIdxToRemove = sortIndex(numEdgesToKeep+1:end);

A(edgeIdxToRemove) = 0;

% [sortedValuesAfter,sortIndexAfter] = sort(A(:),'descend');
% size(find(A>0))
% disp('');