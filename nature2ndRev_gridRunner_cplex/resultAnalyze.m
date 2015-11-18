
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

sparsityVal = 95;

resDir = ['Results_sparsity_' num2str(sparsityVal) ];
affMatDir = ['AffMatrices' filesep];


for j=1:size(folderNmArr)
    
    imageName = folderNmArr{j}
    try
    OFile_csv = [resDir filesep 'sparsity_' num2str(sparsityVal) '_' imageName '_metrics.csv' ];
     tv_tvSparce_pdd_pff = csvread(OFile_csv);
    catch
         tv_tvSparce_pdd_pff = [0 0 0 0 0];
    end
    %Lines = ReadEdgeAttsFile (['Data' filesep imageName]);
    
   
    tv_tvSparce_pdd_pff = [j linesCount(j) tv_tvSparce_pdd_pff];
    
    metrics = [metrics; tv_tvSparce_pdd_pff]; 

end

csvwrite(['metrics_' num2str(sparsityVal) '.csv'], metrics);

%%
close all;
metrics = csvread('metrics_90.csv');
figure, plot(metrics(:,2), metrics(:,4), 'r*'); hold on;
plot(metrics(:,2), metrics(:,5), 'bo'); hold off;

figure, plot(metrics(:,2), metrics(:,6), 'r*');


metrics = csvread('metrics_95.csv');
figure, plot(metrics(:,2), metrics(:,4), 'g*'); hold on;
plot(metrics(:,2), metrics(:,5), 'bo'); hold off;

figure, plot(metrics(:,2), metrics(:,6), 'g*');


metrics = csvread('metrics_98.csv');
figure, plot(metrics(:,2), metrics(:,4), 'k*'); hold on;
plot(metrics(:,2), metrics(:,5), 'bo'); hold off;

figure, plot(metrics(:,2), metrics(:,6), 'k*');






