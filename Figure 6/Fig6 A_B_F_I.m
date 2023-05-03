%% Figure 6
%% Gather the first licks in dataset
firstLicks = cell(8,1);
firstLicksEarly = cell(8,1);
firstLicksLate = cell(8,1);
firstAnsLick = cell(8,1);
numLicks= cell(8,1);
numLicks_2s= cell(8,1); %number of licks within 2sec after first lick
numLicks_1s= cell(8,1); %number of licks within 1sec after first lick
numLicks_ans=cell(8,1); %number of licks within answer period
numLicksEarly= cell(8,1);
numLicksLate = cell(8,1);
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

answerPeriod=2.08;
for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
   
    for i = useSessions
    numLicks_1stmp=zeros(length(M(mouse).summary(i).trialStart),1);
    numLicks_2stmp=zeros(length(M(mouse).summary(i).trialStart),1);
    numLicks_anstmp=zeros(length(M(mouse).summary(i).trialStart),1);
    firstAnsLicktmp=zeros(length(M(mouse).summary(i).trialStart),1);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            if ~isempty(M(mouse).summary(i).cleanLicks{t})
                idx1= find (M(mouse).summary(i).cleanLicks{t} < M(mouse).summary(i).cleanLicks{t}(1)+1);
                numLicks_1stmp(t)=numel(idx1);
                idx2= find (M(mouse).summary(i).cleanLicks{t} < M(mouse).summary(i).cleanLicks{t}(1)+2);
                numLicks_2stmp(t)=numel(idx2);
%             else
%                 numLicks_1stmp(t)=NaN;
%                 numLicks_2stmp(t)=NaN;
            end
        end
        for t = 1:length(M(mouse).summary(i).trialStart)
            if ~isempty(cell2mat(M(mouse).summary(i).answerLickTime(t)))
                idx3= find (M(mouse).summary(i).cleanLicks{t}>=answerPeriod & M(mouse).summary(i).cleanLicks{t}<=answerPeriod+1);
                numLicks_anstmp(t)=numel(idx3);
%             else
%                 numLicks_anstmp(t)=NaN;
            end    
        end
        for t = 1:length(M(mouse).summary(i).trialStart)
            f2=M(mouse).summary(i).cleanLicks{t};
            f3=f2(find(M(mouse).summary(i).cleanLicks{t}>=answerPeriod));
            if ~isempty(f3)
                firstAnsLicktmp(t)=min(f3);
            else
                firstAnsLicktmp(t)=NaN;
            end
        end
          
        
        
     numLicks_1s{mouse}=vertcat(numLicks_1s{mouse},numLicks_1stmp);
     numLicks_2s{mouse}=vertcat(numLicks_2s{mouse},numLicks_2stmp);
     numLicks_ans{mouse}=vertcat(numLicks_ans{mouse},numLicks_anstmp);
     firstAnsLick{mouse}=vertcat(firstAnsLick{mouse},firstAnsLicktmp);  
    end
end

%% compare the lick align according to first lick time
samplePeriod=1.08;
answerPeriod=2.08;
ispre = cell(8,1);  %first lick happen before pole onset cue
ismid = cell(8,1);    %first lick happen between sampling and answer period
ispost = cell(8,1); % first lick happen after answer period
issample=cell(8,1); %first lick happended during sampling period
isans=cell(8,1); %first lick happened during answer period
for mouse=1:8
    ispre{mouse}=zeros(length(firstLicks{mouse}),1);
    ispost{mouse}=zeros(length(firstLicks{mouse}),1);
    ismid{mouse}=zeros(length(firstLicks{mouse}),1);
    issample{mouse}=zeros(length(firstLicks{mouse}),1);
    isans{mouse}=zeros(length(firstLicks{mouse}),1);
    for k=1:length(firstLicks{mouse})
       
            if firstLicks{mouse}(k)<samplePeriod      %flag the trials first lick happen before smapling period
                ispre{mouse}(k)=1;    
            end
            if firstLicks{mouse}(k)>answerPeriod      %flag the trials first lick happen after answer period 
                ispost{mouse}(k)=1;
            end
            if  firstLicks{mouse}(k)<= answerPeriod+1 & firstLicks{mouse}(k)>=samplePeriod     % flag the tirals first lick happen between samplimng and answer period
                ismid{mouse}(k)=1;
            end
            
            if  firstLicks{mouse}(k)>= answerPeriod & firstLicks{mouse}(k)<=answerPeriod+1 
                isans{mouse}(k)=1;
            end
            
            if  firstLicks{mouse}(k)>= samplePeriod & firstLicks{mouse}(k)<=answerPeriod
                issample{mouse}(k)=1;
            end
      
    end
      
