%% Fig5B
% Compare lick number between sampling and answer period bet

numLicks2= cell(8,1);
isExpert = cell(8,1);
isBeginner = cell(8,1);
isHit = cell(8,1);
for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
   
    for i = useSessions
    numLicks2tmp=zeros(length(M(mouse).summary(i).trialStart),1);
    isExpertTmp = zeros(length(M(mouse).summary(i).trialStart),1);
    isBeginnerTmp= zeros(length(M(mouse).summary(i).trialStart),1);   
    isHitTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        if i >= useSessions(end-2);
            isExpertTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        if i <= useSessions(3);
            isBeginnerTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            if M(mouse).summary(i).trialMatrix(t,1) ==1
                isHitTmp(t) = 1;
            else
                isHitTmp(t) = 0;
            end                
        end 
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            if M(mouse).summary(i).trialMatrix(t,1)==1
                idx= find (M(mouse).summary(i).cleanLicks{t}>cell2mat(M(mouse).summary(i).poleOnset(t))& M(mouse).summary(i).cleanLicks{t} < M(mouse).summary(i).waterTime{t}+2);
                numLicks2tmp(t)=numel(idx);
            else
                numLicks2tmp(t)=NaN;
            end
         end
     isExpert{mouse} = vertcat(isExpert{mouse},isExpertTmp);   
     isBeginner{mouse}=vertcat(isBeginner{mouse},isBeginnerTmp);
     numLicks2{mouse}=vertcat(numLicks2{mouse},numLicks2tmp);    
     isHit{mouse}= vertcat(isHit{mouse}, isHitTmp);   
    end
end

%%
expertLickNumHit=NaN(8,size(numLicks2{1,1},2));
for mouse=1:8
expertLickNumHit(mouse,:)=mean(numLicks2{mouse}(isExpert{mouse} & isHit{mouse},:));
end

BeginnerLickNumHit=NaN(8,size(numLicks2{1,1},2));
for mouse=1:8
BeginnerLickNumHit(mouse,:)=mean(numLicks2{mouse}(isBeginner{mouse} & isHit{mouse},:));
end

figure(1);clf
for mouse=1:8
plot([0.5 1.5],[BeginnerLickNumHit(mouse) expertLickNumHit(mouse)],'-k','linewidth',2)
hold on
plot(0.5,BeginnerLickNumHit(mouse),'k.','MarkerSize',25)
plot(1.5,expertLickNumHit(mouse),'k.','MarkerSize',25)
end
% plot([1 2],[mean(maxLRhit_Beginner) mean(maxLRhit_Expert)],'-r','linewidth',2)
hold on
plot(0.5,mean(BeginnerLickNumHit),'r.','MarkerSize',20)
plot(1.5,mean(expertLickNumHit),'r.','MarkerSize',20)
sigline([0.5,1.5],'p=0.0172')
hold on
x=[0.5,1.5]
y=[mean(BeginnerLickNumHit),mean(expertLickNumHit)]
sd_vct=[std(BeginnerLickNumHit)./8.^.5 std(expertLickNumHit)./8.^.5]
errorbar(x,y,sd_vct, 'rp')
xlim([0 1.8])
ylim([0 14.5])
ylabel('LickNum','FontSize', 20,'FontWeight','bold')
xticks([0.5 1.5])
xticklabels({'Beginner','Expert'})
ax = gca;
ax.FontSize = 20; 
f = figure(1);
f.Position = [100 100 600 600];
print(gcf,'-depsc2',['HitTrialsLickNumInSampleAnswerPeriodExpertBeginnerComparison']);
print(gcf,'-dpng','-r300',['HitTrialsLickNumInSampleAnswerPeriodExpertBeginnerComparison']);
% print(gcf,'-depsc2',['HitTrialsLickNumInSampleAnswerPeriodExpertBeginnerComparisonwithStatistics']);
% print(gcf,'-dpng','-r300',['HitTrialsLickNumInSampleAnswerPeriodExpertBeginnerComparisonwithStatistics']);
 % run t test on the expert and beginner lick number
 [h, p] = ttest(expertLickNumHit, BeginnerLickNumHit);
    pVal = p;

%% Fig5B compare lick numbers between Hit and FA 1s after first lick in expert sessions    (already flag expert, beginner, trial type...)
    numLicks3= cell(8,1);
for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
   
    for i = useSessions
    numLicks3tmp=zeros(length(M(mouse).summary(i).trialStart),1);
 

        
        for t = 1:length(M(mouse).summary(i).trialStart)
            if ~isempty(M(mouse).summary(i).cleanLicks{t})
                idx= find (M(mouse).summary(i).cleanLicks{t} < M(mouse).summary(i).cleanLicks{t}(1)+1);
                numLicks3tmp(t)=numel(idx);
            else
                numLicks3tmp(t)=NaN;
            end
         end

     numLicks3{mouse}=vertcat(numLicks3{mouse},numLicks3tmp);    

    end
end



%%
expertLickNumHit=NaN(8,size(numLicks3{1,1},2));
for mouse=1:8
expertLickNumHit(mouse,:)=mean(numLicks3{mouse}(isExpert{mouse} & isHit{mouse},:));
end

ExpertLickNumFA=NaN(8,size(numLicks3{1,1},2));
for mouse=1:8
ExpertLickNumFA(mouse,:)=mean(numLicks3{mouse}(isExpert{mouse} & isFA{mouse},:));
end

 [h, p] = ttest(expertLickNumHit, ExpertLickNumFA);
    pVal = p

figure(1);clf
for mouse=1:8

plot([0.5 1.5],[ExpertLickNumFA(mouse) expertLickNumHit(mouse)],'-k','linewidth',2)
hold on
plot(0.5,ExpertLickNumFA(mouse),'k.','MarkerSize',25)
plot(1.5,expertLickNumHit(mouse),'k.','MarkerSize',25)
end
% plot([1 2],[mean(maxLRhit_Beginner) mean(maxLRhit_Expert)],'-r','linewidth',2)
hold on
plot(0.5,mean(ExpertLickNumFA),'r.','MarkerSize',20)
plot(1.5,mean(expertLickNumHit),'r.','MarkerSize',20)
sigline([0.5,1.5],'p=6.8008e-05')
hold on
x=[0.5,1.5]
y=[mean(ExpertLickNumFA),mean(expertLickNumHit)]
sd_vct=[std(ExpertLickNumFA)./8.^.5 std(expertLickNumHit)./8.^.5]
errorbar(x,y,sd_vct, 'rp')
xlim([0 1.8])
ylim([0 8])
ylabel('LickNum','FontSize', 20,'FontWeight','bold')
xticks([0.5 1.5])
xticklabels({'FA','Hit'})
ax = gca;
ax.FontSize = 20; 
f = figure(1);
f.Position = [100 100 600 600];
print(gcf,'-depsc2',['LickNum1sPostFLHitFAComparisonExpertSessions']);
print(gcf,'-dpng','-r300',['LickNum1sPostFLHitFAComparisonExpertSessions']);
% print(gcf,'-depsc2',['HitTrialsLickNumInSampleAnswerPeriodExpertBeginnerComparisonwithStatistics']);
% print(gcf,'-dpng','-r300',['HitTrialsLickNumInSampleAnswerPeriodExpertBeginnerComparisonwithStatistics']);
 % run t test on the expert and beginner lick number
 [h, p] = ttest(expertLickNumHit, BeginnerLickNumHit);
    pVal = p;