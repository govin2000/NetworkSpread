function [rval2]=generateEdgeCentrality(avg_conmat, atr, indx, lh_seed, rh_seed,time)

% Function to generate edge centrality measure of edge vulnerability

rval2=[];

for j=1:length(lh_seed) 
    wg_edge=edgeCentrality(avg_conmat,[lh_seed(j) rh_seed(j)]);

    for i=time
        r=corr(wg_edge(indx,i),atr(indx)','Type','Pearson');
        rval2(j,i)=r;
    end

end