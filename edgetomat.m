function A=edgetomat(edge,sz)
% Function to translate from edge vector to matrix
rows=sz(1);
cols=sz(2);
mat=zeros(rows,cols);

ind_upper=find(triu(ones(rows,cols),1));

for k=1:length(ind_upper)
    
[i j]=ind2sub([82 82],ind_upper(k));
mat(i,j)=edge(k);

end
A=mat;
A = (A+A') - eye(size(A,1)).*diag(A);