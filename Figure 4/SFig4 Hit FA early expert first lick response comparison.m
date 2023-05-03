%% SFig4 plot first lick align response by trial types, using post cue first lick
%use -32:-17 frames before first lickas baseline
postCuelickAlignTraceHit=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceHit(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isHit{mouse},:)); 
end

postCuelickAlignTraceMiss=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceMiss(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isMiss{mouse},:)); 
end

postCuelickAlignTraceCR=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceCR(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isCR{mouse},:)); 
end

postCuelickAlignTraceFA=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceFA(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isFA{mouse},:)); 
end

figure(20);
shadedErrorBar([],nanmean(postCuelickAlignTraceHit),std(postCuelickAlignTraceHit)/sqrt(size(postCuelickAlignTraceHit,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceMiss),std(postCuelickAlignTraceMiss)/sqrt(size(postCuelickAlignTraceMiss,1)),'lineprops',{'color','k','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceCR),std(postCuelickAlignTraceCR)/sqrt(size(postCuelickAlignTraceCR,1)),'lineprops',{'color','r','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceFA),std(postCuelickAlignTraceFA)/sqrt(size(postCuelickAlignTraceFA,1)),'lineprops',{'color','g','linewidth',3})
hold on
 plot([33 33], [-0.005 0.035],'-.k','linewidth',1)
ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['postcuefirstlickAlignAchbyTrialType'])
print(gcf,'-depsc2',['postcuefirstlickAlignAchbyTrialType']) 


%First lick aligned response comparison between Hit and FA trials, using
%post cue first lick, all trials
figure(21);
shadedErrorBar([],nanmean(postCuelickAlignTraceHit),std(postCuelickAlignTraceHit)/sqrt(size(postCuelickAlignTraceHit,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceFA),std(postCuelickAlignTraceFA)/sqrt(size(postCuelickAlignTraceFA,1)),'lineprops',{'color','g','linewidth',3})
hold on
 plot([33 33], [-0.005 0.035],'-.k','linewidth',1)
ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['postcuefirstlickAlignAchHitFAAllTrialsComparison'])
print(gcf,'-depsc2',['postcuefirstlickAlignAchHitFAAllTrialsComparison']) 

%First lick aligned response comparison between Hit and FA trials, using
%post cue first lick, Expert trials
postCuelickAlignTraceHit_Exp=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceHit_Exp(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isHit{mouse} & isExpert{mouse},:)); 
end

postCuelickAlignTraceFA_Exp=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceFA_Exp(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isFA{mouse} & isExpert{mouse},:)); 
end
figure(22);
shadedErrorBar([],nanmean(postCuelickAlignTraceHit_Exp),std(postCuelickAlignTraceHit_Exp)/sqrt(size(postCuelickAlignTraceHit_Exp,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceFA_Exp),std(postCuelickAlignTraceFA_Exp)/sqrt(size(postCuelickAlignTraceFA_Exp,1)),'lineprops',{'color','g','linewidth',3})
hold on
 plot([33 33], [-0.005 0.045],'-.k','linewidth',1)
ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['postcuefirstlickAlignAchHitFAExpertTrialsComparison'])
print(gcf,'-depsc2',['postcuefirstlickAlignAchHitFAExpertTrialsComparison']) 

%First lick aligned response comparison between Hit and FA trials, using
%post cue first lick, Beginner trials
postCuelickAlignTraceHit_Begin=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceHit_Begin(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isHit{mouse} & isBeginner{mouse},:)); 
end

postCuelickAlignTraceFA_Begin=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
postCuelickAlignTraceFA_Begin(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & numLicks{mouse}~=0 & isFA{mouse} & isBeginner{mouse},:)); 
end

figure(23);
shadedErrorBar([],nanmean(postCuelickAlignTraceHit_Begin),std(postCuelickAlignTraceHit_Begin)/sqrt(size(postCuelickAlignTraceHit_Begin,1)),'lineprops',{'color','b','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceFA_Begin),std(postCuelickAlignTraceFA_Begin)/sqrt(size(postCuelickAlignTraceFA_Begin,1)),'lineprops',{'color','g','linewidth',3})
hold on
 plot([33 33], [-0.005 0.03],'-.k','linewidth',1)
ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit','FA'}, 'FontSize', 12);
print(gcf,'-dpng','-r300',['postcuefirstlickAlignAchHitFABeginnerTrialsComparison'])
print(gcf,'-depsc2',['postcuefirstlickAlignAchHitFABeginnerTrialsComparison']) 

%First lick aligned response Hit and FA trials comparison between Beginner and
%Expert

figure(23);
subplot(1,2,1);
shadedErrorBar([],nanmean(postCuelickAlignTraceHit_Begin),std(postCuelickAlignTraceHit_Begin)/sqrt(size(postCuelickAlignTraceHit_Begin,1)),'lineprops',{'color','[0.8 0.8 1]','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceHit_Exp),std(postCuelickAlignTraceHit_Exp)/sqrt(size(postCuelickAlignTraceHit_Exp,1)),'lineprops',{'color','b','linewidth',3})
hold on
plot([33 33], [-0.005 0.045],'-.k','linewidth',1)
ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'Hit Early','Hit Expert'}, 'FontSize', 12);
subplot(1,2,2);
shadedErrorBar([],nanmean(postCuelickAlignTraceFA_Begin),std(postCuelickAlignTraceFA_Begin)/sqrt(size(postCuelickAlignTraceFA_Begin,1)),'lineprops',{'color','[0.8 1 0.8]','linewidth',3})
shadedErrorBar([],nanmean(postCuelickAlignTraceFA_Exp),std(postCuelickAlignTraceFA_Exp)/sqrt(size(postCuelickAlignTraceFA_Exp,1)),'lineprops',{'color','g','linewidth',3})
hold on
plot([33 33], [-0.005 0.045],'-.k','linewidth',1)
ax = gca;
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
ax.YAxis.Exponent = -2;
xlabel('Time from first lick (s)','FontSize', 20,'FontWeight','bold')
ylabel('\DeltaF/F','FontSize', 20,'FontWeight','bold')
legend({'FA Early','FA Expert'}, 'FontSize', 12);

print(gcf,'-dpng','-r300',['postcuefirstlickAlignAchHitFABeginnerExpertTrialsComparison'])
print(gcf,'-depsc2',['postcuefirstlickAlignAchHitFABeginnerExpertTrialsComparison']) 