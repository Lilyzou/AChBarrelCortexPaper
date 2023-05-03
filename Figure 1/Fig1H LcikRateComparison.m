

for mouse = 1:8
    
   
%     goodSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    goodSessions = find([M(mouse).summary.polePresent]+[M(mouse).summary.hasWhisker]-[M(mouse).summary.hasScopolamine]+[arrayfun(@(x) sum(x.trialMatrix(:,3)),M(mouse).summary)>0]==3);
    %arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3 is used to find
    %sessions that have FA trials (means introduced no go)
    %%
    % Choose sessions to analyze
    chooseSessions = 1:length(M(mouse).summary);
    
    hitLR = cell(1,length(chooseSessions));
    missLR = cell(1,length(chooseSessions));
    FALR = cell(1,length(chooseSessions));
    CRLR = cell(1,length(chooseSessions));
    edges = [0:0.05:6];
    midEdges = [edges(1:end-1)+edges(2:end)]/2;
    
    
    for i= 1:length(chooseSessions)
        % Extract trial types from the selected sessions
        chooseTM = cat(1,M(mouse).summary(chooseSessions(i)).trialMatrix);
        
        % Extract clean licks from sessions
        chooseCL = cat(1,M(mouse).summary(chooseSessions(i)).cleanLicks);
        
        % Sort clean licks into trial type
        %    For choose sessions
        chooseHitCL = chooseCL(find(chooseTM(:,1)));
        chooseHitCL = cat(1,chooseHitCL{:});
        
        chooseMissCL = chooseCL(find(chooseTM(:,2)));
        chooseMissCL = cat(1,chooseMissCL{:});
        
        chooseFACL = chooseCL(find(chooseTM(:,3)));
        chooseFACL = cat(1,chooseFACL{:});
        
        chooseCRCL = chooseCL(find(chooseTM(:,4)));
        chooseCRCL = cat(1,chooseCRCL{:});
        
        
        
        L(mouse).hitLR{chooseSessions(i)} = histcounts(chooseHitCL,edges)/(sum(chooseTM(:,1))*edges(2));
        L(mouse).missLR{chooseSessions(i)} = histcounts(chooseMissCL,edges)/(sum(chooseTM(:,2))*edges(2));
        L(mouse).FALR{chooseSessions(i)} = histcounts(chooseFACL,edges)/(sum(chooseTM(:,3))*edges(2));
        L(mouse).CRLR{chooseSessions(i)} = histcounts(chooseCRCL,edges)/(sum(chooseTM(:,4))*edges(2));
        L(mouse).goodSessions =goodSessions;
        
    end
end

%% get max lick rate
for mouse=1:8
    for i=1:length(L(mouse).hitLR)
        L(mouse).maxLRhit(i)=max(L(mouse).hitLR{i});
    end
    
    for i=1:length(L(mouse).missLR)
        L(mouse).maxLRMiss(i)=max(L(mouse).missLR{i});
    end
 
    for i=1:length(L(mouse).CRLR)
        L(mouse).maxLRCR(i)=max(L(mouse).CRLR{i});
    end
    
    for i=1:length(L(mouse).FALR)
        L(mouse).maxLRFA(i)=max(L(mouse).FALR{i});
    end    
    
end

%% plot the max lick rate comparison between beginner and expert
%get the max lick rate for beginner sessions 
for mouse=1:8
    plotSessions = L(mouse).goodSessions(1:3);
    maxLRhit_Beginner(mouse)=mean(L(mouse).maxLRhit(plotSessions));
    maxLRMiss_Beginner(mouse)=mean(L(mouse).maxLRMiss(plotSessions));
    maxLRCR_Beginner(mouse)=mean(L(mouse).maxLRCR(plotSessions));
    maxLRFA_Beginner(mouse)=mean(L(mouse).maxLRFA(plotSessions));
end

%get the max lick rate for expert sessions 
for mouse=1:8
    plotSessions = L(mouse).goodSessions(end-2:end);
    maxLRhit_Expert(mouse)=mean(L(mouse).maxLRhit(plotSessions));
    maxLRMiss_Expert(mouse)=mean(L(mouse).maxLRMiss(plotSessions));
    maxLRCR_Expert(mouse)=mean(L(mouse).maxLRCR(plotSessions));
    maxLRFA_Expert(mouse)=mean(L(mouse).maxLRFA(plotSessions));
end


 [h, p] = ttest(maxLRhit_Expert, maxLRhit_Beginner);
 pVal = p;
 figure(1);clf
