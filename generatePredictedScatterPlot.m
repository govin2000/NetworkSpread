function fig_handle=generatePredictedScatterPlot(xt_data,diff_atr,c_indx,s_indx)
% Function to generate scatter plot between predicted and measured atrophy
ai=sort([c_indx,s_indx]);
fig_handle=figure('DefaultAxesFontSize',24,'color','w')
scatter(diff_atr(ai)',xt_data(ai),'r*','LineWidth',3);
lsline
hold on
scatter(diff_atr(c_indx)',xt_data(c_indx),'b*','LineWidth',3);
scatter(diff_atr(s_indx)',xt_data(s_indx),'r*','LineWidth',3);
ylabel('Predicted atrophy (a.u.)','Fontsize', 24);
xlabel('Measured atrophy (t-value)','Fontsize', 24);
[r1 p1]=corr(diff_atr(ai)',xt_data(ai),'type','Spearman');
r1=round(r1,2);
if (p1<0.001)
titletext=['r=' num2str(r1) ' p<0.001']
else
titletext=['r=' num2str(r1) ' p=' num2str(p1)]
end

title(titletext, 'Fontsize',18); 
