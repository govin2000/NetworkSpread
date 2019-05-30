function generateFSVolumes(atlasbrain,indx,atrophy,outbrain)

% A function that can read an atlas and change the values as per 
    V=niftiread(atlasbrain);
    infos=niftiinfo(atlasbrain);
    
    all_indx=unique(V);
    
    Vs=V;
    n_indx=setdiff(all_indx,indx);
    
    
    for i=1:length(n_indx)
        
        Vs(find(Vs==n_indx(i)))=0;
        
    end
    
    for i=1:length(indx)
        
        Vs(find(Vs==indx(i)))=atrophy(i);
        
    end
    
    niftiwrite(Vs,outbrain,infos);