for mouse=1:8
plot([0.5 1.5],[maxLRhit_Beginner(mouse) maxLRhit_Expert(mouse)],'-k','linewidth',2)
hold on
plot(0.5,maxLRhit_Beginner(mouse),'k.','MarkerSize',25)
plot(1.5,maxLRhit_Expert(mouse),'k.','MarkerSize',25)
end
% plot([1 2],[mean(maxLRhit_Beginner) mean(maxLRhit_Expert)],'-r','linewidth',2)
hold on
plot(0.5,mean(maxLRhit_Beginner),'r.','MarkerSize',20)
plot(1.5,mean(maxLRhit_Expert),'r.','MarkerSize',20)
sigline([0.5,1.5],'p=0.9097')
hold on
x=[0.5,1.5]
y=[mean(maxLRhit_Beginner),mean(maxLRhit_Expert)]
sd_vct=[std(maxLRhit_Beginner)./8.^.5 std(maxLRhit_Expert)./8.^.5]
errorbar(x,y,sd_vct, 'rp')
xlim([0 1.8])
ylim([0 10])
ylabel('max Lick rate','FontSize', 20,'FontWeight','bold')
xticks([0.5 1.5])
xticklabels({'Beginner','Expert'})
ax = gca;
ax.FontSize = 20; 
f = figure(1);
f.Position = [100 100 600 600];
print(gcf,'-depsc2',['MaxLickRateBeginnerExpert']);
print(gcf,'-dpng','-r300',['MaxLickRateBeginnerExpert']);
print(gcf,'-depsc2',['MaxLickRateBeginnerExpertwithStatistics']);
print(gcf,'-dpng','-r300',['MaxLickRateBeginnerExpertwithStatistics']);

%FA trials
figure(2);clf
for mouse=1:8
plot([0.5 1.5],[maxLRFA_Beginner(mouse) maxLRFA_Expert(mouse)],'-k','linewidth',2)
hold on
plot(0.5,maxLRFA_Beginner(mouse),'k.','MarkerSize',25)
plot(1.5,maxLRFA_Expert(mouse),'k.','MarkerSize',25)
end
% plot([1 2],[mean(maxLRhit_Beginner) mean(maxLRhit_Expert)],'-r','linewidth',2)
hold on
plot(0.5,mean(maxLRFA_Beginner),'r.','MarkerSize',20)
plot(1.5,mean(maxLRFA_Expert),'r.','MarkerSize',20)
hold on
x=[0.5,1.5]
y=[mean(maxLRFA_Beginner),mean(maxLRFA_Expert)]
sd_vct=[std(maxLRFA_Beginner)./8.^.5 std(maxLRFA_Expert)./8.^.5]
errorbar(x,y,sd_vct, 'rp')
xlim([0 1.8])
ylim([0 10])
ylabel('max Lick rate','FontSize', 20,'FontWeight','bold')
xticks([0.5 1.5])
xticklabels({'Beginner','Expert'})
ax = gca;
ax.FontSize = 20; 
f = figure(2);
f.Position = [100 100 600 600];
print(gcf,'-depsc2',['MaxLickRateBeginnerExpertFA']);
print(gcf,'-dpng','-r300',['MaxLickRateBeginnerExpertFA']);




















%% Plot Individual Sessions

