
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
metrics_read = [];
timeoutImages = [];

sparsityVal = 95;

resDir = ['grid_results' filesep 'Results_sparsity_' num2str(sparsityVal) ];
affMatDir = ['AffMatrices' filesep];


for j=1:size(folderNmArr)
    
    imageName = folderNmArr{j};
    try
    OFile_csv = [resDir filesep 'sparsity_' num2str(sparsityVal) '_' imageName '_metrics.csv' ];
    OFile = [resDir filesep 'sparsity_' num2str(sparsityVal) '_affMat_' imageName '.mat' ];
    
    %metrics_read = csvread(OFile_csv);
    %Tcplex = metrics_read(:,2);
     
    cplexExitFlag = load(OFile, 'exitflag');
    
    if(cplexExitFlag.exitflag > 0)
        cplexElapsedTime = load(OFile, 'elapsedTime');
        Tcplex = cplexElapsedTime.elapsedTime;
    else
        Tcplex = -1000;
    end
    
    catch 
        timeoutImages = [timeoutImages; {imageName}];
        Tcplex = 1500;
         
    end
     
    metrics_read = [j linesCount(j) Tcplex];
    
    metrics = [metrics; metrics_read]; 

end

disp(['Cplex sparsity ' num2str(sparsityVal) ', trad avg time'])
mean(metrics(:,3))

%csvwrite(['Tcplex_metrics_' num2str(sparsityVal) '.csv'], metrics);

figure, plot(metrics(:,2), metrics(:,3), 'r*');

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




