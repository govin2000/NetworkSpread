clear; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%% This script will run analysis pipeline used in Poudel et al.,2019,Human Brain Mapping %%%
%%% We used MRI data from IMAGE-HD cohort  %%%
%%% If you have any queries please contact me at govinda.poudel@acu.edu.au        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load connectome matrices and freesurfer volume metrices for controls and patients 

load Patients_Connectome.mat; % load Connectome data for controls
load Controls_Connectome.mat; % load Connectome data for patients
load Patients_Volume.mat; % load freesurfer volume data for pattients
load Controls_Volume.mat; % load freesurfeer volume data for controls

node_labels=readtable('Atlaslabels.xlsx');% Specify the labels of the node used in connectome (no need to specify both hemispheres).
nlb=node_labels.Regions;

lh_seed=[1:41]; %This are roi locations corresponding to left and right hand side of the brain
rh_seed=[49:82,42:48];
c_indx=[1:34 49:82]; %Node index for cortical parcels
s_indx=[35:48]; % Node index for subcortical parcels

% Controls and Patients freesurfer volumes
Volumes_Con=Controls_Volume.volumes;
Volumes_Patients=Patients_Volume.volumes;

% Normalisee freesurfer volumes by estimated intracranial volume
norm_Volumes_Con=Volumes_Con./Controls_Volume.eiv';
norm_Volumes_Patients=Volumes_Patients./Patients_Volume.eiv';


% Get descriptive statistics for the volumes
mean_con=mean(norm_Volumes_Con);
std_con=std(norm_Volumes_Con);
mean_Patients=mean(norm_Volumes_Patients);
std_Patients=std(norm_Volumes_Patients);
nc=size(norm_Volumes_Con,1);
ns=size(norm_Volumes_Patients,1);

% Get the difference between patients and control volumes using z score.
raw_diff_Patients=(mean_con-mean_Patients)./(sqrt((std_con.^2/nc)+(std_Patients.^2/ns)));


% Obtain average volumes for right and left hemispher regions
Volumes_Patients2=[Volumes_Patients(:,lh_seed)+Volumes_Patients(:,rh_seed)]/2'; % Obtain average volume of the right and left hemisphere for each region in patients
Volumes_Con2=[Volumes_Con(:,lh_seed)+Volumes_Con(:,rh_seed)]/2'; % Obtain average volume of the right and left hemisphere for each region in patients

%Get a summary of statistical differences in the freesurfer volumes (after normalising for intracranial volume) between patients and controls 
[dt]=getSummaryData(Volumes_Con2,Volumes_Patients2,Controls_Volume.eiv', Patients_Volume.eiv', nlb)

% dt is the data table summarising the differences
writetable(dt,'VolumeData_Sig_05_averaged_bilateral.csv','WriteRowNames',1);



%%%%%%%%%%%%%%%% Run NDM on the average of the healthy connectome
%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Specify diffusivity constant and time
beta=1;
time=1:1:50;


average_control_net=mean(Controls_Connectome,3); % Get an average of healthy connectome
mat=average_control_net; % averagee healthy connectome
diff_Patients=raw_diff_Patients; % z-stats of the difference between patients and controls
[eig_val,V]=generateLaplacian(mat); % Generate lapacian vectors 
[r_val_Patients,xt_Patients_all]=runSeedingNDM(eig_val,V,time,beta,diff_Patients,lh_seed,rh_seed); % Run seeding analysis for all bilateeral seeds
[vm_Patients, im_Patients]=sort(max(r_val_Patients),'descend'); % sort according to the correlation valys
fig_h1=generateRTCurves(r_val_Patients,time,[im_Patients(1:4) 36],{'r','k','g','c','m'},{nlb{[im_Patients(1:4)]},'Caudate'}); %CAUDATE IS MANNUALLY SPECIFIED FOR THE PURPOSE OF THE PAPERE

% Identify the region showing maximum correlation and plot the scatter plot
% of predicted and measured atrophy
[yt nt]=max(max(r_val_Patients));
[tr tt]=max(r_val_Patients(:,nt))
rois=[lh_seed(nt) rh_seed(nt)];
c1_indx=setdiff(c_indx,rois);
s1_indx=setdiff(s_indx,rois);
xl=squeeze(xt_Patients_all(:,tt,nt));
fig_handle=generatePredictedScatterPlot(xl,diff_Patients,c1_indx,s1_indx); % Calls this function to generate the plot


print(fig_handle,'-dpdf',['Patients_measuredversuspredicted_maxroi_' nlb{nt} '_time_' num2str(i) '.pdf'])
 

% Generate spatial maps and node maps to visualise the data
atlasbrain='aparc+aseg_mrtrix.nii';
outbrain=['aparc+aseg_mrtrix_Patients_max_' nlb{nt} '.nii'];
atr_val=xt_Patients_all(:,3,im_Patients(1));
[r_zvals,min_z,max_z]=normalizeatrall(atr_val);
inx=1:82;
generateFSVolumes(atlasbrain,inx,r_zvals,outbrain);

atlas='Desikan-Killiany41.txt';
modified_atlas='Desikan-Killiany41_maxrval.node'
modifyNodeWeights(atlas,modified_atlas,max(r_val_Patients)');