for mouse = 1:8
    
    figure(1);clf
    subplot(2,1,1)
    plotSessions = L(mouse).goodSessions(1:3);
    
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).hitLR{plotSessions})),std(cat(1,L(mouse).hitLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-b')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).missLR{plotSessions})),std(cat(1,L(mouse).missLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-k')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).FALR{plotSessions})),std(cat(1,L(mouse).FALR{plotSessions}))./length(plotSessions).^.5,'lineprops','-g')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).CRLR{plotSessions})),std(cat(1,L(mouse).CRLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-r')
    
    % Save the average early sessions to the L structure
    L(mouse).earlyHitLR = mean(cat(1,L(mouse).hitLR{plotSessions}));
    L(mouse).earlyMissLR = mean(cat(1,L(mouse).missLR{plotSessions}));
    L(mouse).earlyFALR = mean(cat(1,L(mouse).FALR{plotSessions}));
    L(mouse).earlyCRLR = mean(cat(1,L(mouse).CRLR{plotSessions}));
    
    % Plot individuals
    hold on
    plot([.1 .1], [6 8],'-k','linewidth',2)
    plot(1.09+[0 1], [8 8],'-m','linewidth',2)
    plot(1.09+[1 2], [8 8],'-c','linewidth',2)
    plot([1.09 1.09], [0 8],':m','linewidth',1)
    plot([2.09 2.09], [0 8],':c','linewidth',1)
    
    set(get(gca,'ylabel'),'string','Licks / s (early sessions)')
    title(M(mouse).summary(1).name(1:4))
    set(gca,'ylim',[0 8.5])
    
    plotSessions = L(mouse).goodSessions(end-2:end);
    
    % Save the average late sessions to the L structure
    L(mouse).lateHitLR = mean(cat(1,L(mouse).hitLR{plotSessions}));
    L(mouse).lateMissLR = mean(cat(1,L(mouse).missLR{plotSessions}));
    L(mouse).lateFALR = mean(cat(1,L(mouse).FALR{plotSessions}));
    L(mouse).lateCRLR = mean(cat(1,L(mouse).CRLR{plotSessions}));
    
    subplot(2,1,2)
    
    
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).hitLR{plotSessions})),std(cat(1,L(mouse).hitLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-b')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).missLR{plotSessions})),std(cat(1,L(mouse).missLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-k')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).FALR{plotSessions})),std(cat(1,L(mouse).FALR{plotSessions}))./length(plotSessions).^.5,'lineprops','-g')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).CRLR{plotSessions})),std(cat(1,L(mouse).CRLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-r')
    hold on
    plot([.1 .1], [6 8],'-k','linewidth',2)
    plot(1.09+[0 1], [8 8],'-m','linewidth',2)
    plot(1.09+[1 2], [8 8],'-c','linewidth',2)
    plot([1.09 1.09], [0 8],':m','linewidth',1)
    plot([2.09 2.09], [0 8],':c','linewidth',1)
    
    set(gca,'ylim',[0 8.5])
    set(get(gca,'xlabel'),'string','Time (s)')
    set(get(gca,'ylabel'),'string','Licks / s (expert sessions)')
    
%     print(gcf,'-depsc2',['LickRates_' d(m).name(1:6)]);
%     print(gcf,'-dpng','-r300',['LickRates_' d(m).name(1:6)]);
    
    
    
    
    
    
    
end

%% plot individual mouse expert session lick rates

for mouse = 1:8
    
    figure(1);clf
    plotSessions = L(mouse).goodSessions(end-2:end);
    
    % Save the average late sessions to the L structure
    L(mouse).lateHitLR = mean(cat(1,L(mouse).hitLR{plotSessions}));
    L(mouse).lateMissLR = mean(cat(1,L(mouse).missLR{plotSessions}));
    L(mouse).lateFALR = mean(cat(1,L(mouse).FALR{plotSessions}));
    L(mouse).lateCRLR = mean(cat(1,L(mouse).CRLR{plotSessions}));
    
  
    
    
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).hitLR{plotSessions})),std(cat(1,L(mouse).hitLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-b')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).missLR{plotSessions})),std(cat(1,L(mouse).missLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-k')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).FALR{plotSessions})),std(cat(1,L(mouse).FALR{plotSessions}))./length(plotSessions).^.5,'lineprops','-g')
    shadedErrorBar(midEdges,mean(cat(1,L(mouse).CRLR{plotSessions})),std(cat(1,L(mouse).CRLR{plotSessions}))./length(plotSessions).^.5,'lineprops','-r')
    hold on
    plot([.1 .1], [6 8],'-k','linewidth',2)
    plot(1.09+[0 1], [8 8],'-m','linewidth',2)
    plot(1.09+[1 2], [8 8],'-c','linewidth',2)
    plot([1.09 1.09], [0 8],':m','linewidth',1)
    plot([2.09 2.09], [0 8],':c','linewidth',1)
    
    title(M(mouse).summary(1).name(1:4))
  
    set(gca,'ylim',[0 8.5])
    set(get(gca,'xlabel'),'string','Time (s)')
    set(get(gca,'ylabel'),'string','Licks / s (expert sessions)')
    
%     print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) 'LickRates_Expert']);
%     print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) 'LickRates_Expert']);
    

end

%% Plot Gra Sessions

figure(2);clf
subplot(2,1,1)

shadedErrorBar(midEdges,mean(cat(1,L.earlyHitLR)),std(cat(1,L.earlyHitLR))./length(M).^.5,'lineprops','-b')
shadedErrorBar(midEdges,mean(cat(1,L.earlyMissLR)),std(cat(1,L.earlyMissLR))./length(M).^.5,'lineprops','-k')
shadedErrorBar(midEdges,mean(cat(1,L.earlyFALR)),std(cat(1,L.earlyFALR))./length(M).^.5,'lineprops','-g')
shadedErrorBar(midEdges,mean(cat(1,L.earlyCRLR)),std(cat(1,L.earlyCRLR))./length(M).^.5,'lineprops','-r')

