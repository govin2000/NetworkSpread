function [dt, inx_sub1,s_p]=getSummaryData(data1,data2,eiv1,eiv2,legends)

% A function to generate summary measure of statistical difference
% beetween patients and controls. 
% Returns a data table

[h1, p1, ci1, tst1]=ttest2(data1./eiv1, data2./eiv2);
[s_p, inx_sub1]=sort(p1,'ascend');
data=[round(mean(data1(:,inx_sub1))',2), round(mean(data2(:,inx_sub1))',2), round(tst1.tstat(inx_sub1)',2), round(p1(inx_sub1)',3) ];
dt=array2table(data,'VariableNames',{'Controls','HD', 'Tvalues', 'Pvalues'});
legends(inx_sub1)
dt.Properties.RowNames=legends(inx_sub1);
