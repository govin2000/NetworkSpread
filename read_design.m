function [X,ok,DIMS]=read_design(data,DIMS)
ok=1;
if ~isempty(data)
    [nr,nc,ns]=size(data);
    if nr==DIMS.observations && nc>0 && ns==1 && isnumeric(data) 
        X=data; 
    else
        ok=0; X=[];
    end
else
    ok=0; X=[];
end
clear data
if ok==1
    %Number of predictors
    DIMS.predictors=nc;
else
    DIMS.predictors=0;
end
%       GLM.exchange:   