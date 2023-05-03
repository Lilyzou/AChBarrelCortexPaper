%% Gather the first licks in dataset
firstLicks = cell(8,1)
firstLicksEarly = cell(8,1)
firstLicksLate = cell(8,1)
numLicks= cell(8,1)
numLicksEarly= cell(8,1)
numLicksLate = cell(8,1)
%use the sessions with whisker data as useSessions
for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    
    for i = useSessions(end-2:end)
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        fl(cellfun(@isempty,fl)) = {NaN};
        firstLicksLate{mouse} = vertcat(firstLicksLate{mouse}, fl);
        numLicksLate{mouse} = vertcat(numLicksLate{mouse}, cellfun(@numel,M(mouse).summary(i).cleanLicks,'uniformoutput',0));
    end
    
    
    for i = useSessions(1:3)
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        fl(cellfun(@isempty,fl)) = {NaN};
        firstLicksEarly{mouse} = vertcat(firstLicksEarly{mouse}, fl);
        numLicksEarly{mouse} = vertcat(numLicksEarly{mouse}, cellfun(@numel,M(mouse).summary(i).cleanLicks,'uniformoutput',0));
        
    end
    
    
    for i = useSessions
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        fl(cellfun(@isempty,fl)) = {NaN};
        firstLicks{mouse} = vertcat(firstLicks{mouse}, fl);
        numLicks{mouse} = vertcat(numLicks{mouse}, cellfun(@numel,M(mouse).summary(i).cleanLicks,'uniformoutput',0));
        
    end
    firstLicks{mouse} = cell2mat(firstLicks{mouse});
    numLicks{mouse}  = cell2mat(numLicks{mouse});
           
end



%% Get the Ach response (16 frames before trial start as baseline)

baseline = [-16:-1]; % frames
baseline2=[9:16];
trialFrames = [0:153]; % only include first 10 seconds of trial
trialFrames_whisk =[0:6*311]; % only include first 1481 frames of trial in whisking imaging frames
preLickPad = -16;
baseAch = cell(8,1);
baseAch2 = cell(8,1);
trialAch = cell(8,1);
trialDFF = cell(8,1);
trialDFF2 = cell(8,1);
goodTrial = cell(8,1);
rewardTrial = cell(8,1);
goodTrial = cell(8,1);
firstLicktDFF = cell(8,1);
firstLickAch = cell(8,1);
isExpert = cell(8,1);
gotReward = cell(8,1);
isBeginner = cell(8,1);
trialAmp= cell(8,1);

isSession= cell(8,1);
isHit = cell(8,1);
isMiss = cell(8,1);
isCR = cell(8,1);
isFA = cell(8,1);


