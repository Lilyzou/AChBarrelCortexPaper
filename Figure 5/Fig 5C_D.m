
%% Fig 5D plot lick count within answer period against average ach release signal witin answer period for hit and FA trials
% plot lick count within answer period against first lick aligned response
% within answer period in hit trials expert sessions

  crazy_max_num_licks = 1000;
    for_each_lick_hit = cell(crazy_max_num_licks, 8);
    for_each_lick_avg_hit= cell(crazy_max_num_licks, 9);
    for i=1:crazy_max_num_licks
        for mouse =1:8
            tmp_arry = [];
            meanResponse.licks{i}=i-1;
            meanResponse.Ach{i}=trialDFF{mouse}(goodTrial{mouse} & numLicks_ans{mouse}==i & isExpert{mouse} & isHit{mouse},:);
            for_each_lick_hit{i, mouse} = meanResponse.Ach{i};
            for_each_lick_avg_hit{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,32:48)));
%             for_each_lick_avg_hit{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,17:48)));
        end
        for_each_lick_avg_hit{i,9}=nanmean([for_each_lick_avg_hit{i,1:8}]); 
    end
 figure(3);clf
   bar([1:8],[for_each_lick_avg_hit{1:8,9}],'b') 
hold on
for i=1:10
for mouse=1:8
    plot(i,for_each_lick_avg_hit{i,mouse},'o','color', [.7 .7 1])
end
end
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach wihin answer period','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within answer period against trialdff 32_48 Expert sessions Hit'])
print(gcf,'-depsc2',['lick counts within answer period against trialdff 32_48 Expert sessions Hit']) 

% plot lick count within answer period against first lick aligned response
% within answer period in FA trials expert sessions
  crazy_max_num_licks = 1000;
    for_each_lick_FA = cell(crazy_max_num_licks, 8);
    for_each_lick_avg_FA= cell(crazy_max_num_licks, 9);
    for i=1:crazy_max_num_licks
        for mouse =1:8
            tmp_arry = [];
            meanResponse.licks{i}=i-1;
            meanResponse.Ach{i}=trialDFF{mouse}(goodTrial{mouse} & numLicks_ans{mouse}==i & isExpert{mouse} & isFA{mouse},:);
            for_each_lick_FA{i, mouse} = meanResponse.Ach{i};
            for_each_lick_avg_FA{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,32:48)));
%             for_each_lick_avg_hit{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,17:48)));
        end
        for_each_lick_avg_FA{i,9}=nanmean([for_each_lick_avg_FA{i,1:8}]); 
    end
 figure(3);clf
   bar([1:6],[for_each_lick_avg_FA{1:6,9}],'g') 
hold on
for i=1:10
for mouse=1:8
    plot(i,for_each_lick_avg_FA{i,mouse},'o','color', [.7 1 .7])
end
end
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach wihin answer period','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within answer period against trialdff 32_48 Expert sessions FA'])
print(gcf,'-depsc2',['lick counts within answer period against trialdff 32_48 Expert sessions FA'])   

figure(2);clf
plot([1:8],[for_each_lick_avg_hit{1:8,9}],'b-o','LineWidth',2)
hold on
plot([1:6],[for_each_lick_avg_FA{1:6,9}],'g-o','LineWidth',2)
xlim([0 8])
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach within answer period','FontSize', 20,'FontWeight','bold')
legend('Hit','FA')
print(gcf,'-dpng','-r300',['lick counts witihn answer period against trialdff 32_48 Expert sessions Hit FA curve'])
print(gcf,'-depsc2',['lick counts witihn answer period against trialdff 32_48 Expert sessions Hit FA curve'])   

%run statistics
 hit_avg=cell2mat(for_each_lick_avg_hit);
 FA_avg=cell2mat(for_each_lick_avg_FA);
for i=1:6
  
   hit_avg2=hit_avg(i,1:8);
   hit_avg3=hit_avg2(~isnan(hit_avg2));
  
    FA_avg2=FA_avg(i,1:8);
    FA_avg3=FA_avg2(~isnan(hit_avg2));
     [h, p] = ttest(hit_avg2, FA_avg2);
     p_Val(i) = p;
     clear('p','h')
end
figure(1)
plot(1:6,p_Val,'k-o')
hold on
plot([0 6],[0.05, 0.05], 'r--')

