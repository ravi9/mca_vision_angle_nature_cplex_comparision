
close all; clear all;

imgDataDir = ['Data'];
imgAttsFileNames = dir([ imgDataDir filesep '*.atts']);

totalJobCount = 0;

%sort filenames so that order of the filename exist
folderNmArr = [];
for i=1:size(imgAttsFileNames)
    if(~(strcmp( imgAttsFileNames(i).name, '.') || strcmp( imgAttsFileNames(i).name, '..')))
        fileNm = imgAttsFileNames(i).name;
        folderNmArr = [folderNmArr; {fileNm}];
    end
end

folderNmArr = sort(folderNmArr);

%%

linesCount = csvread('linescount.csv');
metrics = [];
tv_tvSparce_pdd_pff = [];

sparsityVal = 90;

resDir = ['Results_sparsity_' num2str(sparsityVal) ];
affMatDir = ['AffMatrices' filesep];


for j=1:size(folderNmArr)
    
    imageName = folderNmArr{j}
    try
    OFile_csv = [resDir filesep 'sparsity_' num2str(sparsityVal) '_' imageName '_metrics.csv' ];
    OFile = [resDir filesep 'sparsity_' num2str(sparsityVal) '_affMat_' imageName '.mat' ];
    
    tv_tvSparce_pdd_pff = csvread(OFile_csv);
    if(size(tv_tvSparce_pdd_pff,2) == 3)
        tv_tvSparce_pdd_pff = [tv_tvSparce_pdd_pff 0 0]
        
    end
    TOutput = load(OFile, 'TOutput');
    TOutput_sparse = load(OFile, 'TOutput_sparse');
    
    TOutput = TOutput.TOutput;
    TOutput_sparse = TOutput_sparse.TOutput_sparse;
    perf = xor(TOutput, TOutput_sparse);
    truePos = round(((linesCount(j) - sum(perf))/linesCount(j))*100); %linesCount(j) is also size(perf,1)
    falsePos = round((sum(perf)/linesCount(j))*100);
    catch
         tv_tvSparce_pdd_pff = [0 0 0 0 0];
         truePos = 0;
         falsePos = 0;
    end
    %Lines = ReadEdgeAttsFile (['Data' filesep imageName]);
    
   
    tv_tvSparce_pdd_pff = [j linesCount(j) truePos falsePos tv_tvSparce_pdd_pff];
    
    metrics = [metrics; tv_tvSparce_pdd_pff]; 

end

disp(['Threshold dominant sparsity ' num2str(sparsityVal) ', trad avg time'])
mean(metrics(:,6))
disp(['Threshold dominant sparsit ' num2str(sparsityVal) ', trad-sparse avg time'])
mean(metrics(:,7))
disp(['Threshold dominant sparsit ' num2str(sparsityVal) ', trad-sparse avg perf-trupos'])
mean(metrics(:,3))
disp(['Threshold dominant sparsit ' num2str(sparsityVal) ', trad-sparse avg perf-pdd'])
mean(metrics(:,8))
csvwrite(['metrics_' num2str(sparsityVal) '.csv'], metrics);

%%
% close all;
% metrics = csvread('metrics_98.csv');
% figure, plot(metrics(:,2), metrics(:,7), 'r*'); hold on;
% plot(metrics(:,2), metrics(:,6), 'bo'); hold off;
% 
% figure, plot(metrics(:,2), metrics(:,3), 'r*');
% 
% 
% metrics = csvread('metrics_95.csv');
% figure, plot(metrics(:,2), metrics(:,4), 'g*'); hold on;
% plot(metrics(:,2), metrics(:,5), 'bo'); hold off;
% 
% figure, plot(metrics(:,2), metrics(:,6), 'g*');
% 
% 
% metrics = csvread('metrics_98.csv');
% figure, plot(metrics(:,2), metrics(:,4), 'k*'); hold on;
% plot(metrics(:,2), metrics(:,5), 'bo'); hold off;
% 
% figure, plot(metrics(:,2), metrics(:,6), 'k*');
% 
% 




