
clear all;
dataDir = dir(fullfile('.','Data/*.atts')); % Creates a list of atts files
tic
startTime = datestr(now)

Sparsity = 90;

%sort filenames so that order of the filename exist
folderNmArr = [];
for i=1:size(dataDir)
    if(~(strcmp( dataDir(i).name, '.') || strcmp( dataDir(i).name, '..')))
        folderNm = dataDir(i).name;
        folderNmArr = [folderNmArr; str2num(folderNm)];
    end
end

folderNmArr = sort(folderNmArr);


%check if result directory exist, else create a resultdirectory
resDir = ['Results_sparsity_' num2str(Sparsity) ];
if (exist(resDir) ~= 7)
    mkdir(resDir);
end

metrics = [];
tv_tvSparce_pdd_pff = [];

parfor i=1:length(folderNmArr), 
%     main(sprintf('Data/%s', a(i).name)); 
    if exist(['Results_sparsity_' num2str(Sparsity) filesep folderNmArr(i).name '_AllOutput.mat']) == 0
       if (~(strcmp(folderNmArr(i).name ,'airfield_edges.pgm.pgm.atts') == 1 || strcmp(folderNmArr(i).name, '220.pgm.atts') == 1))
          folderNmArr(i).name
          tv_tvSparce_pdd_pff = main(['Data' filesep folderNmArr(i).name], folderNmArr(i).name, Sparsity);
          tv_tvSparce_pdd_pff = [i tv_tvSparce_pdd_pff];
          metrics = [metrics; tv_tvSparce_pdd_pff];
       end 
    end

end

csvwrite([resDir filesep 'sparsity_' num2str(Sparsity) '_metrics.csv' ], metrics);

startTime
endTIme = datestr(now)
toc
disp(['Time taken for 1 full exp run at sparsity ' num2str(Sparsity) 'is ' num2str(toc) ' (sec)']);