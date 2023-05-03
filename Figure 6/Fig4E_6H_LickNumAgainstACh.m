%% Fig 4E and 6H plot lick count against first lick aligned response

    crazy_max_num_licks = 1000;
    for_each_lick = cell(crazy_max_num_licks, 8);
    for_each_lick_avg= cell(crazy_max_num_licks, 9);
    for i=1:crazy_max_num_licks
        for mouse =1:8
            tmp_arry = [];
            meanResponse.licks{i}=i-1;
            meanResponse.Ach{i}=firstLickDFF{mouse}(goodTrial{mouse} & numLicks{mouse}==i-1,:);  %use 16 frames before first lick as baseline 
            for_each_lick{i, mouse} = meanResponse.Ach{i};
            for_each_lick_avg{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,16:32)));
        end
        for_each_lick_avg{i,9}=nanmean([for_each_lick_avg{i,1:8}]); 
    end

    figure(1);clf
   bar([0:10],[for_each_lick_avg{1:11,9}],'k') 
hold on
for i=1:11
for mouse=1:8
    plot(i-1,for_each_lick_avg{i,mouse},'o','color',[.5 .5 .5])
end
end
xlabel ('Licks in trial','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts against firstlickdff all sessions'])
print(gcf,'-depsc2',['lick counts against firstlickdff all sessions']) 




% plot licks against first lick aligned response only use expert sessions
  crazy_max_num_licks = 1000;
    for_each_lick = cell(crazy_max_num_licks, 8);
    for_each_lick_avg= cell(crazy_max_num_licks, 9);
    for i=1:crazy_max_num_licks
        for mouse =1:8
            tmp_arry = [];
            meanResponse.licks{i}=i-1;
            meanResponse.Ach{i}=firstLickDFF{mouse}(goodTrial{mouse} & numLicks{mouse}==i-1 & isExpert{mouse},:);
            for_each_lick{i, mouse} = meanResponse.Ach{i};
            for_each_lick_avg{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,16:32)));
        end
        for_each_lick_avg{i,9}=nanmean([for_each_lick_avg{i,1:8}]); 
    end
 figure(2);clf
   bar([0:10],[for_each_lick_avg{1:11,9}],'k') 
hold on
for i=1:11
for mouse=1:8
    plot(i-1,for_each_lick_avg{i,mouse},'o','color',[.5 .5 .5])
end
end
xlabel ('Licks in trial','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts against firstlickdff Expert sessions'])
print(gcf,'-depsc2',['lick counts against firstlickdff Expert sessions'])     

%plot licks within 1 sec after first lick against first lick aligned response only use expert sessions
  crazy_max_num_licks = 1000;
    for_each_lick = cell(crazy_max_num_licks, 8);
    for_each_lick_avg_Exp= cell(crazy_max_num_licks, 9);
    for i=1:crazy_max_num_licks
        for mouse =1:8
            tmp_arry = [];
            meanResponse.licks{i}=i-1;
            meanResponse.Ach{i}=firstLickDFF{mouse}(goodTrial{mouse} & numLicks_1s{mouse}==i-1 & isExpert{mouse},:);
            for_each_lick{i, mouse} = meanResponse.Ach{i};
            for_each_lick_avg_Exp{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,16:32)));
        end
        for_each_lick_avg_Exp{i,9}=nanmean([for_each_lick_avg_Exp{i,1:8}]); 
    end
 figure(2);clf
   bar([0:7],[for_each_lick_avg_Exp{1:8,9}],'k') 
hold on
for i=1:8
for mouse=1:8
    plot(i-1,for_each_lick_avg_Exp{i,mouse},'o','color',[.5 .5 .5])
end
end
xlabel ('Licks within 1s after FL','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within 1s after first lick against firstlickdff Expert sessions'])
print(gcf,'-depsc2',['lick counts within 1s after first lick against firstlickdff Expert sessions'])    

