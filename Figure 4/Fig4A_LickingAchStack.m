for mouse=1:8
dFFstackByLicksBeginner = []
dFFstackByLicksExpert = []
dFFstackByLicksBeginnerNoReward = []
dFFstackByLicksExpertNoReward = []
dFFstackByLicksBeginnerReward = []
dFFstackByLicksExpertReward = []



maxLicks = 10
lickCountsBeginner = [];
lickCountsExpert = [];
lickCountsBeginnerNoReward = [];
lickCountsExpertNoReward = [];
lickCountsBeginnerReward = [];
lickCountsExpertReward = [];

for i = 0:maxLicks
    
dFFstackByLicksBeginner = cat(1,dFFstackByLicksBeginner,firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==i & isBeginner{mouse} ,:));
dFFstackByLicksExpert = cat(1,dFFstackByLicksExpert,firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==i & isExpert{mouse} ,:));

dFFstackByLicksBeginnerNoReward = cat(1,dFFstackByLicksBeginnerNoReward,firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==i & isBeginner{mouse} & ~gotReward{mouse},:));
dFFstackByLicksExpertNoReward = cat(1,dFFstackByLicksExpertNoReward,firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==i & isExpert{mouse}& ~gotReward{mouse} ,:));

dFFstackByLicksBeginnerReward = cat(1,dFFstackByLicksBeginnerReward,firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==i & isBeginner{mouse} & gotReward{mouse},:));
dFFstackByLicksExpertReward = cat(1,dFFstackByLicksExpertReward,firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==i & isExpert{mouse} & gotReward{mouse},:));



lickCountsBeginner = [lickCountsBeginner,sum(numLicks{mouse}==i & isBeginner{mouse} & goodTrial{mouse})];
lickCountsExpert = [lickCountsExpert,sum(numLicks{mouse}==i & isExpert{mouse} & goodTrial{mouse})];

lickCountsBeginnerNoReward = [lickCountsBeginnerNoReward,sum(numLicks{mouse}==i & isBeginner{mouse} & goodTrial{mouse} & ~gotReward{mouse})];
lickCountsExpertNoReward = [lickCountsExpertNoReward,sum(numLicks{mouse}==i & isExpert{mouse} & goodTrial{mouse} & ~gotReward{mouse})];

lickCountsBeginnerReward = [lickCountsBeginnerReward,sum(numLicks{mouse}==i & isBeginner{mouse} & goodTrial{mouse} & gotReward{mouse})];
lickCountsExpertReward = [lickCountsExpertReward,sum(numLicks{mouse}==i & isExpert{mouse} & goodTrial{mouse} & gotReward{mouse})];

end

lickYTicksBeginner = unique(cumsum(lickCountsBeginner));
lickYTicksExpert = unique(cumsum(lickCountsExpert));

lickYTicksBeginnerNoReward = unique(cumsum(lickCountsBeginnerNoReward));
lickYTicksExpertNoReward = unique(cumsum(lickCountsExpertNoReward));

lickYTicksBeginnerReward = unique(cumsum(lickCountsBeginnerReward));
lickYTicksExpertReward = unique(cumsum(lickCountsExpertReward));
%

% Split by beginner and expert
figure(1);clf;
imagesc(dFFstackByLicksExpert,[-0.01 0.06])
set(gca,'ytick',lickYTicksExpert,'tickdir','out','linewidth',2,'yticklabel',[])  % Set y-axis properties
% set(gca,'xtick',15.44*[0:11],'xticklabel',[-1:10])
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
xlabel('Time from first lick (s)')
ylabel('Trials, licks in trial','position',[-10 max(lickYTicksExpert)/2])
text(-7*ones(1,numel(lickYTicksExpert)), diff([0 lickYTicksExpert])/2+[0 lickYTicksExpert(1:end-1)],num2cell([0:numel(lickYTicksExpert)-1]))
box off
colormap(gray)
colorbar
title(['Mouse ' M(mouse).summary(1).name(1:4) ' Expert ACh'])
set(gcf,'paperPosition',[0 0 8 11])
print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackExpert'])
print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackExpert'])



figure(2);clf;
imagesc(dFFstackByLicksBeginner,[-0.01 0.06])
set(gca,'ytick',lickYTicksBeginner,'tickdir','out','linewidth',2,'yticklabel',[])  % Set y-axis properties
% set(gca,'xtick',15.44*[0:11],'xticklabel',[-1:10])
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
xlabel('Time from first lick (s)')
ylabel('Trials, licks in trial','position',[-10 max(lickYTicksBeginner)/2])
text(-7*ones(1,numel(lickYTicksBeginner)), diff([0 lickYTicksBeginner])/2+[0 lickYTicksBeginner(1:end-1)],num2cell([0:numel(lickYTicksBeginner)-1]))
box off
colormap(gray)
colorbar
title(['Mouse ' M(mouse).summary(1).name(1:4) ' Beginner ACh'])
set(gcf,'paperPosition',[0 0 8 11])
print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackBeginner'])
print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackBeginner'])



