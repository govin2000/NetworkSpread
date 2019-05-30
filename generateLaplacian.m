function [eig_val V]=generateLaplacian(mat)

%Generate degree normalised laplacian matrix from connectivity matrix
Deg=diag(sum(mat,2));
L=Deg-mat;

norm_vol=generateDegreeMatrix(diag(Deg));
L=L./norm_vol;

[V,Di]=eig(L);
eig_val=diag(Di);