function wg_edge=edgeCentrality(mat,rois)
% This function calculates edge centrality based on total amount of
% diffusion between nodes connecting an edge
% input: Mat: connectivity matrix
% rois: regions for startign the NDM process

rows=size(mat,1);
cols=size(mat,2);

% Generate eigen values and eigenvectors of degree normalised laplacian matrix
[eig_val,V]=generateLaplacian(mat);
wg_edge=[];

%initialise the variables requireed for NDM
beta=1;
xt=[];
sum_s_xt=0;

for t=1:50
    time=t;
    s_xt=[];
    for i=1:length(rois)
        roi=rois(i);
        C0=zeros(1,rows)';
        C0(roi)=1;
        [xt]=RunNDM(V,eig_val,C0,time,beta); 
        s_xt(:,i)=xt;
    end
    
    if(i>1) sum_s_xt=sum(s_xt')'; 
       else sum_s_xt=s_xt;
    end
    mt=generateSumMatrixFromVector(sum_s_xt);
    [wg_edge(:,t),ok2,DIMS2]=read_matrices(mt);
end