hold on
plot([.1 .1], [6 8],'-k','linewidth',2)
plot(1.09+[0 1], [8 8],'-m','linewidth',2)
plot(1.09+[1 2], [8 8],'-c','linewidth',2)
plot([1.09 1.09], [0 8],':m','linewidth',1)
plot([2.09 2.09], [0 8],':c','linewidth',1)


subplot(2,1,2)

shadedErrorBar(midEdges,mean(cat(1,L.lateHitLR)),std(cat(1,L.lateHitLR))./length(M).^.5,'lineprops','-b')
shadedErrorBar(midEdges,mean(cat(1,L.lateMissLR)),std(cat(1,L.lateMissLR))./length(M).^.5,'lineprops','-k')
shadedErrorBar(midEdges,mean(cat(1,L.lateFALR)),std(cat(1,L.lateFALR))./length(M).^.5,'lineprops','-g')
shadedErrorBar(midEdges,mean(cat(1,L.lateCRLR)),std(cat(1,L.lateCRLR))./length(M).^.5,'lineprops','-r')

hold on
plot([.1 .1], [6 8],'-k','linewidth',2)
plot(1.09+[0 1], [8 8],'-m','linewidth',2)
plot(1.09+[1 2], [8 8],'-c','linewidth',2)
plot([1.09 1.09], [0 8],':m','linewidth',1)
plot([2.09 2.09], [0 8],':c','linewidth',1)

set(gca,'ylim',[0 8.5])
set(get(gca,'xlabel'),'string','Time (s)')
set(get(gca,'ylabel'),'string','Licks / s (expert sessions)')

print(gcf,'-depsc2',['LickRates_GrandMean']);
print(gcf,'-dpng','-r300',['LickRates_GrandMean']);

%% plot Grand mean for expert Sessions
figure(2);clf



shadedErrorBar(midEdges,mean(cat(1,L.lateHitLR)),std(cat(1,L.lateHitLR))./length(M).^.5,'lineprops','-b')
shadedErrorBar(midEdges,mean(cat(1,L.lateMissLR)),std(cat(1,L.lateMissLR))./length(M).^.5,'lineprops','-k')
shadedErrorBar(midEdges,mean(cat(1,L.lateFALR)),std(cat(1,L.lateFALR))./length(M).^.5,'lineprops','-g')
shadedErrorBar(midEdges,mean(cat(1,L.lateCRLR)),std(cat(1,L.lateCRLR))./length(M).^.5,'lineprops','-r')

hold on
plot([.1 .1], [6 8],'-k','linewidth',2)
plot(1.09+[0 1], [8 8],'-m','linewidth',2)
plot(1.09+[1 2], [8 8],'-c','linewidth',2)
plot([1.09 1.09], [0 8],':m','linewidth',1)
plot([2.09 2.09], [0 8],':c','linewidth',1)

set(gca,'ylim',[0 8.5])
set(get(gca,'xlabel'),'string','Time (s)')
set(get(gca,'ylabel'),'string','Licks / s (expert sessions)')

print(gcf,'-depsc2',['LickRates_GrandMeanExpert']);
print(gcf,'-dpng','-r300',['LickRates_GrandMeanExpert']);




%% plot first answer lick aligned lick rate
%get a new clean lick matrix, every lick shift back first answer lick time
answerPeriod=2.08;
for mouse=1:8
    for i=1:length(M(mouse).summary)
        for t=1:length(M(mouse).summary(i).cleanLicks)
            f2=M(mouse).summary(i).cleanLicks{t};
            f3=f2(find(M(mouse).summary(i).cleanLicks{t}>=answerPeriod & M(mouse).summary(i).cleanLicks{t}<=answerPeriod+1));
            if ~isempty(f3)
                M(mouse).summary(i).newcleanLicks{t}=M(mouse).summary(i).cleanLicks{t}-min(f3);
            else
                M(mouse).summary(i).newcleanLicks{t}=M(mouse).summary(i).cleanLicks{t};
            end
        end
    end
end

