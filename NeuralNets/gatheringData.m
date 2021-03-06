patients = load('../Patients/controllabilities.mat');
controls = load('../Controls/controllabilities.mat'); 
vns = load('../VNS/controllabilities.mat');
load('../labels.mat')

aveContZRank = [];
modalContZRank = [];
wDegZRank = [];
subject = [];
ParcelLocation = [];
therapeuticResection = [];
LPulvinarConnectivity = [];
RPulvinarConnectivity = [];
LAnteriorConnectivity = [];
RAnteriorConnectivity = [];
LMedioDorsalConnectivity = [];
RMedioDorsalConnectivity = [];
LVentralLateroDorsalConnectivity = [];
RVentralLateroDorsalConnectivity = [];
LCentralLateralLateralPosteriorMedialPulvinarConnectivity = [];
RCentralLateralLateralPosteriorMedialPulvinarConnectivity = [];
LVentralAnteriorConnectivity = [];
RVentralAnteriorConnectivity = [];
LVentralLateroVentralConnectivity = [];
RVentralLateroVentralConnectivity = [];
cortexonly = setdiff(1:253, [109:119 122:123 235:245 248:253])


%% For control patients, get the mean and standard deviation of connectivity metric ranks
for a = 1:length(controls.connectome)
    
    % wdegrank
    
    [~,r] = sort(controls.connectome(a).wdeg);
    rankV(r) = 1:numel(controls.connectome(a).wdeg);
    controls.connectome(a).wdegrank = (rankV)';
    
    % avecontrank
    
    [~,r] = sort(controls.connectome(a).avecont);
    rankV(r) = 1:numel(controls.connectome(a).avecont);
    controls.connectome(a).avecontrank = (rankV)';
    
    % modalcontrank
   
    [~,r] = sort(controls.connectome(a).modalcont);
    rankV(r) = 1:numel(controls.connectome(a).modalcont);
    controls.connectome(a).modalcontrank = (rankV)';
    
end

controlwdegrankmean = mean([controls.connectome.wdegrank],2);
controlavecontrankmean = mean([controls.connectome.avecontrank],2);
controlmodalcontrankmean = mean([controls.connectome.modalcontrank],2);
controlwdegrankstd = std([controls.connectome.wdegrank],0,2);
controlavecontrankstd = std([controls.connectome.avecontrank],0,2);
controlmodalcontrankstd = std([controls.connectome.modalcontrank],0,2);


%% Patient data

for a = 1:length(patients.connectome)
    
    %only looking at Engel 1 patients
    engel = patients.connectome(a).Engel;
    
    if engel ~= 1
        continue
    end
    
    % get ranks for patients
    % wdegrank
    
    [~,r] = sort(patients.connectome(a).wdeg);
    rankV(r) = 1:numel(patients.connectome(a).wdeg);
    patients.connectome(a).wdegrank = (rankV)';
    
    % avecontrank
    
    [~,r] = sort(patients.connectome(a).avecont);
    rankV(r) = 1:numel(patients.connectome(a).avecont);
    patients.connectome(a).avecontrank = (rankV)';
    
    % modalcontrank
   
    [~,r] = sort(patients.connectome(a).modalcont);
    rankV(r) = 1:numel(patients.connectome(a).modalcont);
    patients.connectome(a).modalcontrank = (rankV)';
    
    % calculate z-score
    
    for b = 1:253
        zwdeg(b) = (patients.connectome(a).wdegrank(b) - controlwdegrankmean(b))/controlwdegrankstd(b);
        zavecont(b) = (patients.connectome(a).avecontrank(b) - controlavecontrankmean(b))/controlavecontrankstd(b);
        zmodalcont(b) = (patients.connectome(a).modalcontrank(b) - controlmodalcontrankmean(b))/controlmodalcontrankstd(b); 
    end
    
    patients.connectome(a).zwdeg = zwdeg';
    patients.connectome(a).zavecont = zavecont';
    patients.connectome(a).zmodalcont = zmodalcont';
    
    
    
    resectedParcels = patients.connectome(a).resectedparcels;
    for x = 1:length(cortexonly)
        location = cortexonly(x);
        aveContZRank(end+1) = patients.connectome(a).zavecont(location);
        modalContZRank(end+1) = patients.connectome(a).zmodalcont(location);
        wDegZRank(end+1) = patients.connectome(a).zwdeg(location);
        subject{end+1} = patients.connectome(a).sub;
        ParcelLocation(end+1) = location;

        
        % assign '1' to resected parcels, '0' to the rest
        if ismember(location, resectedParcels)
            therapeuticResection(end+1) = 1;
        else
            therapeuticResection(end+1) = 0;
        end
        
        LPulvinarConnectivity(end+1) = patients.connectome(a).connectome(location, 235);
        RPulvinarConnectivity(end+1) = patients.connectome(a).connectome(location, 109);
        LAnteriorConnectivity(end+1) = patients.connectome(a).connectome(location, 236);   
        RAnteriorConnectivity(end+1) = patients.connectome(a).connectome(location, 110);   
        LMedioDorsalConnectivity(end+1) = patients.connectome(a).connectome(location, 237);   
        RMedioDorsalConnectivity(end+1) = patients.connectome(a).connectome(location, 111);   
        LVentralLateroDorsalConnectivity(end+1) = patients.connectome(a).connectome(location, 238);   
        RVentralLateroDorsalConnectivity(end+1) = patients.connectome(a).connectome(location, 112);   
        LCentralLateralLateralPosteriorMedialPulvinarConnectivity(end+1) = patients.connectome(a).connectome(location, 239);   
        RCentralLateralLateralPosteriorMedialPulvinarConnectivity(end+1) = patients.connectome(a).connectome(location, 113);   
        LVentralAnteriorConnectivity(end+1) = patients.connectome(a).connectome(location, 240);
        RVentralAnteriorConnectivity(end+1) = patients.connectome(a).connectome(location, 114);
        LVentralLateroVentralConnectivity(end+1) = patients.connectome(a).connectome(location, 241);
        RVentralLateroVentralConnectivity(end+1) = patients.connectome(a).connectome(location, 115);
        
    end
