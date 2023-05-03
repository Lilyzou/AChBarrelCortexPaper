% plot grand mean Ach release by trial types, aligned to pole onset and pole down
%% gather pole onset and pole down time
poleOnset = cell(8,1);
poleOnsetEarly = cell(8,1);
poleOnsetLate = cell(8,1);
poleDown= cell(8,1);
poleDownEarly= cell(8,1);
poleDownLate = cell(8,1);
for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    
    for i = useSessions(end-2:end)
        fl = M(mouse).summary(i).poleOnset;            
        poleOnsetLate{mouse} = vertcat(poleOnsetLate{mouse}, fl');
        f2 = M(mouse).summary(i).poleDown;
        poleDownLate{mouse}=vertcat(poleDownLate{mouse}, f2');
    end
    
    
    for i = useSessions(1:3)
        fl = M(mouse).summary(i).poleOnset;
        poleOnsetEarly{mouse} = vertcat(poleOnsetEarly{mouse}, fl');
        f2=M(mouse).summary(i).poleDown;
        poleDownEarly{mouse}=vertcat(poleDownEarly{mouse}, f2');
        
    end
    
    
    for i = useSessions
        fl = M(mouse).summary(i).poleOnset;
        poleOnset{mouse} = vertcat(poleOnset{mouse}, fl');
        f2=M(mouse).summary(i).poleDown;
        poleDown{mouse}=vertcat(poleDown{mouse}, f2');
        
    end
    poleOnset{mouse} = cell2mat(poleOnset{mouse});
    poleDown{mouse}  = cell2mat(poleDown{mouse});
    
end


%% Get the Ach response (16 frames before stimulus(pole onset/ pole down) as baseline)

baseline = [-16:-1]; % frames
trialFrames = [0:40]; % only include 46 frames
preStimPad = -16;
baseAch = cell(8,1);
trialAch = cell(8,1);
trialDFF = cell(8,1);
goodTrial = cell(8,1);
rewardTrial = cell(8,1);
goodTrial = cell(8,1);
poleOnsetDFF = cell(8,1);
poleOnsetDFF2= cell(8,1);
poleDownDFF = cell(8,1);
poleDownDFF2 = cell(8,1);
poleOnsetAch = cell(8,1);
poleDownAch= cell(8,1);
isExpert = cell(8,1);
gotReward = cell(8,1);
isBeginner = cell(8,1);
baseline2 = [-16:-1]; % frames
baseAch2 = cell(8,1);
baseAch3 = cell(8,1);
isSession= cell(8,1); % flag the trial with sessions number
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
        trialAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        goodTrialTmp = (M(mouse).summary(i).trialStart >1544)';
        poleOnsetAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        poleDownAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        isExpertTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        gotRewardTmp = M(mouse).summary(i).trialMatrix(:,1);
        isBeginnerTmp= zeros(length(M(mouse).summary(i).trialStart),1);
        baseAchTmp2= zeros(length(M(mouse).summary(i).trialStart),1);   %use 16 frames before pole onset as baseline
        baseAchTmp3= zeros(length(M(mouse).summary(i).trialStart),1);   %use 16 frames before pole down as baseline
        isSessionTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isHitTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isMissTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isCRTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isFATmp=zeros(length(M(mouse).summary(i).trialStart),1);
        
        
        
        isSessionTmp(:)=i;
        
        if i >= useSessions(end-2);
            isExpertTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        if i <= useSessions(3);
            isBeginnerTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        fl = cellfun(@min,M(mouse).summary(i).poleOnset,'uniformoutput',0);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            baseAchTmp(t) = mean(rawAch(M(mouse).summary(i).trialStart(t)+baseline));   %use 16 frames before trial start as baseline          
            trialAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames);
               
               poleOnsetAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preStimPad+round(15.44*fl{t}));
                
                baseAchTmp2(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(min(M(mouse).summary(i).poleOnset{t})*15.44)+baseline2)); %use 16 frames before pole onset as baseline
            
        end

        f2 = cellfun(@min,M(mouse).summary(i).poleDown,'uniformoutput',0);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
               
               poleDownAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preStimPad+round(15.44*f2{t}));
                
                baseAchTmp3(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(min(M(mouse).summary(i).poleDown{t})*15.44)+baseline2)); %use 16 frames before pole down as baseline
            
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
        poleOnsetAch{mouse} = vertcat(poleOnsetAch{mouse},poleOnsetAchTmp);
        poleDownAch{mouse} = vertcat(poleDownAch{mouse},poleDownAchTmp);
        isExpert{mouse} = vertcat(isExpert{mouse},isExpertTmp);
        gotReward{mouse} = vertcat(gotReward{mouse},gotRewardTmp);
        isBeginner{mouse}=vertcat(isBeginner{mouse},isBeginnerTmp);
        baseAch2{mouse} = vertcat(baseAch2{mouse},baseAchTmp2);
        baseAch3{mouse} = vertcat(baseAch3{mouse},baseAchTmp3);
        isSession{mouse}= vertcat(isSession{mouse}, isSessionTmp);
        isHit{mouse}= vertcat(isHit{mouse}, isHitTmp);
        isMiss{mouse}= vertcat(isMiss{mouse}, isMissTmp);
        isFA{mouse}= vertcat(isFA{mouse}, isFATmp);
        isCR{mouse}= vertcat(isCR{mouse}, isCRTmp);
    end
    goodTrial{mouse} = logical(goodTrial{mouse});
    trialDFF{mouse} = trialAch{mouse}./repmat(baseAch{mouse},1,size(trialAch{mouse},2))-1;
    poleOnsetDFF{mouse} = poleOnsetAch{mouse}./baseAch{mouse}-1;
    poleOnsetDFF2{mouse} = poleOnsetAch{mouse}./baseAch2{mouse}-1;
    poleDownDFF{mouse} = poleDownAch{mouse}./baseAch{mouse}-1;
    poleDownDFF2{mouse} = poleDownAch{mouse}./baseAch3{mouse}-1;
    
end


%% plot pole onset align response by trial types
%plot pole up align response in expert sessions, using 16 frames before
%pole onset as baseline
HitPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
MissPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
CRPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
FAPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
for mouse=1:8
HitPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isHit{mouse} & isExpert{mouse},:));
MissPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isMiss{mouse} & isExpert{mouse},:));
CRPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isCR{mouse} & isExpert{mouse},:));
FAPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isFA{mouse} & isExpert{mouse},:));
end
figure(1);clf
hold on;
shadedErrorBar([],nanmean(HitPoleOnsetAlign),std(HitPoleOnsetAlign)/sqrt(size(HitPoleOnsetAlign,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleOnsetAlign),std(MissPoleOnsetAlign)/sqrt(size(MissPoleOnsetAlign,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleOnsetAlign),std(CRPoleOnsetAlign)/sqrt(size(CRPoleOnsetAlign,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleOnsetAlign),std(FAPoleOnsetAlign)/sqrt(size(FAPoleOnsetAlign,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([15.44 15.44], [-0.005 0.055],':k','linewidth',2)
ylim([-0.005 0.055])
set(gca,'xtick',15.44*[0:2],'xticklabel',[-1:2])
set(gcf,'Position',[100 100 550 550])
ax = gca;
ax.YAxis.Exponent = -3;
xlabel('Time from pole onset (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poleonsetAlignExpertSession'])
print(gcf,'-depsc2',['fig2_poleonsetAlignExpertSession'])


%plot pole up align response in all sessions, using 16 frames before
%pole onset as baseline
HitPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
MissPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
CRPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
FAPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
for mouse=1:8
HitPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isHit{mouse},:));
MissPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isMiss{mouse},:));
CRPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isCR{mouse},:));
FAPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isFA{mouse},:));
end
figure(1);clf
hold on;
shadedErrorBar([],nanmean(HitPoleOnsetAlign),std(HitPoleOnsetAlign)/sqrt(size(HitPoleOnsetAlign,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleOnsetAlign),std(MissPoleOnsetAlign)/sqrt(size(MissPoleOnsetAlign,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleOnsetAlign),std(CRPoleOnsetAlign)/sqrt(size(CRPoleOnsetAlign,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleOnsetAlign),std(FAPoleOnsetAlign)/sqrt(size(FAPoleOnsetAlign,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([15.44 15.44], [-0.005 0.04],':k','linewidth',2)
ylim([-0.005 0.04])
set(gca,'xtick',15.44*[0:2],'xticklabel',[-1:2])
set(gcf,'Position',[100 100 550 550])
ax = gca;
ax.YAxis.Exponent = -3;
xlabel('Time from pole onset (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poleonsetAlignAllSession'])
print(gcf,'-depsc2',['fig2_poleonsetAlignAllSession'])

%plot pole up align response in beginner sessions, using 16 frames before
%pole onset as baseline

HitPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
MissPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
CRPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
FAPoleOnsetAlign=NaN(8,size(poleOnsetDFF2{1,1},2));
for mouse=1:8
HitPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isHit{mouse} & isBeginner{mouse},:));
MissPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isMiss{mouse} & isBeginner{mouse},:));
CRPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isCR{mouse} & isBeginner{mouse},:));
FAPoleOnsetAlign(mouse,:)=nanmean(poleOnsetDFF2{mouse}(goodTrial{mouse} & isFA{mouse} & isBeginner{mouse},:));
end
figure(1);clf
hold on;
shadedErrorBar([],nanmean(HitPoleOnsetAlign),std(HitPoleOnsetAlign)/sqrt(size(HitPoleOnsetAlign,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleOnsetAlign),std(MissPoleOnsetAlign)/sqrt(size(MissPoleOnsetAlign,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleOnsetAlign),std(CRPoleOnsetAlign)/sqrt(size(CRPoleOnsetAlign,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleOnsetAlign),std(FAPoleOnsetAlign)/sqrt(size(FAPoleOnsetAlign,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([15.44 15.44], [-0.005 0.03],':k','linewidth',2)
ylim([-0.005 0.03])
set(gca,'xtick',15.44*[0:2],'xticklabel',[-1:2])
set(gcf,'Position',[100 100 550 550])
ax = gca;
ax.YAxis.Exponent = -3;
xlabel('Time from pole onset (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poleonsetAlignBeginnerSession'])
print(gcf,'-depsc2',['fig2_poleonsetAlignBeginnerSession'])



%plot pole down align response in experst session, use 16 frames before
%pole down as baseline
HitPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
MissPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
CRPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
FAPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
for mouse=1:8
HitPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isHit{mouse} & isExpert{mouse},:));
MissPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isMiss{mouse} & isExpert{mouse},:));
CRPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isCR{mouse} & isExpert{mouse},:));
FAPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isFA{mouse} & isExpert{mouse},:));
end
figure(2);clf
hold on;
shadedErrorBar([],nanmean(HitPoleDownAlign),std(HitPoleDownAlign)/sqrt(size(HitPoleDownAlign,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleDownAlign),std(MissPoleDownAlign)/sqrt(size(MissPoleDownAlign,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleDownAlign),std(CRPoleDownAlign)/sqrt(size(CRPoleDownAlign,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleDownAlign),std(FAPoleDownAlign)/sqrt(size(FAPoleDownAlign,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([15.44 15.44], [-0.01 0.015],':k','linewidth',2)
ylim([-0.01 0.015])
set(gca,'xtick',15.44*[0:2],'xticklabel',[-1:2])
set(gcf,'Position',[100 100 550 550])
ax = gca;
ax.YAxis.Exponent = -3;
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poledownAlignExpertSession'])
print(gcf,'-depsc2',['fig2_poledownAlignExpertSession'])


%plot pole down align response in all session, use 16 frames before
%pole down as baseline
HitPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
MissPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
CRPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
FAPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
for mouse=1:8
HitPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isHit{mouse},:));
MissPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isMiss{mouse},:));
CRPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isCR{mouse},:));
FAPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isFA{mouse},:));
end
figure(2);clf
hold on;
shadedErrorBar([],nanmean(HitPoleDownAlign),std(HitPoleDownAlign)/sqrt(size(HitPoleDownAlign,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleDownAlign),std(MissPoleDownAlign)/sqrt(size(MissPoleDownAlign,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleDownAlign),std(CRPoleDownAlign)/sqrt(size(CRPoleDownAlign,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleDownAlign),std(FAPoleDownAlign)/sqrt(size(FAPoleDownAlign,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([15.44 15.44], [-0.005 0.01],':k','linewidth',2)
ylim([-0.005 0.01])
set(gca,'xtick',15.44*[0:2],'xticklabel',[-1:2])
set(gcf,'Position',[100 100 550 550])
ax = gca;
ax.YAxis.Exponent = -3;
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poledownAlignAllSession'])
print(gcf,'-depsc2',['fig2_poledownAlignAllSession'])



%plot pole down align response in Beginner session, use 16 frames before
%pole down as baseline
HitPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
MissPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
CRPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
FAPoleDownAlign=NaN(8,size(poleDownDFF2{1,1},2));
for mouse=1:8
HitPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isHit{mouse}& isBeginner{mouse},:));
MissPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isMiss{mouse}& isBeginner{mouse},:));
CRPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isCR{mouse}& isBeginner{mouse},:));
FAPoleDownAlign(mouse,:)=nanmean(poleDownDFF2{mouse}(goodTrial{mouse} & isFA{mouse}& isBeginner{mouse},:));
end
figure(2);clf
hold on;
shadedErrorBar([],nanmean(HitPoleDownAlign),std(HitPoleDownAlign)/sqrt(size(HitPoleDownAlign,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleDownAlign),std(MissPoleDownAlign)/sqrt(size(MissPoleDownAlign,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleDownAlign),std(CRPoleDownAlign)/sqrt(size(CRPoleDownAlign,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleDownAlign),std(FAPoleDownAlign)/sqrt(size(FAPoleDownAlign,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([15.44 15.44], [-0.005 0.01],':k','linewidth',2)
ylim([-0.005 0.01])
set(gca,'xtick',15.44*[0:2],'xticklabel',[-1:2])
set(gcf,'Position',[100 100 550 550])
ax = gca;
ax.YAxis.Exponent = -3;
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poledownAlignBeginnerSession'])
print(gcf,'-depsc2',['fig2_poledownAlignBeginnerSession'])


%% 
%use good sessions as useSessions
firstLicks = cell(8,1)

numLicks= cell(8,1)

useSessions2 = find([summary.polePresent]+[summary.hasWhisker]-[summary.hasScopolamine]+[arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3);
for mouse = 1:8
    useSessions2 = find([summary.polePresent]+[summary.hasWhisker]-[summary.hasScopolamine]+[arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3);    
    
    for i = useSessions2
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        fl(cellfun(@isempty,fl)) = {NaN};
        firstLicks{mouse} = vertcat(firstLicks{mouse}, fl);
        numLicks{mouse} = vertcat(numLicks{mouse}, cellfun(@numel,M(mouse).summary(i).cleanLicks,'uniformoutput',0));
        
    end
    firstLicks{mouse} = cell2mat(firstLicks{mouse});
    numLicks{mouse}  = cell2mat(numLicks{mouse});
    
end