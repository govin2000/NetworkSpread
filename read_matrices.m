function [y,ok,DIMS]=read_matrices(data)
    ok=1;
       if ~isempty(data)
        [nr,nc,ns]=size(data);
        if nr==nc && ns>0 && ~iscell(data) && isnumeric(data)
            ind_upper=find(triu(ones(nr,nr),1));
            y=zeros(ns,length(ind_upper));
            %Collapse matrices
            for i=1:ns
                tmp=data(:,:,i);
                y(i,:)=tmp(ind_upper);
            end
        elseif iscell(data)
            [nr,nc]=size(data{1});
            ns=length(data);
            if nr==nc && ns>0
                ind_upper=find(triu(ones(nr,nr),1));
                y=zeros(ns,length(ind_upper));
                %Collapse matrices
                for i=1:ns
                    [nrr,ncc]=size(data{i});
                    if nrr==nr && ncc==nc && isnumeric(data{i})
                        y(i,:)=data{i}(ind_upper);
                    else
                        ok=0; y=[]; 
                        break
                    end
                end
            else
                ok=0; y=[];
            end
        end
    else
        ok=0; y=[];
    end
    if ok==1
        %Number of nodes
        DIMS.nodes=nr;
        %Number of matrices
        DIMS.observations=ns;
    else
        %Number of nodes
        DIMS.nodes=0;
        %Number of matrices
        DIMS.observations=0;
    end
    