for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    
    for i = useSessions
        
        % pad frames that don't exist past last trial with NaN
        rawAch = nan(M(mouse).summary(i).trialStart(end)+trialFrames(end)+154,1);
        rawAch(1:length(M(mouse).summary(i).maskedFOVraw)) = M(mouse).summary(i).maskedFOVraw;
        
        %Preallocate
        
        baseAchTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        baseAchTmp2 = zeros(length(M(mouse).summary(i).trialStart),1);
        trialAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        goodTrialTmp = (M(mouse).summary(i).trialStart >1544)';
        firstLickAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        isExpertTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        gotRewardTmp = M(mouse).summary(i).trialMatrix(:,1);
        isBeginnerTmp= zeros(length(M(mouse).summary(i).trialStart),1);
        trialAmpTmp=NaN(length(M(mouse).summary(i).trialStart),length(trialFrames_whisk));
        isHitTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isMissTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isCRTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isFATmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isSessionTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        
        if i >= useSessions(end-2);
            isExpertTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        if i <= useSessions(3);
            isBeginnerTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            baseAchTmp(t) = mean(rawAch(M(mouse).summary(i).trialStart(t)+baseline));
            baseAchTmp2(t) = mean(rawAch(M(mouse).summary(i).trialStart(t)+baseline2));
            trialAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames);
            if isempty(M(mouse).summary(i).amplitude{t,1})
                trialAmpTmp(t,:)=NaN;
            else
                trialAmpTmp(t,1:min([length(trialFrames_whisk) length(M(mouse).summary(i).amplitude{t,1})]))=M(mouse).summary(i).amplitude{t,1}(1:min([length(trialFrames_whisk) length(M(mouse).summary(i).amplitude{t,1})]));
            end
            if isempty(fl{t})
                
                firstLickAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad + round(1.7*15.44));
                
            else
                
                firstLickAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad+round(15.44*fl{t}));
            end
            
        end
              for t = 1:length(M(mouse).summary(i).trialStart)
            if M(mouse).summary(i).trialMatrix(t,1) ==1
                isHitTmp(t) = 1;
            else
                isHitTmp(t) = 0;
            end
            if M(mouse).summary(i).trialMatrix(t,2) ==1
                isMissTmp(t) = 1;
            else
                isMissTmp(t) = 0;
            end
            if M(mouse).summary(i).trialMatrix(t,3) ==1
                isFATmp(t) = 1;
            else
                isFATmp(t) = 0;
            end
            if M(mouse).summary(i).trialMatrix(t,4) ==1
                isCRTmp(t) = 1;
            else
                isCRTmp(t) = 0;
            end
                
        end        
        
        baseAch{mouse} = vertcat(baseAch{mouse},baseAchTmp);
        baseAch2{mouse} = vertcat(baseAch2{mouse},baseAchTmp2);
        trialAch{mouse} = vertcat(trialAch{mouse},trialAchTmp);
        goodTrial{mouse} = vertcat(goodTrial{mouse},goodTrialTmp);
        firstLickAch{mouse} = vertcat(firstLickAch{mouse},firstLickAchTmp);
        isExpert{mouse} = vertcat(isExpert{mouse},isExpertTmp);
        gotReward{mouse} = vertcat(gotReward{mouse},gotRewardTmp);
        isBeginner{mouse}=vertcat(isBeginner{mouse},isBeginnerTmp);
        trialAmp{mouse}=vertcat(trialAmp{mouse},trialAmpTmp);
        isSession{mouse}= vertcat( isSession{mouse}, isSessionTmp);
        isHit{mouse}= vertcat(isHit{mouse}, isHitTmp);
        isMiss{mouse}= vertcat(isMiss{mouse}, isMissTmp);
        isFA{mouse}= vertcat(isFA{mouse}, isFATmp);
        isCR{mouse}= vertcat(isCR{mouse}, isCRTmp);     
    end
    goodTrial{mouse} = logical(goodTrial{mouse});
    trialDFF{mouse} = trialAch{mouse}./repmat(baseAch{mouse},1,size(trialAch{mouse},2))-1;
    trialDFF2{mouse} = trialAch{mouse}./repmat(baseAch2{mouse},1,size(trialAch{mouse},2))-1;
    firstLickDFF{mouse} = firstLickAch{mouse}./baseAch{mouse}-1;
    firstLickDFF2{mouse} = firstLickAch{mouse}./baseAch2{mouse}-1;
    
    %     firstLickDFF{mouse} = zeros(size(trialDFF{mouse},1),154);
    %     for t = 1:size(trialDFF{mouse},1);
    %         if isnan(firstLicks{mouse}(t)) % if there isn't a lick align to trial start
    %             irstLicktDFF{mouse}(t,:) = trialDFF{mouse}(t,1:154);
    %         else
    %             firstLicktDFF{mouse}(t,:) = trialDFF{mouse}(t,ceil(15.44*firstLicks{mouse}(t))+[-31:153]);
    %         end
    %     end
    %
    
end


