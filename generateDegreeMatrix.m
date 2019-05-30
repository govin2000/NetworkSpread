function [VolMat]=generateDegreeMatrix(Vol)
%Generate a degree matrix based on the input degree vector 
sz=length(Vol);
VolMat=zeros(sz,sz);
for i=1:sz
   cn1=Vol(i);
    for j=1:sz
        cn2=Vol(j);
        VolMat(i,j)=sqrt(cn1*cn2);
    end
end

