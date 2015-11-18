
clear all; close all;

dataDir = dir(fullfile('.','Data/*.atts')); % Creates a list of atts files
affMatDir = ['AffMatrices' filesep];
affMatDirFiles = dir(fullfile('.','AffMatrices/*.csv'));

sparsity = 0.98;

%for i=1:length(affMatDirFiles)
for i=1:1
    affMatDirFiles(i).name
    AffMat = csvread([affMatDir filesep affMatDirFiles(i).name]);
    sparseAffMat = sparsifyWithStrongEdges(AffMat,sparsity);
end

%%
H = -AffMat;
[V,D,W] = eig(H);
H = W * diag(diag(D).*(diag(D)>0) + 1) * W';
H = 0.5 * (H+H');

options = optimoptions(@quadprog,'Algorithm','interior-point-convex','Display','iter');
f = ones(1, size(H,1));
A = []; b = []; Aeq = []; beq = [];

lb = zeros(1, size(H,1));
ub = ones(1, size(H,1));

lb = [];
ub = [];

x0 = [];

[x,fval,exitflag,output,lambda] = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);