
clear all; close all;

dataDir = dir(fullfile('.','Data/*.atts')); % Creates a list of atts files
affMatDir = ['AffMatrices' filesep];
affMatDirFiles = dir(fullfile('.','AffMatrices/*.csv'));

sparsity = 0.98;

%for i=1:length(affMatDirFiles)
for i=10:10
    affMatDirFiles(i).name
    AffMat = csvread([affMatDir filesep affMatDirFiles(i).name]);
    sparseAffMat = sparsifyWithStrongEdges(AffMat,sparsity);
end

%%
tic
HSize = 330;
Adj = sparseAffMat;
%Adj = sparseAffMat(1:HSize,1:HSize);
Deg = (sum(Adj, 2));
L = diag(Deg) - Adj;
%L = diag(Deg.^(-0.5)) * L * diag(Deg.^(-0.5));
%[lV, lD] = eig(L);
%lD = diag(lD);


H = L;
H = 0.5*(H+H');

Aineq = [];
bineq = [];
Aeq = []; beq = []; lb = [];ub = [];x0 = [];

Aeq = ones(1, size(H,1));
beq = size(H,1)/2;

f = ones(1, size(H,1));

sostype = [];
sosind = [];
soswt=[];

ctype = 'B';
for i=1:size(H,1)-1
    ctype = [ctype 'B'];
end

[x,fval,exitflag,output] = cplexmiqp(H,f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype);

elapsedTime = toc
