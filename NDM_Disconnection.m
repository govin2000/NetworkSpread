clear; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%% This script will run analysis pipeline used in Poudel et al.,2019,Human Brain Mapping %%%
%%% We used MRI data from IMAGE-HD cohort  %%%
%%% If you have any queries please contact me at govinda.poudel@acu.edu.au        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% download external software Newtork Based Statistics Toolbox https://sites.google.com/site/bctnet/comparison/nbs

%% Load connectome matrix for controls and patients and load design file
load Controls_Connectome.mat; % load Connectome data for Controls where each 2D connectome map is stacked in 3rd dimension
load Patients_Connectome.mat; % load Connectome data for Patients where each 2D connectome map is stacked in 3rd dimension
node_labels=readtable('Atlaslabels.xlsx');% Specify the labels of the node used in connectome (no need to specify both hemispheres).
nlb=node_labels.Regions;

%Specify bilateral locations of seeds
lh_seed=[1:41]; %This are roi locations corresponding to left and right hand side of the brain
rh_seed=[49:82,42:48];
time=1:50; % Total number of timepoints to be used in the model


Mat=cat(3,Controls_Connectome,Patients_Connectome); % Concantenate controls and patients data for running NBM

n_controls=size(Controls_Connectome,3); % Total number of controls
n_patients=size(Patients_Connectome,3); % Total number of patients

n_total=size(Mat,3);    % Total sample size

%design matrix for between groups t-test using GLM
design=zeros(n_total,2); 
design(1:n_controls,1)=1; % Controls 
design(n_controls+1:n_total,2)=1; % Patients

[test_stat, A]=run_nbsglm(Mat,design); % run GLM on the data using NBS

% Significant between group differences should be visualised in
% BrainNetViewer
dlmwrite('PatientsVsControls.edge',A,'delimiter','\t'); % Save the significant edges to visualise 

% Only find non-zero differences
tstat2=test_stat(1,:);
n_total3=find(tstat2~=0);

%%%%%%%%%Estimate edge vulnerability using NDM %%%%%%%%
avg_Controls_Connectome=mean(Controls_Connectome,3); %average of the healthy connectome data
datamat=zeros(size(avg_Controls_Connectome)); %initialise datamat


[rval2]=generateEdgeCentrality(avg_Controls_Connectome, tstat2, n_total3, lh_seed, rh_seed,time); % Generate edge vulnerability using the edge centrality based on NDM
[max_val max_im]=sort(max(rval2'),'descend'); % sort the correlation values
fig_h1=generateRTCurves(rval2',time,[max_im(1:5)] ,{'r','k','g','c','m'},nlb([max_im(1:5)])) % Generate curves of correlation over time. Highlight the top 5 correlation curves

[mt it]=max(rval2(max_im(1),:)');
wg_edge=edgeCentrality(avg_Controls_Connectome,[max_im(1) max_im(1)+7]); % Estimatee the edge vulnerability measure

%Generate scatter plot of the correlation between edge vulnerability and
%measureed vulnereability
t=it;  
fig_handle=figure('DefaultAxesFontSize',24,'color','w')
scatter(tstat2(n_total3),wg_edge(n_total3,it),'b.','LineWidth',3);
ylabel('Predicted disconnection (a.u.)','Fontsize', 24);
xlabel('Measured disconnection (t-value)','Fontsize', 24);

%Identify the most vulnerable edges based on the measure of edge centrality
lt=wg_edge(:,it);
[slt_val, slt_indx]=sort(lt,'descend');
lts=zeros(length(lt),1);
max_n_total=length(lt);
lts(slt_indx(1:max_n_total))=slt_val(1:max_n_total);
Ap=edgetomat(lts,size(avg_Controls_Connectome));

dlmwrite('PatientsVersusControls_Predicted.edge',Ap,'delimiter','\t');