for mouse = 1:8
    
   
%     goodSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    goodSessions = find([M(mouse).summary.polePresent]+[M(mouse).summary.hasWhisker]-[M(mouse).summary.hasScopolamine]+[arrayfun(@(x) sum(x.trialMatrix(:,3)),M(mouse).summary)>0]==3);
    %arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3 is used to find
    %sessions that have FA trials (means introduced no go)
    %%
    % Choose sessions to analyze
    chooseSessions = 1:length(M(mouse).summary);
    
    hitLR = cell(1,length(chooseSessions));
    missLR = cell(1,length(chooseSessions));
    FALR = cell(1,length(chooseSessions));
    CRLR = cell(1,length(chooseSessions));
    edges = [-0.04:0.08:6];
    midEdges = [edges(1:end-1)+edges(2:end)]/2;
    
    
    for i= 1:length(chooseSessions)
        % Extract trial types from the selected sessions
        chooseTM = cat(1,M(mouse).summary(chooseSessions(i)).trialMatrix);
        
        % Extract clean licks from sessions
        chooseCL = cat(1,M(mouse).summary(chooseSessions(i)).newcleanLicks);
        
        % Sort clean licks into trial type
        %    For choose sessions
        chooseHitCL = chooseCL(find(chooseTM(:,1)));
        chooseHitCL = cat(1,chooseHitCL{:});
        
        chooseMissCL = chooseCL(find(chooseTM(:,2)));
        chooseMissCL = cat(1,chooseMissCL{:});
        
        chooseFACL = chooseCL(find(chooseTM(:,3)));
        chooseFACL = cat(1,chooseFACL{:});
        
        chooseCRCL = chooseCL(find(chooseTM(:,4)));
        chooseCRCL = cat(1,chooseCRCL{:});
        
        
        
        L(mouse).hitLR{chooseSessions(i)} = histcounts(chooseHitCL,edges)/(sum(chooseTM(:,1))*edges(2));
        L(mouse).missLR{chooseSessions(i)} = histcounts(chooseMissCL,edges)/(sum(chooseTM(:,2))*edges(2));
        L(mouse).FALR{chooseSessions(i)} = histcounts(chooseFACL,edges)/(sum(chooseTM(:,3))*edges(2));
        L(mouse).CRLR{chooseSessions(i)} = histcounts(chooseCRCL,edges)/(sum(chooseTM(:,4))*edges(2));
        L(mouse).goodSessions =goodSessions;
        
    end
end

for mouse = 1:8
     
    plotSessions1 = L(mouse).goodSessions(1:3);
    
    % Save the average early sessions to the L structure
    L(mouse).earlyHitLR = mean(cat(1,L(mouse).hitLR{plotSessions1}));
    L(mouse).earlyMissLR = mean(cat(1,L(mouse).missLR{plotSessions1}));
    L(mouse).earlyFALR = mean(cat(1,L(mouse).FALR{plotSessions1}));
    L(mouse).earlyCRLR = mean(cat(1,L(mouse).CRLR{plotSessions1}));
    
    
    plotSessions2 = L(mouse).goodSessions(end-2:end);
    
    % Save the average late sessions to the L structure
    L(mouse).lateHitLR = mean(cat(1,L(mouse).hitLR{plotSessions2}));
    L(mouse).lateMissLR = mean(cat(1,L(mouse).missLR{plotSessions2}));
    L(mouse).lateFALR = mean(cat(1,L(mouse).FALR{plotSessions2}));
    L(mouse).lateCRLR = mean(cat(1,L(mouse).CRLR{plotSessions2}));
       
end

figure(2);clf



shadedErrorBar(midEdges,mean(cat(1,L.lateHitLR)),std(cat(1,L.lateHitLR))./length(M).^.5,'lineprops','-b')
% shadedErrorBar(midEdges,mean(cat(1,L.lateMissLR)),std(cat(1,L.lateMissLR))./length(M).^.5,'lineprops','-k')
shadedErrorBar(midEdges,mean(cat(1,L.lateFALR)),std(cat(1,L.lateFALR))./length(M).^.5,'lineprops','-g')
% shadedErrorBar(midEdges,mean(cat(1,L.lateCRLR)),std(cat(1,L.lateCRLR))./length(M).^.5,'lineprops','-r')

% 
% hold on
% plot([.1 .1], [6 8],'-k','linewidth',2)
% plot(1.09+[0 1], [8 8],'-m','linewidt',2)
% plot(1.09+[1 2], [8 8],'-c','linewidth',2)
% plot([1.09 1.09], [0 8],':m','linewidth',1)
% plot([2.09 2.09], [0 8],':c','linewidth',1)

% set(gca,'ylim',[0 8.5])
set(get(gca,'xlabel'),'string','Time from first ans lick(s)')
set(get(gca,'ylabel'),'string','Licks / s (expert sessions)')
legend('Hit Expert','FA Expert')

print(gcf,'-depsc2',['LickRatesAlignedtoFirstAnsLick_GrandMeanExpert']);
print(gcf,'-dpng','-r300',['LickRatesAlignedtoFirstAnsLick_GrandMeanExpert']);