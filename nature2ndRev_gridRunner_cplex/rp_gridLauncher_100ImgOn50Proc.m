
%Sparsity = [90 95 98]';
Sparsity = [98]';

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

for i=1:size(Sparsity)
    %check if result directory exist, else create a resultdirectory
    resDir = ['Results_sparsity_' num2str(Sparsity(i)) ];
    if (exist(resDir) ~= 7)
        mkdir(resDir);
    end

    for j=1:2:size(folderNmArr)
        jobId = [ '_' num2str(j) '_' num2str(j+1) '_sparsity_' num2str(Sparsity(i)) ];

        img1 = folderNmArr{j};

        %as there are 103 images, we need to make sure the last one is executed
        try
            img2 = folderNmArr{j+1};
        catch err
            img2 = '';
        end

        disp(['sbatch -J McaVision' jobId ' rp_bashRun2Images.sh ''' img1 ''' ''' img2 ''' ' num2str(Sparsity(i)) ]);

        %system(['sbatch -J McaVision' jobId ' rp_bashRun2Images.sh ''' img1 ''' ''' img2 ''' ' Sparsity(i) ]);

        totalJobCount = totalJobCount + 1;
    end

end

totalJobCount







