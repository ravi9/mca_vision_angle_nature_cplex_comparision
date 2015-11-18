
function elapsedTime = cplexQuadprog_grid2 (ImageFile, imageName, sparsityVal)

ImageFile
sparsityVal

resDir = ['Results_sparsity_' num2str(sparsityVal) ];
if (exist(resDir) ~= 7)
    mkdir(resDir);
end

resDir = ['Results_sparsity_' num2str(sparsityVal) ];
affMatDir = ['AffMatrices' filesep];

OFile = [resDir filesep 'sparsity_' num2str(sparsityVal) '_affMat_' imageName '.mat' ];
OFile_csv = [resDir filesep 'sparsity_' num2str(sparsityVal) '_' imageName '_metrics.csv' ];


AffMat = csvread([affMatDir filesep  'affMat_' imageName '.csv']);

beqFrac = 2;
[x,fval,exitflag,output,elapsedTime] = cplexQuadProg(AffMat, sparsityVal, beqFrac)

if(exitflag < 0)
    beqFrac = 3;
    [x,fval,exitflag,output,elapsedTime] = cplexQuadProg(AffMat, sparsityVal, beqFrac)
end

metrics = [sparsityVal beqFrac elapsedTime];

save(OFile, 'x', 'fval', 'exitflag', 'output', 'elapsedTime', 'imageName','sparsityVal', 'beqFrac');

csvwrite(OFile_csv, metrics);


%%
function [x,fval,exitflag,output,elapsedTime] = cplexQuadProg(AffMat, sparsityVal, beqFrac)
tic
sparseAffMat = sparsifyWithStrongEdges(AffMat, sparsityVal/100);
Adj = sparseAffMat;
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
beq = size(H,1)/beqFrac;

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

