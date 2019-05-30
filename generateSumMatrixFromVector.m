function [VolMat]=generateSumMatrixFromVector(Vol)
%Finds total volume of each parcel
%
sz=length(Vol);
VolMat=zeros(sz,sz);

for i=1:sz
   cn1=Vol(i);
    for j=1:sz
        cn2=Vol(j);
        VolMat(i,j)=cn1+cn2;
    end
end