end


%% Get the Ach response (16 frames before trial start as baseline)

baseline = [-16:-1]; % frames
trialFrames = [0:153]; % only include first 10 seconds of trial
preLickPad = -16;
preLickPad3 = -32;
baseAch = cell(8,1);
trialAch = cell(8,1);
trialDFF = cell(8,1);
goodTrial = cell(8,1);
rewardTrial = cell(8,1);
goodTrial = cell(8,1);
firstLickDFF = cell(8,1);
firstLickDFF2= cell(8,1);
firstLickDFF3= cell(8,1);
firstAnsLickDFF= cell(8,1);
firstLickAch = cell(8,1);
firstLickAch3 = cell(8,1);
firstAnsLickAch = cell(8,1);
isExpert = cell(8,1);
gotReward = cell(8,1);
isBeginner = cell(8,1);
baseline2 = [-16:-1]; % frames
baseline3 = [-32:-17];
baseAch2 = cell(8,1);
baseAch3 = cell(8,1);
isSession= cell(8,1);
isHit = cell(8,1);
isMiss = cell(8,1);
isCR = cell(8,1);
isFA = cell(8,1);
isgoodFL = cell(8,1);
isbadFL = cell(8,1);
trialAmp= cell(8,1); %whisking amplitude
trialFrames_whisk =[0:6*311]; % only include first 1481 frames of trial in whisking imaging frames

