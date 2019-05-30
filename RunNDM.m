function [xt]=RunNDM(eig_vect,eig_val,C0,time,beta)
% Function to run network diffusion model
% input: eig_vect: eigen vectors of graph laplacian
%        eig_val: eigen-valus
%        C0: initial condition
%        time: time points
%        beta: diffusion cofficient
% output:
% xt=diffusion values and 

C0 = C0(:);
C0V = eig_vect'*C0;%Transform the initial condition into the coordinate system 
%of the eigenvectors
xt=[];
pt=[];
for i=1:length(time)
   %Loop through times and decay each initial component
   P = C0V.*exp(-eig_val*beta*time(i));%Exponential decay for each component 
   xt(:,i) = eig_vect*P;%Transform from eigenvector coordinate system to original coordinate system
end