% Split by beginnger/expert and reward/noreward


figure(3);clf;
imagesc(dFFstackByLicksExpertNoReward,[-0.01 0.06])
set(gca,'ytick',lickYTicksExpertNoReward,'tickdir','out','linewidth',2,'yticklabel',[])  % Set y-axis properties
% set(gca,'xtick',15.44*[0:11],'xticklabel',[-1:10])
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
xlabel('Time from first lick (s)')
ylabel('Trials, licks in trial','position',[-10 max(lickYTicksExpertNoReward)/2])
text(-7*ones(1,numel(lickYTicksExpertNoReward)), diff([0 lickYTicksExpertNoReward])/2+[0 lickYTicksExpertNoReward(1:end-1)],num2cell([0:numel(lickYTicksExpertNoReward)-1]))
box off
colormap(gray)
colorbar
title(['Mouse ' M(mouse).summary(1).name(1:4) ' Expert No Reward ACh'])
set(gcf,'paperPosition',[0 0 8 11])
 print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackExpertNoReward'])
 print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackExpertNoReward'])

figure(4);clf;
imagesc(dFFstackByLicksExpertReward,[-0.01 0.06])
set(gca,'ytick',lickYTicksExpertReward,'tickdir','out','linewidth',2,'yticklabel',[])  % Set y-axis properties
% set(gca,'xtick',15.44*[0:11],'xticklabel',[-1:10])
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
xlabel('Time from first lick (s)')
ylabel('Trials, licks in trial','position',[-10 max(lickYTicksExpertReward)/2])
text(-7*ones(1,numel(lickYTicksExpertReward)), diff([0 lickYTicksExpertReward])/2+[0 lickYTicksExpertReward(1:end-1)],num2cell([0:numel(lickYTicksExpertReward)-1]))
box off
colormap(gray)
colorbar
title(['Mouse ' M(mouse).summary(1).name(1:4) ' Expert  Reward ACh'])
set(gcf,'paperPosition',[0 0 8 11])
 print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackExpertReward'])
 print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackExpertReward'])

figure(5);clf;
imagesc(dFFstackByLicksBeginnerNoReward,[-0.01 0.06])
set(gca,'ytick',lickYTicksBeginnerNoReward,'tickdir','out','linewidth',2,'yticklabel',[])  % Set y-axis properties
% set(gca,'xtick',15.44*[0:11],'xticklabel',[-1:10])
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
xlabel('Time from first lick (s)')
ylabel('Trials, licks in trial','position',[-10 max(lickYTicksBeginnerNoReward)/2])
text(-7*ones(1,numel(lickYTicksBeginnerNoReward)), diff([0 lickYTicksBeginnerNoReward])/2+[0 lickYTicksBeginnerNoReward(1:end-1)],num2cell([0:numel(lickYTicksBeginnerNoReward)-1]))
box off
colormap(gray)
colorbar
title(['Mouse ' M(mouse).summary(1).name(1:4) ' Beginner No Reward ACh'])
set(gcf,'paperPosition',[0 0 8 11])
 print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackBeginnerNoReward'])
 print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackBeginnerNoReward'])

figure(6);clf;
imagesc(dFFstackByLicksBeginnerReward,[-0.01 0.06])
set(gca,'ytick',lickYTicksBeginnerReward,'tickdir','out','linewidth',2,'yticklabel',[])  % Set y-axis properties
% set(gca,'xtick',15.44*[0:11],'xticklabel',[-1:10])
set(gca,'XLim',[0 max(trialFrames)],'fontweight', 'bold');
        xticks([33-2*15.44:15.44:33+9*15.44]);
        xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});
xlabel('Time from first lick (s)')
ylabel('Trials, licks in trial','position',[-10 max(lickYTicksBeginnerReward)/2])
text(-7*ones(1,numel(lickYTicksBeginnerReward)), diff([0 lickYTicksBeginnerReward])/2+[0 lickYTicksBeginnerReward(1:end-1)],num2cell([0:numel(lickYTicksBeginnerReward)-1]))
box off
colormap(gray)
colorbar
title(['Mouse ' M(mouse).summary(1).name(1:4) ' Beginner  Reward ACh'])
set(gcf,'paperPosition',[0 0 8 11])
 print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackBeginnerReward'])
 print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' FirstLickAlignedAchStackBeginnerReward'])
end