for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    
    for i = useSessions
        
        % pad frames that don't exist past last trial with NaN
        rawAch = nan(M(mouse).summary(i).trialStart(end)+trialFrames(end)+154,1);
        rawAch(1:length(M(mouse).summary(i).maskedFOVraw)) = M(mouse).summary(i).maskedFOVraw;
        
        %Preallocate
        
        baseAchTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        trialAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        goodTrialTmp = (M(mouse).summary(i).trialStart >1544)';
        firstLickAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        firstLickAch3Tmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        firstAnsLickAchTmp= zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        isExpertTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        gotRewardTmp = M(mouse).summary(i).trialMatrix(:,1);
        isBeginnerTmp= zeros(length(M(mouse).summary(i).trialStart),1);
        baseAchTmp2= zeros(length(M(mouse).summary(i).trialStart),1);   %use 16 frames before first lick as baseline
        baseAchTmp3= zeros(length(M(mouse).summary(i).trialStart),1);
        isSessionTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isgoodFLTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isbadFLTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isHitTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isMissTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isCRTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isFATmp=zeros(length(M(mouse).summary(i).trialStart),1);        
        trialAmpTmp=NaN(length(M(mouse).summary(i).trialStart),length(trialFrames_whisk));
        
        
        isSessionTmp(:)=i;
        
        if i >= useSessions(end-2);
            isExpertTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        if i <= useSessions(3);
            isBeginnerTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            baseAchTmp(t) = mean(rawAch(M(mouse).summary(i).trialStart(t)+baseline));            
            trialAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames);
            if isempty(M(mouse).summary(i).amplitude{t,1})
            trialAmpTmp(t,:)=NaN;    
            else
            trialAmpTmp(t,1:min([length(trialFrames_whisk) length(M(mouse).summary(i).amplitude{t,1})]))=M(mouse).summary(i).amplitude{t,1}(1:min([length(trialFrames_whisk) length(M(mouse).summary(i).amplitude{t,1})]));
            end
            
            if isempty(fl{t})
                
                firstLickAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad + round(1.7*15.44));
                
                firstLickAch3Tmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad3 + round(1.7*15.44));
                
                baseAchTmp2(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(1.7*15.44)+baseline2));
                
                baseAchTmp3(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(1.7*15.44)+baseline3));
                
                isgoodFLTmp(t)=0;
                
                isbadFLTmp(t)=0;
                
            else
                
                firstLickAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad+round(15.44*fl{t}));
                
                firstLickAch3Tmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad3+round(15.44*fl{t}));
                
                baseAchTmp2(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(min(M(mouse).summary(i).licks{t})*15.44)+baseline2)); %use 16 frames before first lick as baseline
                
                baseAchTmp3(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(min(M(mouse).summary(i).licks{t})*15.44)+baseline3));
                
                if fl{t}<0.3
                    isgoodFLTmp(t)=0;
                    
                    isbadFLTmp(t)=1;
                else
                    isgoodFLTmp(t)=1;
                    
                    isbadFLTmp(t)=0;
                end
            end
        end
        
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            f2=M(mouse).summary(i).cleanLicks{t};
            f3=f2(find(M(mouse).summary(i).cleanLicks{t}>=answerPeriod));
            if isempty(f3)
                firstAnsLickAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad3 + round(2.08*15.44));
            else
                firstAnsLickAchTmp(t,:)= rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad3+round(15.44*(min(f3))));
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
        trialAch{mouse} = vertcat(trialAch{mouse},trialAchTmp);
        goodTrial{mouse} = vertcat(goodTrial{mouse},goodTrialTmp);
        firstLickAch{mouse} = vertcat(firstLickAch{mouse},firstLickAchTmp);
        firstLickAch3{mouse} = vertcat(firstLickAch3{mouse},firstLickAch3Tmp);
        firstAnsLickAch{mouse}=vertcat(firstAnsLickAch{mouse},firstAnsLickAchTmp);
        isExpert{mouse} = vertcat(isExpert{mouse},isExpertTmp);
        gotReward{mouse} = vertcat(gotReward{mouse},gotRewardTmp);
        isBeginner{mouse}=vertcat(isBeginner{mouse},isBeginnerTmp);
        baseAch2{mouse} = vertcat(baseAch2{mouse},baseAchTmp2);
        baseAch3{mouse} = vertcat(baseAch3{mouse},baseAchTmp3);
        isSession{mouse}= vertcat(isSession{mouse}, isSessionTmp);
        isgoodFL{mouse}= vertcat(isgoodFL{mouse}, isgoodFLTmp);
        isbadFL{mouse}= vertcat(isbadFL{mouse}, isbadFLTmp);
        isHit{mouse}= vertcat(isHit{mouse}, isHitTmp);
        isMiss{mouse}= vertcat(isMiss{mouse}, isMissTmp);
        isFA{mouse}= vertcat(isFA{mouse}, isFATmp);
        isCR{mouse}= vertcat(isCR{mouse}, isCRTmp);          
        trialAmp{mouse}=vertcat(trialAmp{mouse},trialAmpTmp);
        
    end
    goodTrial{mouse} = logical(goodTrial{mouse});
    trialDFF{mouse} = trialAch{mouse}./repmat(baseAch{mouse},1,size(trialAch{mouse},2))-1;
    firstLickDFF{mouse} = firstLickAch{mouse}./baseAch{mouse}-1;
    firstLickDFF2{mouse} = firstLickAch{mouse}./baseAch2{mouse}-1;  %use 16 frames before first lick as baseline
    firstLickDFF3{mouse} = firstLickAch3{mouse}./baseAch3{mouse}-1;  %use -32:-17 frames to first lick as baseline, and pad the trials with 32 frames
    firstAnsLickDFF{mouse}=firstAnsLickAch{mouse}./baseAch3{mouse}-1; %use -32:-17 frames to first lick as baseline, and pad the trials with 32 frames aligned to first answer lick
    %     firstLicktDFF{mouse} = zeros(size(trialDFF{mouse},1),154);
    %     for t = 1:size(trialDFF{mouse},1);
    %         if isnan(firstLicks{mouse}(t)) % if there isn't a lick align to trial start
    %             irstLicktDFF{mouse}(t,:) = trialDFF{mouse}(t,1:154);
    %         else
    %             firstLicktDFF{mouse}(t,:) = trialDFF{mouse}(t,ceil(15.44*firstLicks{mouse}(t))+[-31:153]);
    %         end
    %     end
    %
    
end
%% Fig6A plot first lick aligned average response has lick expert vs beginner
BeginnerlickalignTrace=NaN(8,size(firstLickDFF{1,1},2));
for mouse=1:8
BeginnerlickalignTrace(mouse,:)=nanmean(firstLickDFF{mouse}(goodTrial{mouse}  & numLicks{mouse}~=0 & isBeginner{mouse},:)); 
end
ExpertlickalignTrace=NaN(8,size(firstLickDFF{1,1},2));
for mouse=1:8
ExpertlickalignTrace(mouse,:)=nanmean(firstLickDFF{mouse}(goodTrial{mouse} & numLicks{mouse}~=0 & isExpert{mouse},:));
end

