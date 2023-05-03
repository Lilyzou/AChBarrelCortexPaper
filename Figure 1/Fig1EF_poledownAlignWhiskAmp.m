%pole down aligned whisking response
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

%% Get the whisking amplitude
preStimPad = round(311*0.5); %frames in whisking imaging rate
trialFrames = 450; % only include 450 frames
isHit = cell(8,1);
isMiss = cell(8,1);
isCR = cell(8,1);
isFA = cell(8,1);
poleDownAmp= cell(8,1);
poleUpAmp= cell(8,1);
isExpert = cell(8,1);
isBeginner = cell(8,1);
goodTrial = cell(8,1);
for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    
    for i = useSessions
        

        
        %Preallocate
        

        goodTrialTmp = (M(mouse).summary(i).trialStart >1544)';
        poleDownAmpTmp = zeros(length(M(mouse).summary(i).trialStart),trialFrames);
        poleUpAmpTmp= zeros(length(M(mouse).summary(i).trialStart),trialFrames);
        isExpertTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        isBeginnerTmp= zeros(length(M(mouse).summary(i).trialStart),1);
        isHitTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isMissTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isCRTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        isFATmp=zeros(length(M(mouse).summary(i).trialStart),1);
        
        
        
  
        
        if i >= useSessions(end-2);
            isExpertTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        if i <= useSessions(3);
            isBeginnerTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        f1=cellfun(@min,M(mouse).summary(i).poleOnset,'uniformoutput',0);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
               if isempty(M(mouse).summary(i).amplitude{t})
               poleUpAmpTmp(t,:)=NaN;    
               else
                   if (round(f1{t}*311)+trialFrames-preStimPad-1)>length( M(mouse).summary(i).amplitude{t})
                     poleDownAmpTmp(t,:)=NaN;  
                   else
                     poleUpAmpTmp(t,:) = M(mouse).summary(i).amplitude{t}((round(f1{t}*311)-preStimPad):(round(f1{t}*311)+trialFrames-preStimPad-1));
                   end
               end
                
            
        end        
        
        
        f2 = cellfun(@min,M(mouse).summary(i).poleDown,'uniformoutput',0);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
               if isempty(M(mouse).summary(i).amplitude{t})
               poleDownAmpTmp(t,:)=NaN;    
               else
                   if (round(f2{t}*311)+trialFrames-preStimPad-1)>length( M(mouse).summary(i).amplitude{t})
                     poleDownAmpTmp(t,:)=NaN;  
                   else
                      poleDownAmpTmp(t,:) = M(mouse).summary(i).amplitude{t}((round(f2{t}*311)-preStimPad):(round(f2{t}*311)+trialFrames-preStimPad-1));
                   end
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
        
        

        goodTrial{mouse} = vertcat(goodTrial{mouse},goodTrialTmp);
        poleUpAmp{mouse} = vertcat(poleUpAmp{mouse},poleUpAmpTmp);
        poleDownAmp{mouse} = vertcat(poleDownAmp{mouse},poleDownAmpTmp);
        isExpert{mouse} = vertcat(isExpert{mouse},isExpertTmp);        
        isBeginner{mouse}=vertcat(isBeginner{mouse},isBeginnerTmp);
        isHit{mouse}= vertcat(isHit{mouse}, isHitTmp);
        isMiss{mouse}= vertcat(isMiss{mouse}, isMissTmp);
        isFA{mouse}= vertcat(isFA{mouse}, isFATmp);
        isCR{mouse}= vertcat(isCR{mouse}, isCRTmp);
    end
    goodTrial{mouse} = logical(goodTrial{mouse});

    
end

%% plot the figures
%plot pole up aligned whisking in expert sessions
poleUpAlignAmp=NaN(8,size(poleUpAmp{1,1},2));
for mouse=1:8
    poleUpAlignAmp(mouse,:)=nanmean(poleUpAmp{mouse}(goodTrial{mouse} & isExpert{mouse},:));
