
function elapsedTime = cplexQuadprog_grid1 (ImageFile, imageName, sparsityVal)

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



%%
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
beq = size(H,1)/2;

f = ones(1, size(H,1));

sostype = [];
sosind = [];
soswt=[];

ctype = 'B';
for i=1:size(H,1)-1
    ctype = [ctype 'B'];
end

H = sparse(H);

[x,fval,exitflag,output] = cplexmiqp(H,f,Aineq,bineq,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype);

elapsedTime = toc

metrics = [sparsityVal elapsedTime];

cpu_info = cpuinfo();
save(OFile, 'x', 'fval', 'exitflag', 'output', 'elapsedTime', 'imageName','sparsityVal', 'cpu_info');

csvwrite(OFile_csv, metrics);