figure(6)
shadedErrorBar([],nanmean(BeginnerlickalignTrace),std(BeginnerlickalignTrace)/sqrt(size(BeginnerlickalignTrace,1)),'lineprops',{'color','[0.5 0.5 0.5]','linewidth',3})
shadedErrorBar([],nanmean(ExpertlickalignTrace),std(ExpertlickalignTrace)/sqrt(size(ExpertlickalignTrace,1)),'lineprops',{'color','k','linewidth',3})

ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([17-1*15.44:15.44:17+10*15.44]);
        xticklabels({'-1','0','1','2','3','4','5','6','7','8','9','10'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Lick Trials Beginner Sessions','Lick Trials Expert Sessions'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['LickAlgnBeginnerExpertComparison'])
print(gcf,'-depsc2',['LickAlignBeginnerExpertComparison'])


%use 16 frames before first lick as baseline
BeginnerlickalignTrace=NaN(8,size(firstLickDFF2{1,1},2));
for mouse=1:8
BeginnerlickalignTrace(mouse,:)=nanmean(firstLickDFF2{mouse}(goodTrial{mouse}  & numLicks{mouse}~=0 & isBeginner{mouse},:)); 
end
ExpertlickalignTrace=NaN(8,size(firstLickDFF2{1,1},2));
for mouse=1:8
ExpertlickalignTrace(mouse,:)=nanmean(firstLickDFF2{mouse}(goodTrial{mouse} & numLicks{mouse}~=0 & isExpert{mouse},:));
end

figure(6)
shadedErrorBar([],nanmean(BeginnerlickalignTrace),std(BeginnerlickalignTrace)/sqrt(size(BeginnerlickalignTrace,1)),'lineprops',{'color','[0.5 0.5 0.5]','linewidth',3})
shadedErrorBar([],nanmean(ExpertlickalignTrace),std(ExpertlickalignTrace)/sqrt(size(ExpertlickalignTrace,1)),'lineprops',{'color','k','linewidth',3})

ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([17-1*15.44:15.44:17+10*15.44]);
        xticklabels({'-1','0','1','2','3','4','5','6','7','8','9','10'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Lick Trials Beginner Sessions','Lick Trials Expert Sessions'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['LickAlgnBeginnerExpertComparison_16framesbeforefirstlickbaseline'])
print(gcf,'-depsc2',['LickAlgnBeginnerExpertComparison_16framesbeforefirstlickbaseline'])


%use -32:-17 frames before first lick as baseline and pad 32 frames before
%firs tlick
BeginnerlickalignTrace=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
BeginnerlickalignTrace(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse}  & numLicks{mouse}~=0 & isBeginner{mouse},:)); 
end
ExpertlickalignTrace=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
ExpertlickalignTrace(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}~=0 & isExpert{mouse},:));
end

figure(7)
shadedErrorBar([],nanmean(BeginnerlickalignTrace),std(BeginnerlickalignTrace)/sqrt(size(BeginnerlickalignTrace,1)),'lineprops',{'color','[0.5 0.5 0.5]','linewidth',3})
shadedErrorBar([],nanmean(ExpertlickalignTrace),std(ExpertlickalignTrace)/sqrt(size(ExpertlickalignTrace,1)),'lineprops',{'color','k','linewidth',3})

ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Lick Trials Beginner Sessions','Lick Trials Expert Sessions'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['LickAlgnBeginnerExpertComparison32framesbeforefirstlickasbaseline'])
print(gcf,'-depsc2',['LickAlgnBeginnerExpertComparison32framesbeforefirstlickasbaseline'])

%get the number for the difference
for mouse=1:8
    BeginnerResponse(mouse)=mean(BeginnerlickalignTrace(mouse,33:49));
    ExpertResponse(mouse)=mean(ExpertlickalignTrace(mouse,33:49));
    ExpertBeginnerDiff(mouse)=ExpertResponse(mouse)/BeginnerResponse(mouse);
end

%% Fig6B plot first lick align response against correct rate
CorrectRate= cell(8,1);
FirstLickAlignResponse= cell(8,1);
for mouse=1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    for k=1:length(useSessions)
        CorrectRate{mouse}(k)=M(mouse).summary(useSessions(k)).CorrectRate;
        FirstLickAlignResponse{mouse}(k,:)=nanmean(firstLickDFF{mouse}(goodTrial{mouse} & isSession{mouse}==useSessions(k) & numLicks{mouse}~=0,:));
    end
end


for mouse=1:8
    for k=1:size(FirstLickAlignResponse{mouse},1)
    AvgFirstlickResponse{mouse}(k)=mean(FirstLickAlignResponse{mouse}(k,16:32));
    end    
end