%plot licks within 1 sec after first lick against first lick aligned
%response only use expert sessions with a linear fit exclude lick num=0
for lickNumPerTrial=1:7
    for k=1:8
       x(k+(lickNumPerTrial-1)*8)=lickNumPerTrial;
       y(k+(lickNumPerTrial-1)*8)=for_each_lick_avg_Exp{lickNumPerTrial+1,k};
    end
end
fp1=fit(x',y','poly1');
 figure(3);clf
   bar([0:7],[for_each_lick_avg_Exp{1:8,9}],'k') 
hold on
for i=1:8
for mouse=1:8
    plot(i-1,for_each_lick_avg_Exp{i,mouse},'o','color',[.5 .5 .5])
end
end
hold on
plot(fp1)
xlabel ('Licks within 1s after FL','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within 1s after first lick against firstlickdff Expert sessions with fitting curve'])
print(gcf,'-depsc2',['lick counts within 1s after first lick against firstlickdff Expert sessions with fitting curve']) 



%plot licks within 1 sec after first lick against first lick aligned response only use Beginner sessions
  crazy_max_num_licks = 1000;
    for_each_lick = cell(crazy_max_num_licks, 8);
    for_each_lick_avg_Begin= cell(crazy_max_num_licks, 9);
    for i=1:crazy_max_num_licks
        for mouse =1:8
            tmp_arry = [];
            meanResponse.licks{i}=i-1;
            meanResponse.Ach{i}=firstLickDFF{mouse}(goodTrial{mouse} & numLicks_1s{mouse}==i-1 & isBeginner{mouse},:);
            for_each_lick{i, mouse} = meanResponse.Ach{i};
            for_each_lick_avg_Begin{i,mouse}=nanmean(nanmean(meanResponse.Ach{i}(:,16:32)));
        end
        for_each_lick_avg_Begin{i,9}=nanmean([for_each_lick_avg_Begin{i,1:8}]); 
    end
 figure(2);clf
   bar([0:7],[for_each_lick_avg_Begin{1:8,9}],'k') 
hold on
for i=1:8
for mouse=1:8
    plot(i-1,for_each_lick_avg_Begin{i,mouse},'o','color',[.5 .5 .5])
end
end
xlabel ('Licks within 1s after FL','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within 1s after first lick against firstlickdff Beginner sessions'])
print(gcf,'-depsc2',['lick counts within 1s after first lick against firstlickdff Beginner sessions'])    


%plot licks within 1 sec after first lick against first lick aligned
%response only use Beginner sessions with a linear fit exclude lick num=0

for lickNumPerTrial=1:7
    for k=1:8
       x(k+(lickNumPerTrial-1)*8)=lickNumPerTrial;
       y(k+(lickNumPerTrial-1)*8)=for_each_lick_avg_Begin{lickNumPerTrial+1,k};
    end
end
fp2=fit(x',y','poly1');
 figure(3);clf
   bar([0:7],[for_each_lick_avg_Begin{1:8,9}],'k') 
hold on
for i=1:8
for mouse=1:8
    plot(i-1,for_each_lick_avg_Begin{i,mouse},'o','color',[.5 .5 .5])
end
end
hold on
plot(fp2)
xlabel ('Licks within 1s after FL','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within 1s after first lick against firstlickdff Beginner sessions with fitting curve'])
print(gcf,'-depsc2',['lick counts within 1s after first lick against firstlickdff Beginner sessions with fitting curve'])



%plot beginner and expert on the same plot
figure(10);clf
for i=1:8
for mouse=1:8
    plot(i-1-0.05,for_each_lick_avg_Begin{i,mouse},'o','color',[.7 .7 .7])
    hold on
    plot(i-1+0.05,for_each_lick_avg_Exp{i,mouse},'o','color','k')
end
end
legend('Beginner','Expert')
hold on
plot(fp1)
plot(fp2)
legend('Beginner','Expert')
xlabel ('Licks within 1s after FL','FontSize', 20,'FontWeight','bold')
ylabel('Average Ach post first lick','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within 1s after first lick against firstlickdff Beginner Expert sessions with fitting curve'])
print(gcf,'-depsc2',['lick counts within 1s after first lick against firstlickdff Beginner Expert sessions with fitting curve'])