xticks([1:1:6]);
xticklabels({'1','2','3','4','5','6'});
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('P Value','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA significance test'])
print(gcf,'-depsc2',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA significance test']) 


figure(2)
subplot(2,1,1)
plot([1:6],[for_each_lick_avg_hit{1:6,9}],'b-o','LineWidth',2)
hold on
plot([1:6],[for_each_lick_avg_FA{1:6,9}],'g-o','LineWidth',2)
xlim([0 6])
xlabel ('LickNum within answer period','FontSize', 14,'FontWeight','bold')
ylabel('Average Ach within answer period','FontSize', 14,'FontWeight','bold')
legend('Hit','FA')
subplot(2,1,2)
plot(1:6,p_Val,'k-o')
hold on
plot([0 6],[0.05, 0.05], 'r--')
xticks([1:1:6]);
xticklabels({'1','2','3','4','5','6'});
xlabel ('LickNum within answer period','FontSize', 14,'FontWeight','bold')
ylabel('P Value','FontSize', 14,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA curve with stats'])
print(gcf,'-depsc2',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA curve with stats']) 

%plot curves with scatter plot of individual data
figure(2);clf
for i=1:7
for mouse=1:8
    plot(i-0.05,for_each_lick_avg_hit{i,mouse},'o','color', [.7 .7 1],'LineWidth',2)
    hold on
    plot(i+0.05,for_each_lick_avg_FA{i,mouse},'o','color', [.7 1 .7],'LineWidth',2)
end
end
hold on
plot([1:7],[for_each_lick_avg_hit{1:7,9}],'b-o','LineWidth',2)
plot([1:6],[for_each_lick_avg_FA{1:6,9}],'g-o','LineWidth',2)

xlim([0 8])
% ylim([0 0.04])
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach within answer period','FontSize', 20,'FontWeight','bold')
legend('Hit','FA')
print(gcf,'-dpng','-r300',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA curve with indivdual plot'])
print(gcf,'-depsc2',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA curve with indivdual plot'])


%plot curves with scatter plot of individual data with statistics
figure(2);clf
subplot(2,1,1)
for i=1:6
for mouse=1:8    
    plot(i-0.05,for_each_lick_avg_hit{i,mouse},'o','color', [.7 .7 1],'LineWidth',2)
    hold on
    plot(i+0.05,for_each_lick_avg_FA{i,mouse},'o','color', [.7 1 .7],'LineWidth',2)
end
end
hold on
plot([1:6],[for_each_lick_avg_hit{1:6,9}],'b-o','LineWidth',2)
plot([1:6],[for_each_lick_avg_FA{1:6,9}],'g-o','LineWidth',2)
xlim([0 7])
xticks([1:1:7]);
xticklabels({'1','2','3','4','5','6','7'});
% ylim([0 0.04])
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach within answer period','FontSize', 20,'FontWeight','bold')
legend('Hit','FA')

subplot(2,1,2)
plot(1:6,p_Val,'k-o')
hold on
plot([0 7],[0.05, 0.05], 'r--')
xlim([0 7])
xticks([1:1:7]);
xticklabels({'1','2','3','4','5','6','7'});
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('P Value','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA curve with indivdual plot with stat'])
print(gcf,'-depsc2',['lick counts within answer period against trialdff 32_48 Expert sessions Hit FA curve with indivdual plot with stat'])


%% Fig 5C
%plot the histogram for lick num within answer period in hit FA trials
%expert sessions

for mouse=1:8
numLicks_ans_hit{mouse}=numLicks_ans{mouse}(isExpert{mouse} & isHit{mouse});
numLicks_ans_FA{mouse}=numLicks_ans{mouse}(isExpert{mouse} & isFA{mouse});
end
numLicks_ans_hit=numLicks_ans_hit';
numLicks_ans_FA=numLicks_ans_FA';
numLicks_Ans_hit=vertcat(numLicks_ans_hit{:});
numLicks_Ans_FA=vertcat(numLicks_ans_FA{:});
edges = [0.5:1:7.5];
figure(1);
histogram(numLicks_Ans_hit,edges,'Normalization','probability','facecolor','b')
hold on
histogram(numLicks_Ans_FA,edges,'Normalization','probability','facecolor','g')
xlabel ('LickNum within answer period','FontSize', 20,'FontWeight','bold')
ylabel('count probability','FontSize', 20,'FontWeight','bold')
legend('Hit','FA')
print(gcf,'-dpng','-r300',['lick counts within answer period against Expert sessions Hit FA histogram'])
print(gcf,'-depsc2',['lick counts within answer period against Expert sessions Hit FA histogram'])