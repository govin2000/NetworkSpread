function modifyNodeWeights(atlas,outputfiles,nodeweight)
% The function to save node weightes based on the predicted atrophy
NI=atlas;
fid = fopen(NI);
data = textscan(fid,'%f %f %f %f %f %s','CommentStyle','#');
fclose(fid);
sphere = [cell2mat(data(1)) cell2mat(data(2)) cell2mat(data(3)) cell2mat(data(4)) cell2mat(data(5))];

sphere(:,5)=nodeweight;
nodename=data(6);
nx=nodename{1};

fid=fopen(outputfiles,'w')
fprintf(fid,'%s','#Desikan-Killany82 atlas modified')
for i=1:size(sphere,1)
fprintf(fid,'\n %f %f %f %f %f %s%\n',sphere(i,1),sphere(i,2),sphere(i,3),sphere(i,4),sphere(i,5),nx{1})
end
fclose(fid)

