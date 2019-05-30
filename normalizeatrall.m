function [r_zvals,min_z,max_z]=normalizeatrall(atr_d)

% Rescale the values from 1 to 10 for visualisation
zvals=(atr_d-median(atr_d))./std(atr_d);
min_z=min(zvals);
max_z=max(zvals);

r_zvals=rescale(zvals,1,10);