function h=generateRTCurves(r_vals,time,h_curves,h_colrs,h_labels)
%% This function generates curves of correlation versus time 

h=figure('DefaultAxesFontSize',12,'color','w')

for i=1:length(h_curves)
rx=h_curves(i);
cr=h_colrs{i};
h(i)=plot(time,r_vals(:,rx),cr,'LineWidth',3);
hold on
end

plot(time,r_vals,'Color',[0.8 0.8 0.8]);
hold off
legend(h_labels);

xlabel('Time (a.u)', 'Fontsize', 24);
ylabel('Correlation (r-value)','Fontsize', 24);