end
figure(1);clf
shadedErrorBar([],nanmean(poleUpAlignAmp),std(poleUpAlignAmp)/sqrt(size(poleUpAlignAmp,1)),'lineprops',{'color','k','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole up (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
% legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
set(gcf,'Position',[100 100 550 550])
print(gcf,'-dpng','-r300',['fig1E_poleUpWhiskAmpAlignExpertSession'])
print(gcf,'-depsc2',['fig1E_poleUpWhiskAmpAlignExpertSession'])

%plot pole down aligned whisking in expert sessions
poleDownAlignAmp1=NaN(8,size(poleDownAmp{1,1},2));
for mouse=1:8
    poleDownAlignAmp1(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isExpert{mouse},:));
end
figure(1);clf
shadedErrorBar([],nanmean(poleDownAlignAmp1),std(poleDownAlignAmp1)/sqrt(size(poleDownAlignAmp1,1)),'lineprops',{'color','k','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
% legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
set(gcf,'Position',[100 100 550 550])
print(gcf,'-dpng','-r300',['fig1F_poleDownWhiskAmpAlignExpertSessionAllTrials'])
print(gcf,'-depsc2',['fig1F_poleDownWhiskAmpAlignExpertSessionAllTrials'])
%% plot pole up aligned whisking in expert session by trial type
HitPoleUpnAlignAmp=NaN(8,size(poleUpAmp{1,1},2));
MissPoleUpAlignAmp=NaN(8,size(poleUpAmp{1,1},2));
CRPoleUpAlignAmp=NaN(8,size(poleUpAmp{1,1},2));
FAPoleUpAlignAmp=NaN(8,size(poleUpAmp{1,1},2));
for mouse=1:8
HitPoleUpAlignAmp(mouse,:)=nanmean(poleUpAmp{mouse}(goodTrial{mouse} & isHit{mouse} & isExpert{mouse},:));
MissPoleUpAlignAmp(mouse,:)=nanmean(poleUpAmp{mouse}(goodTrial{mouse} & isMiss{mouse} & isExpert{mouse},:));
CRPoleUpAlignAmp(mouse,:)=nanmean(poleUpAmp{mouse}(goodTrial{mouse} & isCR{mouse} & isExpert{mouse},:));
FAPoleUpAlignAmp(mouse,:)=nanmean(poleUpAmp{mouse}(goodTrial{mouse} & isFA{mouse} & isExpert{mouse},:));
end
figure(2);clf
hold on;
shadedErrorBar([],nanmean(HitPoleUpAlignAmp),std(HitPoleUpAlignAmp)/sqrt(size(HitPoleUpAlignAmp,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleUpAlignAmp),std(MissPoleUpAlignAmp)/sqrt(size(MissPoleUpAlignAmp,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleUpAlignAmp),std(CRPoleUpAlignAmp)/sqrt(size(CRPoleUpAlignAmp,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleUpAlignAmp),std(FAPoleUpAlignAmp)/sqrt(size(FAPoleUpAlignAmp,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole Up (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
set(gcf,'Position',[100 100 550 550])
print(gcf,'-dpng','-r300',['fig1E_poleUpWhiskAmpAlignExpertSessionbyTrialTypes'])
print(gcf,'-depsc2',['fig1E_poleUpWhiskAmpAlignExpertSessionbyTrialTypes'])
%% plot pole down aligned whisking in expert session by trial type
HitPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
MissPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
CRPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
FAPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
for mouse=1:8
HitPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isHit{mouse} & isExpert{mouse},:));
MissPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isMiss{mouse} & isExpert{mouse},:));
CRPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isCR{mouse} & isExpert{mouse},:));
FAPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isFA{mouse} & isExpert{mouse},:));
end
figure(2);clf
hold on;
shadedErrorBar([],nanmean(HitPoleDownAlignAmp),std(HitPoleDownAlignAmp)/sqrt(size(HitPoleDownAlignAmp,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleDownAlignAmp),std(MissPoleDownAlignAmp)/sqrt(size(MissPoleDownAlignAmp,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleDownAlignAmp),std(CRPoleDownAlignAmp)/sqrt(size(CRPoleDownAlignAmp,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleDownAlignAmp),std(FAPoleDownAlignAmp)/sqrt(size(FAPoleDownAlignAmp,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
set(gcf,'Position',[100 100 550 550])
print(gcf,'-dpng','-r300',['fig2_poledownWhiskAmpAlignExpertSession'])
print(gcf,'-depsc2',['fig2_poledownWhiskAmpAlignExpertSession'])


%plot hit and miss on one plot and CR and FA another plot, expert sessions
figure(3);clf
subplot(2,1,1)
hold on;
shadedErrorBar([],nanmean(HitPoleDownAlignAmp),std(HitPoleDownAlignAmp)/sqrt(size(HitPoleDownAlignAmp,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleDownAlignAmp),std(MissPoleDownAlignAmp)/sqrt(size(MissPoleDownAlignAmp,1)),'lineprops',{'color','k','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss'}, 'FontSize', 12);

subplot(2,1,2)
hold on;
shadedErrorBar([],nanmean(CRPoleDownAlignAmp),std(CRPoleDownAlignAmp)/sqrt(size(CRPoleDownAlignAmp,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleDownAlignAmp),std(FAPoleDownAlignAmp)/sqrt(size(FAPoleDownAlignAmp,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
legend({'CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poledownWhiskAmpAlignExpertSessionbypoleposition'])
print(gcf,'-depsc2',['fig2_poledownWhiskAmpAlignExpertSessionbypoleposition'])

%% plot pole down aligned whisking in Beginner session by trial type
HitPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
MissPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
CRPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
FAPoleDownAlignAmp=NaN(8,size(poleDownAmp{1,1},2));
for mouse=1:8
HitPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isHit{mouse} & isBeginner{mouse},:));
MissPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isMiss{mouse} & isBeginner{mouse},:));
CRPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isCR{mouse} & isBeginner{mouse},:));
FAPoleDownAlignAmp(mouse,:)=nanmean(poleDownAmp{mouse}(goodTrial{mouse} & isFA{mouse} & isBeginner{mouse},:));
end
figure(4);clf
hold on;
shadedErrorBar([],nanmean(HitPoleDownAlignAmp),std(HitPoleDownAlignAmp)/sqrt(size(HitPoleDownAlignAmp,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleDownAlignAmp),std(MissPoleDownAlignAmp)/sqrt(size(MissPoleDownAlignAmp,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(CRPoleDownAlignAmp),std(CRPoleDownAlignAmp)/sqrt(size(CRPoleDownAlignAmp,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleDownAlignAmp),std(FAPoleDownAlignAmp)/sqrt(size(FAPoleDownAlignAmp,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
set(gcf,'Position',[100 100 550 550])
print(gcf,'-dpng','-r300',['fig2_poledownWhiskAmpAlignBeginnerSession'])
print(gcf,'-depsc2',['fig2_poledownWhiskAmpAlignBeginnerSession'])
%plot hit and miss on one plot and CR and FA another plot, Beginner sessions
figure(5);clf
subplot(2,1,1)
hold on;
shadedErrorBar([],nanmean(HitPoleDownAlignAmp),std(HitPoleDownAlignAmp)/sqrt(size(HitPoleDownAlignAmp,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(MissPoleDownAlignAmp),std(MissPoleDownAlignAmp)/sqrt(size(MissPoleDownAlignAmp,1)),'lineprops',{'color','k','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss'}, 'FontSize', 12);

subplot(2,1,2)
hold on;
shadedErrorBar([],nanmean(CRPoleDownAlignAmp),std(CRPoleDownAlignAmp)/sqrt(size(CRPoleDownAlignAmp,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(FAPoleDownAlignAmp),std(FAPoleDownAlignAmp)/sqrt(size(FAPoleDownAlignAmp,1)),'lineprops',{'color','g','linewidth',3})
hold on 
plot([preStimPad preStimPad], [0 11],':k','linewidth',2)
ylim([0 11])
xlim([0 trialFrames])
set(gca,'xtick',311*(0.5:0.5:1.5),'xticklabel',{'0','0.5'})
xlabel('Time from pole down (s)','FontSize', 20,'FontWeight','bold')
ylabel('Whisk Amplitude','FontSize', 20,'FontWeight','bold')
legend({'CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['fig2_poledownWhiskAmpAlignBeginnerSessionbypoleposition'])
print(gcf,'-depsc2',['fig2_poledownWhiskAmpAlignBeginnerSessionbypoleposition'])