end

subject = strcat(subject, '(patient)');

%% Control data

% for a = 1:length(controls.connectome)
%     for x = 1:length(cortexonly)
%         location = cortexonly(x);
%         avecont(end+1) = controls.connectome(a).avecont(location);
%         modalcont(end+1) = controls.connectome(a).modalcont(location);
%         wdeg(end+1) = controls.connectome(a).wdeg(location);
%         subject{end+1} = controls.connectome(a).sub;
%         ParcelLocation(end+1) = location;
%         therapeuticResection(end+1) = 0;
%         
%         LPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 235);
%         RPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 109);
%         LAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 236);   
%         RAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 110);   
%         LMedioDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 237);   
%         RMedioDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 111);   
%         LVentralLateroDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 238);   
%         RVentralLateroDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 112);   
%         LCentralLateralLateralPosteriorMedialPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 239);   
%         RCentralLateralLateralPosteriorMedialPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 113);   
%         LVentralAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 240);
%         RVentralAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 114);
%         LVentralLateroVentralConnectivity(end+1) = controls.connectome(a).connectome(location, 241);
%         RVentralLateroVentralConnectivity(end+1) = controls.connectome(a).connectome(location, 115);
%         
%     end
% end

multiparameters = [ParcelLocation(:),aveContZRank(:),modalContZRank(:),wDegZRank(:),LPulvinarConnectivity(:),RPulvinarConnectivity(:),LAnteriorConnectivity(:),RAnteriorConnectivity(:),LMedioDorsalConnectivity(:),RMedioDorsalConnectivity(:),LVentralLateroDorsalConnectivity(:),RVentralLateroDorsalConnectivity(:),LCentralLateralLateralPosteriorMedialPulvinarConnectivity(:),RCentralLateralLateralPosteriorMedialPulvinarConnectivity(:),LVentralAnteriorConnectivity(:),RVentralAnteriorConnectivity(:),LVentralLateroVentralConnectivity(:),RVentralLateroVentralConnectivity(:)];

%% Neural network on prepared data

[COEFF,SCORE,latent,tsquare] = pca(multiparameters);
 PCA=cumsum(latent)./sum(latent);
 PCA(PCA>0.99)=[];
NumberHiddenNodes=length(PCA);

% NumberHiddenNodes=1;

hiddenLayerSize=[NumberHiddenNodes];
 net=patternnet(hiddenLayerSize);
 net.divideParam.trainRatio=70/100;
 net.divideParam.valRatio=15/100;
 net.divideParam.testRatio=15/100;
 [net,tr]=train(net,multiparameters',therapeuticResection,'showResources','yes');
 
% X{1} = TestMulti;
% [Y] = net(X);
% Out = Y{1};

