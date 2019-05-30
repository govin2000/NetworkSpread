function [r_val xt_all]=runSeedingNDM(eig_val,V,time,beta,atropy,lh_seed,rh_seed)
% A function to run seeding analysis for bilateeral seeds specified in
% lh_seed and rh-seed

r_val=[];
xt_all=[];
atr_all=[];
ns=1:length(atropy);
for i=1:length(atropy)/2;
    xt=[];
    C0=zeros(1,length(eig_val))';
    C0(lh_seed(i))=1;
    C0(rh_seed(i))=1;
    u_ns=setdiff(ns,[lh_seed(i),rh_seed(i)]);
    [xt]=RunNDM(V,eig_val,C0,time,beta);
    r_val(:,i)=corr(xt(u_ns,:),atropy(u_ns)','type','Spearman');
    xt_all(:,:,i)=xt;
    
    %xt_all(:,:,i)=xt(u_ns,:);
    %atr_all(:,:,i)=atropy(u_ns)';
    
end