%% Get no lick trials Ach response heatmap sorted by pole up and pole down twitch amplitude
for mouse=1:8
    goodNoLickTrials{mouse} = goodTrial{mouse} & numLicks{mouse}==0;
    
    goodNoLickTrials_expert{mouse} = goodTrial{mouse} & isExpert{mouse} & numLicks{mouse}==0;
    goodNoLickTrials_beginner{mouse} = goodTrial{mouse} & isBeginner{mouse} & numLicks{mouse}==0;
    
    nolickAch{mouse}=trialDFF2{mouse}(goodNoLickTrials{mouse},:);
    nolickWhisk{mouse}=trialAmp{mouse}(goodNoLickTrials{mouse},:);

    nolickAch_expert{mouse}=trialDFF2{mouse}(goodNoLickTrials_expert{mouse},:);
    nolickWhisk_expert{mouse}=trialAmp{mouse}(goodNoLickTrials_expert{mouse},:);
    
    nolickAch_beginner{mouse}=trialDFF2{mouse}(goodNoLickTrials_beginner{mouse},:);
    nolickWhisk_beginner{mouse}=trialAmp{mouse}(goodNoLickTrials_beginner{mouse},:);    
    
    
    %sort by size of early whisker twitch
    twitchWindow_polein =  336:504; %1 second post pole up
    excludeAmpWindow = {1:310} % first second want to exclude trials with ongoing whisking pre cue
    [~,ampIdx_early] = sort(mean(nolickWhisk{mouse}(:,twitchWindow_polein),2));
    [twitchOnlyIdx_early] = find(mean(nolickWhisk{mouse}(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
    sortedGoodTrialIdx{mouse} = intersect(ampIdx_early,twitchOnlyIdx_early,'stable');
    
    [~,ampIdx_early_beginner] = sort(mean(nolickWhisk_beginner{mouse}(:,twitchWindow_polein),2));
    [twitchOnlyIdx_early_beginner] = find(mean(nolickWhisk_beginner{mouse}(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
    sortedGoodTrialIdx_beginner{mouse} = intersect(ampIdx_early_beginner,twitchOnlyIdx_early_beginner,'stable');
    
    [~,ampIdx_early_expert] = sort(mean(nolickWhisk_expert{mouse}(:,twitchWindow_polein),2));
    [twitchOnlyIdx_early_expert] = find(mean(nolickWhisk_expert{mouse}(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
    sortedGoodTrialIdx_expert{mouse} = intersect(ampIdx_early_expert,twitchOnlyIdx_early_expert,'stable');
    
    
    
        achWindow_polein = 18:33;
    achInCueResponse{mouse} = mean(nolickAch{mouse}(:,achWindow_polein),2);
    twitchInCueResponse{mouse} = mean(nolickWhisk{mouse}(:,twitchWindow_polein),2);
    
    achInCueResponse_expert{mouse} = mean(nolickAch_expert{mouse}(:,achWindow_polein),2);
    twitchInCueResponse_expert{mouse} = mean(nolickWhisk_expert{mouse}(:,twitchWindow_polein),2);
    
    achInCueResponse_beginner{mouse} = mean(nolickAch_beginner{mouse}(:,achWindow_polein),2);
    twitchInCueResponse_beginner{mouse} = mean(nolickWhisk_beginner{mouse}(:,twitchWindow_polein),2);
    
    
end

inCueWhisk = vertcat(twitchInCueResponse{:});
inCueAch = vertcat(achInCueResponse{:});

inCueWhisk_expert = vertcat(twitchInCueResponse_expert{:});
inCueAch_expert = vertcat(achInCueResponse_expert{:});

inCueWhisk_beginner = vertcat(twitchInCueResponse_beginner{:});
inCueAch_beginner = vertcat(achInCueResponse_beginner{:});


noWhiskPropIn =  cellfun(@(x) sum(x<2)/numel(x),twitchInCueResponse);
mean(noWhiskPropIn)
std(noWhiskPropIn)

noWhiskPropIn_beginner =  cellfun(@(x) sum(x<2)/numel(x),twitchInCueResponse_beginner);
mean(noWhiskPropIn_beginner)
std(noWhiskPropIn_beginner)

noWhiskPropIn_expert =  cellfun(@(x) sum(x<2)/numel(x),twitchInCueResponse_expert);
mean(noWhiskPropIn_expert)
std(noWhiskPropIn_expert)


for mouse=1:8
    goodNoLickTrials{mouse} = goodTrial{mouse} & numLicks{mouse}==0;
    goodNoLickTrials_expert{mouse} = goodTrial{mouse} & isExpert{mouse} & numLicks{mouse}==0;
    goodNoLickTrials_beginner{mouse} = goodTrial{mouse} & isBeginner{mouse} & numLicks{mouse}==0;
    
    
    nolickAch{mouse}=trialDFF2{mouse}(goodNoLickTrials{mouse},:);
    nolickWhisk{mouse}=trialAmp{mouse}(goodNoLickTrials{mouse},:);
    
    nolickAch_expert{mouse}=trialDFF2{mouse}(goodNoLickTrials_expert{mouse},:);
    nolickWhisk_expert{mouse}=trialAmp{mouse}(goodNoLickTrials_expert{mouse},:);
    
    nolickAch_beginner{mouse}=trialDFF2{mouse}(goodNoLickTrials_beginner{mouse},:);
    nolickWhisk_beginner{mouse}=trialAmp{mouse}(goodNoLickTrials_beginner{mouse},:);  
    
    
    %sort by size of late whisker twitch
    twitchWindow_poleout =  311*2+[336:504]; 
    excludeAmpWindow = {1:310} % first second want to exclude trials with ongoing whisking pre cue
    [~,ampIdx_early] = sort(mean(nolickWhisk{mouse}(:,twitchWindow_poleout),2));
    [twitchOnlyIdx_early] = find(mean(nolickWhisk{mouse}(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
    sortedGoodTrialIdxOut{mouse} = intersect(ampIdx_early,twitchOnlyIdx_early,'stable');
    
    [~,ampIdx_early_beginner] = sort(mean(nolickWhisk_beginner{mouse}(:,twitchWindow_poleout),2));
    [twitchOnlyIdx_early_beginner] = find(mean(nolickWhisk_beginner{mouse}(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
    sortedGoodTrialIdxOut_beginner{mouse} = intersect(ampIdx_early_beginner,twitchOnlyIdx_early_beginner,'stable');
    
    [~,ampIdx_early_expert] = sort(mean(nolickWhisk_expert{mouse}(:,twitchWindow_poleout),2));
    [twitchOnlyIdx_early_expert] = find(mean(nolickWhisk_expert{mouse}(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
    sortedGoodTrialIdxOut_expert{mouse} = intersect(ampIdx_early_expert,twitchOnlyIdx_early_expert,'stable');
    
        achWindow_poleout = 31+[18:33];
        achWindow_prepoleout = 31+[9:16];
        
    achOutCueResponse{mouse} = mean(nolickAch{mouse}(:,achWindow_poleout),2);
    twitchOutCueResponse{mouse} = mean(nolickWhisk{mouse}(:,twitchWindow_poleout),2);
    
    achOutCueResponse_beginner{mouse} = mean(nolickAch_beginner{mouse}(:,achWindow_poleout),2);
    twitchOutCueResponse_beginner{mouse} = mean(nolickWhisk_beginner{mouse}(:,twitchWindow_poleout),2);
    
    achOutCueResponse_expert{mouse} = mean(nolickAch_expert{mouse}(:,achWindow_poleout),2);
    twitchOutCueResponse_expert{mouse} = mean(nolickWhisk_expert{mouse}(:,twitchWindow_poleout),2);
    
       
    
end

outCueWhisk = vertcat(twitchOutCueResponse{:});
outCueAch = vertcat(achOutCueResponse{:});

outCueWhisk_beginner = vertcat(twitchOutCueResponse_beginner{:});
outCueAch_beginner = vertcat(achOutCueResponse_beginner{:});

outCueWhisk_expert = vertcat(twitchOutCueResponse_expert{:});
outCueAch_expert = vertcat(achOutCueResponse_expert{:});

noWhiskPropOut =  cellfun(@(x) sum(x<2)/numel(x),twitchOutCueResponse);
mean(noWhiskPropOut)
std(noWhiskPropOut)

noWhiskPropOut_beginner =  cellfun(@(x) sum(x<2)/numel(x),twitchOutCueResponse_beginner);
mean(noWhiskPropOut_beginner)
std(noWhiskPropOut_beginner)

noWhiskPropOut_expert =  cellfun(@(x) sum(x<2)/numel(x),twitchOutCueResponse_expert);
mean(noWhiskPropOut_expert)
std(noWhiskPropOut)

%% plot the figure 
%Average Ach response binned by whisking response
figure(6);clf
[sorted sortedBy binBounds]=binslin(inCueWhisk, inCueAch,'equalN', 20)
meanAchSorted = cellfun(@mean,sorted);
stderrAchSorted  = cellfun(@(x)std(x)/numel(x)^.5,sorted);
%bar(binBounds,meanAchSorted,1,'facecolor','k');
%plot(inCueWhisk, inCueAch,'k.','markersize',4)
errorbar((binBounds(1:end-1)+binBounds(2:end))/2,100*meanAchSorted,100*stderrAchSorted,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off
set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
print(gcf,'-depsc2','PoleInSortedAchResponse' ) %This is PoleInAchDotsFit

%Average Ach response binned by whisking response expert
figure(7);clf
[sorted sortedBy binBounds]=binslin(inCueWhisk_expert, inCueAch_expert,'equalN', 20)
meanAchSorted = cellfun(@mean,sorted);
stderrAchSorted  = cellfun(@(x)std(x)/numel(x)^.5,sorted);
%bar(binBounds,meanAchSorted,1,'facecolor','k');
%plot(inCueWhisk, inCueAch,'k.','markersize',4)
errorbar((binBounds(1:end-1)+binBounds(2:end))/2,100*meanAchSorted,100*stderrAchSorted,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off
set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
print(gcf,'-dpng','-r300',['PoleInSortedAchResponse_expert'])
print(gcf,'-depsc2',['PoleInSortedAchResponse_expert'])

%Average Ach response binned by whisking response beginner
figure(8);clf
[sorted sortedBy binBounds]=binslin(inCueWhisk_beginner, inCueAch_beginner,'equalN', 20)
meanAchSorted = cellfun(@mean,sorted);
stderrAchSorted  = cellfun(@(x)std(x)/numel(x)^.5,sorted);
%bar(binBounds,meanAchSorted,1,'facecolor','k');
%plot(inCueWhisk, inCueAch,'k.','markersize',4)
errorbar((binBounds(1:end-1)+binBounds(2:end))/2,100*meanAchSorted,100*stderrAchSorted,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off
set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
print(gcf,'-dpng','-r300',['PoleInSortedAchResponse_beginner'])
print(gcf,'-depsc2',['PoleInSortedAchResponse_beginner'])

%Average Ach response binned by whisking response beginner and expert on
%the same plot
figure(9);clf
[sorted_beginner sortedBy_beginner binBounds_beginner]=binslin(inCueWhisk_beginner, inCueAch_beginner,'equalN', 20)
meanAchSorted_beginner = cellfun(@mean,sorted_beginner);
stderrAchSorted_beginner  = cellfun(@(x)std(x)/numel(x)^.5,sorted_beginner);
[sorted_expert sortedBy_expert binBounds_expert]=binslin(inCueWhisk_expert, inCueAch_expert,'equalN', 20)
meanAchSorted_expert = cellfun(@mean,sorted_expert);
stderrAchSorted_expert  = cellfun(@(x)std(x)/numel(x)^.5,sorted_expert);
%bar(binBounds,meanAchSorted,1,'facecolor','k');
%plot(inCueWhisk, inCueAch,'k.','markersize',4)
errorbar((binBounds_beginner(1:end-1)+binBounds_beginner(2:end))/2,100*meanAchSorted_beginner,100*stderrAchSorted_beginner,'color','[0.5 0.5 0.5]','linewidth',1);
hold on
errorbar((binBounds_expert(1:end-1)+binBounds_expert(2:end))/2,100*meanAchSorted_expert,100*stderrAchSorted_expert,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off
set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
legend({'Early','Expert'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['PoleInSortedAchResponse_beginnerExpert'])
print(gcf,'-depsc2',['PoleInSortedAchResponse_beginnerExpert'])

%plot pole out whisk against ACh signal
figure(11);clf
[sorted sortedBy binBounds]=binslin(outCueWhisk, outCueAch,'equalN', 20)
meanAchSorted = cellfun(@mean,sorted);
stderrAchSorted  = cellfun(@(x)std(x)/numel(x)^.5,sorted);
%bar(binBounds,meanAchSorted,1,'facecolor','k');
%plot(inCueWhisk, inCueAch,'k.','markersize',4)
errorbar((binBounds(1:end-1)+binBounds(2:end))/2,100*meanAchSorted,100*stderrAchSorted,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off 

set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
print(gcf,'-depsc2','PoleoutSortedAchResponse' )


figure(12);clf
[sorted_beginner sortedBy_beginner binBounds_beginner]=binslin(outCueWhisk_beginner, outCueAch_beginner,'equalN', 20)
meanAchSorted_beginner = cellfun(@mean,sorted_beginner);
stderrAchSorted_beginner  = cellfun(@(x)std(x)/numel(x)^.5,sorted_beginner);
%bar(binBounds,meanAchSorted,1,'facecolor','k');
%plot(inCueWhisk, inCueAch,'k.','markersize',4)
errorbar((binBounds_beginner(1:end-1)+binBounds_beginner(2:end))/2,100*meanAchSorted_beginner,100*stderrAchSorted_beginner,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off 

set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
print(gcf,'-dpng','-r300',['PoleoutSortedAchResponse_beginner'])
print(gcf,'-depsc2',['PoleoutSortedAchResponse_beginner'])

figure(13);clf
[sorted_expert sortedBy_expert binBounds_expert]=binslin(outCueWhisk_expert, outCueAch_expert,'equalN', 20)
meanAchSorted_expert = cellfun(@mean,sorted_expert);
stderrAchSorted_expert  = cellfun(@(x)std(x)/numel(x)^.5,sorted_expert);
%bar(binBounds,meanAchSorted,1,'facecolor','k');
%plot(inCueWhisk, inCueAch,'k.','markersize',4)
errorbar((binBounds_expert(1:end-1)+binBounds_expert(2:end))/2,100*meanAchSorted_expert,100*stderrAchSorted_expert,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off 

set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
print(gcf,'-dpng','-r300',['PoleoutSortedAchResponse_expert'])
print(gcf,'-depsc2',['PoleoutSortedAchResponse_expert'])


figure(13);clf
errorbar((binBounds_beginner(1:end-1)+binBounds_beginner(2:end))/2,100*meanAchSorted_beginner,100*stderrAchSorted_beginner,'color','[0.5 0.5 0.5]','linewidth',1);
hold on
errorbar((binBounds_expert(1:end-1)+binBounds_expert(2:end))/2,100*meanAchSorted_expert,100*stderrAchSorted_expert,'k','linewidth',1);
hold on
plot([0 25],[0 0],'k:')
box off 
set(gca,'TickDir','out','linewidth',1)
xlabel('Whisking Amplitude')
ylabel('Ach Cue Response (% dF/F_0)')
set(gcf,'paperposition',[0 0 4 4])
legend({'Early','Expert'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['PoleoutSortedAchResponse_beginnerExpert'])
print(gcf,'-depsc2',['PoleoutSortedAchResponse_beginnerExpert'])