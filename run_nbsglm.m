function [test_stat, sn_mat]=run_nbsglm(Mat,design)

% Setup a GLM analysis in Network Based Statistics Toolbox
% Number of permutations 5000, thresh, 2.8
[y,ok,DIMS]=read_matrices(Mat); % read the data matrix to make it suitable for NDM
[X,ok,DIMS]=read_design(design,DIMS); % read the design matrix to make it suitablee for NDM
GLM.perms=5000; % Number of permutations
GLM.X=X; % Predictors
GLM.y=y; % Outcome variable
GLM.contrast=[1 -1]; % t-test of the difference between two groups
GLM.test={'ttest'};
test_stat=NBSglm(GLM);
STATS.thresh=2.8; % Threshold 
STATS.alpha=0.05; % p-value
STATS.N=DIMS.nodes;
STATS.test_stat=test_stat;
STATS.size='extent'; % Type of control
[cn_t,cn_mat,pval]=NBSstats(STATS);
sn_mat=full(cn_mat{1}); % significant connectivities