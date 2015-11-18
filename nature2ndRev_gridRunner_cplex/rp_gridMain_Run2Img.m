function rp_gridMain_Run2Img(img1, img2, Sparsity)

cplexQuadprog_grid2(['Data' filesep img1], img1, Sparsity);

cplexQuadprog_grid2(['Data' filesep img2], img2, Sparsity);
