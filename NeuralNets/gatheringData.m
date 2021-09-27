patients = load('../Patients/controllabilities.mat');
controls = load('../Controls/controllabilities.mat'); 
vns = load('../VNS/controllabilities.mat');
load('../labels.mat')

avecont = [];
modalcont = [];
wdeg = [];
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


for a = 1:length(patients.connectome)
    resectedParcels = patients.connectome(a).resectedparcels;
    for x = 1:length(cortexonly)
        location = cortexonly(x);
        avecont(end+1) = patients.connectome(a).avecont(location);
        modalcont(end+1) = patients.connectome(a).modalcont(location);
        wdeg(end+1) = patients.connectome(a).wdeg(location);
        subject{end+1} = patients.connectome(a).sub;
        ParcelLocation(end+1) = location;
        
        engel = patients.connectome(a).Engel;
        if ismember(location, resectedParcels) && engel == 1
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


for a = 1:length(controls.connectome)
    for x = 1:length(cortexonly)
        location = cortexonly(x);
        avecont(end+1) = controls.connectome(a).avecont(location);
        modalcont(end+1) = controls.connectome(a).modalcont(location);
        wdeg(end+1) = controls.connectome(a).wdeg(location);
        subject{end+1} = controls.connectome(a).sub;
        ParcelLocation(end+1) = location;
        therapeuticResection(end+1) = 0;
        
        LPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 235);
        RPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 109);
        LAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 236);   
        RAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 110);   
        LMedioDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 237);   
        RMedioDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 111);   
        LVentralLateroDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 238);   
        RVentralLateroDorsalConnectivity(end+1) = controls.connectome(a).connectome(location, 112);   
        LCentralLateralLateralPosteriorMedialPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 239);   
        RCentralLateralLateralPosteriorMedialPulvinarConnectivity(end+1) = controls.connectome(a).connectome(location, 113);   
        LVentralAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 240);
        RVentralAnteriorConnectivity(end+1) = controls.connectome(a).connectome(location, 114);
        LVentralLateroVentralConnectivity(end+1) = controls.connectome(a).connectome(location, 241);
        RVentralLateroVentralConnectivity(end+1) = controls.connectome(a).connectome(location, 115);
        
    end
end

multiparameters = [ParcelLocation(:),avecont(:),modalcont(:),wdeg(:),LPulvinarConnectivity(:),RPulvinarConnectivity(:),LAnteriorConnectivity(:),RAnteriorConnectivity(:),LMedioDorsalConnectivity(:),RMedioDorsalConnectivity(:),LVentralLateroDorsalConnectivity(:),RVentralLateroDorsalConnectivity(:),LCentralLateralLateralPosteriorMedialPulvinarConnectivity(:),RCentralLateralLateralPosteriorMedialPulvinarConnectivity(:),LVentralAnteriorConnectivity(:),RVentralAnteriorConnectivity(:),LVentralLateroVentralConnectivity(:),RVentralLateroVentralConnectivity(:)];

%% Neural network on prepared data

NumberHiddenNodes=9;


hiddenLayerSize=[NumberHiddenNodes];
 net=patternnet(hiddenLayerSize);
 net.divideParam.trainRatio=70/100;
 net.divideParam.valRatio=15/100;
 net.divideParam.testRatio=15/100;
 [net,tr]=train(net,multiparameters',therapeuticResection,'showResources','yes');
 
% X{1} = TestMulti;
% [Y] = net(X);
% Out = Y{1};