a=horzcat(CorrectRate{:});
b=horzcat(AvgFirstlickResponse{:});
         
[fp  G]=fit(a',b','poly1');



figure(12);clf
sz=25
for mouse=1:8
     hold on
scatter(CorrectRate{mouse},AvgFirstlickResponse{mouse},sz,'MarkerEdgeColor',[mouse/8 mouse/8 mouse/8],...
              'MarkerFaceColor',[mouse/8 mouse/8 mouse/8])
end   
hold on 
plot(fp,'k')
xlabel('Correct Rate','FontSize', 20,'FontWeight','bold')
ylabel('DF/F','FontSize', 20,'FontWeight','bold')   
print(gcf,'-dpng','-r300',['16framesMeanPostFirstLickAgainstPerformance'])
print(gcf,'-depsc2',['16framesMeanPostFirstLickAgainstFirstLickTime']) 

%% Figure 6F plot first lick aligned average response no lick expert vs beginner
BeginnernolickalignTrace=NaN(8,size(firstLickDFF{1,1},2));
for mouse=1:8
BeginnernolickalignTrace(mouse,:)=nanmean(firstLickDFF{mouse}(goodTrial{mouse}  & numLicks{mouse}==0 & isBeginner{mouse},:)); 
end
ExpertnolickalignTrace=NaN(8,size(firstLickDFF{1,1},2));
for mouse=1:8
ExpertnolickalignTrace(mouse,:)=nanmean(firstLickDFF{mouse}(goodTrial{mouse} & numLicks{mouse}==0 & isExpert{mouse},:));
end

figure(5)
shadedErrorBar([],nanmean(BeginnernolickalignTrace),std(BeginnernolickalignTrace)/sqrt(size(BeginnernolickalignTrace,1)),'lineprops',{'color','[0.5 0.5 0.5]','linewidth',3})
shadedErrorBar([],nanmean(ExpertnolickalignTrace),std(ExpertnolickalignTrace)/sqrt(size(ExpertnolickalignTrace,1)),'lineprops',{'color','k','linewidth',3})

ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([17-1*15.44:15.44:17+10*15.44]);
        xticklabels({'-1','0','1','2','3','4','5','6','7','8','9','10'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'No Lick Beginner Sessions','No Lick Expert Sessions'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig3_NoLickBeginnerExpertComparison'])
print(gcf,'-depsc2',['fig3_NoLickBeginnerExpertComparison'])

%% Fig 6I plot first lick and 0 llick diff between beginner and expert, fig 6i
OneLickNolickDiff=zeros(8,2);
for mouse=1:8
    OneLickNolickDiff(mouse,1)=for_each_lick_avg_Begin{2,mouse}-for_each_lick_avg_Begin{1,mouse};
    OneLickNolickDiff(mouse,2)=for_each_lick_avg_Exp{2,mouse}-for_each_lick_avg_Exp{1,mouse};
end
figure(1);clf
for mouse=1:8
    plot(0.5,OneLickNolickDiff(mouse,1),'.','color',[.5 .5 .5],'MarkerSize',32)
    hold on
    plot(1.5,OneLickNolickDiff(mouse,2),'.','color','k','MarkerSize',32)
    plot([0.5 1.5],[OneLickNolickDiff(mouse,1) OneLickNolickDiff(mouse,2)],'-','linewidth',2,'color',[.8 .8 .8])
end
hold on
plot(0.5,mean(OneLickNolickDiff(:,1)),'r.','MarkerSize',36)
plot(1.5,mean(OneLickNolickDiff(:,2)),'r.','MarkerSize',36)
sigline([0.5,1.5],'p=0.0090')
hold on
x=[0.5,1.5];
y=[mean(OneLickNolickDiff(:,1)),mean(OneLickNolickDiff(:,2))];
sd_vct=[std(OneLickNolickDiff(:,1))./8.^.5 std(OneLickNolickDiff(:,2))./8.^.5];
errorbar(x,y,sd_vct, 'rp')
xlim([0 1.8])
xticks([0.5 1.5])
xticklabels({'Beginner','Expert'})
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
ax = gca;
ax.FontSize = 20; 
f = figure(1);
f.Position = [100 100 600 600];
print(gcf,'-depsc2',['OneLickNoLicDiffkBeginnerExpertComparison']);
print(gcf,'-dpng','-r300',['OneLickNoLicDiffkBeginnerExpertComparison']);
%  [h, p] = ttest(OneLickNolickDiff(:,1), OneLickNolickDiff(:,2);
%     pVal = p

