
%% Gather the first licks in dataset
firstLicks = cell(8,1);
firstLicksEarly = cell(8,1);
firstLicksLate = cell(8,1);
numLicks= cell(8,1);
numLicksEarly= cell(8,1);
numLicksLate = cell(8,1);
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
baseline2=[1:16];
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
        
        
        baseAch{mouse} = vertcat(baseAch{mouse},baseAchTmp);
        baseAch2{mouse} = vertcat(baseAch2{mouse},baseAchTmp2);
        trialAch{mouse} = vertcat(trialAch{mouse},trialAchTmp);
        goodTrial{mouse} = vertcat(goodTrial{mouse},goodTrialTmp);
        firstLickAch{mouse} = vertcat(firstLickAch{mouse},firstLickAchTmp);
        isExpert{mouse} = vertcat(isExpert{mouse},isExpertTmp);
        gotReward{mouse} = vertcat(gotReward{mouse},gotRewardTmp);
        isBeginner{mouse}=vertcat(isBeginner{mouse},isBeginnerTmp);
        trialAmp{mouse}=vertcat(trialAmp{mouse},trialAmpTmp);
    end
    goodTrial{mouse} = logical(goodTrial{mouse});
    trialDFF{mouse} = trialAch{mouse}./repmat(baseAch{mouse},1,size(trialAch{mouse},2))-1;
    trialDFF2{mouse} = trialAch{mouse}./repmat(baseAch2{mouse},1,size(trialAch{mouse},2))-1;
    firstLickDFF{mouse} = firstLickAch{mouse}./baseAch{mouse}-1;
    
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

%% plot no lick trials Ach response heatmap sorted by pole up and pole down twitch amplitude
for mouse=1:8
    nolickAch=trialDFF2{mouse}(goodTrial{mouse} & numLicks{mouse}==0,:);
    nolickWhisk=trialAmp{mouse}(goodTrial{mouse} & numLicks{mouse}==0,:);
    %sort by size of early whisker twitch
%     twitchWindow_early = 330:414; %pole up twitch
    twitchWindow_early =  336:504; %0.5 second post pole up
%     excludeAmpWindow = {415:600,1:300}
    excludeAmpWindow = {1:310};
    [~,ampIdx_early] = sort(mean(nolickWhisk(:,twitchWindow_early),2));
%     [twitchOnlyIdx_early] = find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5 & mean(nolickWhisk(:,excludeAmpWindow{2}),2)<3);
        [twitchOnlyIdx_early] = find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
%     achWindow_early = 20:27;
        achWindow_early = 18:33;
%     achCueResponse = mean(nolickAch(:,achWindow_early),2);
%     twitchCueResponse = mean(nolickWhisk(:,twitchWindow_early),2);
    figure(1);;clf;hold on
    imagesc(nolickWhisk(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),:))
    hold on
    plot([336 504], [470 470],'-k','linewidth',4)
    colorbar
   ax=gca;
    ax.CLim = [2 30];
    colormap(hot)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*311)
    set(gca,'xtick', [0:6]*311, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'amplitude heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole up twitch amp'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole up twitch amp'])
    
    figure(2);clf;hold on
%     imagesc(cat(1,nolickAch(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),1:100)))
    imagesc(nolickAch(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),1:100))
    colorbar
    ax=gca;
    ax.CLim = [-0.02 .04];
    colormap(gray)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*15.44)
    set(gca,'xtick', [0:6]*15.44, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'Ach heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole up twitch amp'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole up twitch amp'])
    
end    

for mouse=1:8
    nolickAch=trialDFF2{mouse}(goodTrial{mouse} & numLicks{mouse}==0,:);
    nolickWhisk=trialAmp{mouse}(goodTrial{mouse} & numLicks{mouse}==0,:);
    %sort by size of late whisker twitch
%     twitchWindow = 330:414
%     twitchWindow = 957:1041 %pole down twitch
    twitchWindow =  311*2+[336:504]; 
%     excludeAmpWindow = {415:600,1:300}
    excludeAmpWindow = {1:310} % first second want to exclude trials with ongoing whisking pre cue
    [~,ampIdx] = sort(mean(nolickWhisk(:,twitchWindow),2))
%     [twitchOnlyIdx] = find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5 & mean(nolickWhisk(:,excludeAmpWindow{2}),2)<3)
    [twitchOnlyIdx] =find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5) % exclude trials with ongoing whisking pre cue
    % covariance of whisker twitch with ach response, no lick trials
%     achWindow = 20:27
%     achWindow=50:57
    achWindow=31+[18:33];
%     achCueResponse = mean(nolickAch(:,achWindow),2);
%     twitchCueResponse = mean(nolickWhisk(:,twitchWindow),2);
    figure(3);;clf;hold on
    imagesc(nolickWhisk(intersect(ampIdx,twitchOnlyIdx,'stable'),:))
    hold on
    plot([336+311*2 504+311*2], [470 470],'-k','linewidth',4)
    colorbar
    ax=gca;
    ax.CLim = [2 30];
    colormap(hot)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*311)
    set(gca,'xtick', [0:6]*311, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'amplitude heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole down twitch amp'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole down twitch amp'])
    
    figure(4);clf;hold on
%     imagesc(cat(1,nolickAch(intersect(ampIdx,twitchOnlyIdx,'stable'),1:100)))
    imagesc(nolickAch(intersect(ampIdx,twitchOnlyIdx,'stable'),1:100))  
    colorbar
    ax=gca;
    ax.CLim = [-0.02 .04];
    colormap(gray)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*15.44)
    set(gca,'xtick', [0:6]*15.44, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'Ach heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole down twitch amp'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole down twitch amp'])
end

%% get expert sessions of no lick trials Ach response heatmap sorted by pole up and pole down twitch amplitude
for mouse=1:8
    nolickAchExpert=trialDFF2{mouse}(goodTrial{mouse} & numLicks{mouse}==0 &isExpert{mouse},:);
    nolickWhiskExpert=trialAmp{mouse}(goodTrial{mouse} & numLicks{mouse}==0 &isExpert{mouse},:);
    %sort by size of early whisker twitch
%     twitchWindow_early = 330:414; %pole up twitch
    twitchWindow_early =  336:504; %1 second post pole up
%     excludeAmpWindow = {415:600,1:300}
    excludeAmpWindow = {1:310}
    [~,ampIdx_early] = sort(mean(nolickWhiskExpert(:,twitchWindow_early),2));
%     [twitchOnlyIdx_early] = find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5 & mean(nolickWhisk(:,excludeAmpWindow{2}),2)<3);
        [twitchOnlyIdx_early] = find(mean(nolickWhiskExpert(:,excludeAmpWindow{1}),2)<5) % exclude trials with ongoing whisking pre cue
%     achWindow_early = 20:27;
        achWindow_early = 18:33;
%     achCueResponse = mean(nolickAch(:,achWindow_early),2);
%     twitchCueResponse = mean(nolickWhisk(:,twitchWindow_early),2);
    figure(1);;clf;hold on
    imagesc(nolickWhiskExpert(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),:))
    hold on
    plot([336 504], [330 330],'-k','linewidth',4)
    colorbar
   ax=gca;
    ax.CLim = [2 30];
    colormap(hot)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*311)
    set(gca,'xtick', [0:6]*311, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'amplitude heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole up twitch amp Expert'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole up twitch amp Expert'])
    
    figure(2);clf;hold on
%     imagesc(cat(1,nolickAch(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),1:100)))
    imagesc(nolickAchExpert(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),1:100))
    colorbar
    ax=gca;
    ax.CLim = [-0.02 .04];
    colormap(gray)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*15.44)
    set(gca,'xtick', [0:6]*15.44, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'Ach heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole up twitch amp Expert'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole up twitch amp Expert'])
    
end    

for mouse=1:8
     nolickAchExpert=trialDFF2{mouse}(goodTrial{mouse} & numLicks{mouse}==0 &isExpert{mouse},:);
    nolickWhiskExpert=trialAmp{mouse}(goodTrial{mouse} & numLicks{mouse}==0 &isExpert{mouse},:);
    %sort by size of late whisker twitch
%     twitchWindow = 330:414
%     twitchWindow = 957:1041 %pole down twitch
    twitchWindow =  311*2+[336:504]; 
%     excludeAmpWindow = {415:600,1:300}
    excludeAmpWindow = {1:310} % first second want to exclude trials with ongoing whisking pre cue
    [~,ampIdx] = sort(mean(nolickWhiskExpert(:,twitchWindow),2))
%     [twitchOnlyIdx] = find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5 & mean(nolickWhisk(:,excludeAmpWindow{2}),2)<3)
    [twitchOnlyIdx] =find(mean(nolickWhiskExpert(:,excludeAmpWindow{1}),2)<5) % exclude trials with ongoing whisking pre cue
    % covariance of whisker twitch with ach response, no lick trials
%     achWindow = 20:27
%     achWindow=50:57
    achWindow=31+[18:33];
%     achCueResponse = mean(nolickAch(:,achWindow),2);
%     twitchCueResponse = mean(nolickWhisk(:,twitchWindow),2);
    figure(3);;clf;hold on
    imagesc(nolickWhiskExpert(intersect(ampIdx,twitchOnlyIdx,'stable'),:))
    hold on
    plot([336+311*2 504+311*2], [330 330],'-k','linewidth',4)
    colorbar
    ax=gca;
    ax.CLim = [2 30];
    colormap(hot)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*311)
    set(gca,'xtick', [0:6]*311, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'amplitude heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole down twitch amp Expert'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole down twitch amp Expert'])
    
    figure(4);clf;hold on
%     imagesc(cat(1,nolickAch(intersect(ampIdx,twitchOnlyIdx,'stable'),1:100)))
    imagesc(nolickAchExpert(intersect(ampIdx,twitchOnlyIdx,'stable'),1:100))
    colorbar
    ax=gca;
    ax.CLim = [-0.02 .04];
    colormap(gray)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*15.44)
    set(gca,'xtick', [0:6]*15.44, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'Ach heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole down twitch amp Expert'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole down twitch amp Expert'])
end


%%  plot one lick (after cue onset) trials Ach response heatmap sorted by pole up whisking amplitude
for mouse=1:8
    onelickAch=firstLickDFF3{mouse}(goodTrial{mouse} & ~ispre{mouse} & isHit{mouse} ,:);
    onelickWhisk=trialAmp{mouse}(goodTrial{mouse} & ~ispre{mouse} & isHit{mouse},:);
    %sort by size of early whisker twitch
%     twitchWindow_early = 330:414; %pole up twitch
    twitchWindow_early =  336:504; %1 second post pole up
%     excludeAmpWindow = {415:600,1:300}
    excludeAmpWindow = {1:310};
    [~,ampIdx_early] = sort(mean(onelickWhisk(:,twitchWindow_early),2));
%     [twitchOnlyIdx_early] = find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5 & mean(nolickWhisk(:,excludeAmpWindow{2}),2)<3);
        [twitchOnlyIdx_early] = find(mean(onelickWhisk(:,excludeAmpWindow{1}),2)<5); % exclude trials with ongoing whisking pre cue
%     achWindow_early = 20:27;
        achWindow_early = 33:48;
%     achCueResponse = mean(nolickAch(:,achWindow_early),2);
%     twitchCueResponse = mean(nolickWhisk(:,twitchWindow_early),2);
    figure(1);;clf;hold on
    imagesc(onelickWhisk(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),:))
    colorbar
   ax=gca;
    ax.CLim = [2 30];
    colormap(hot)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*311)
    set(gca,'xtick', [0:6]*311, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'amplitude heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole up twitch amp hit post cue fl tirals'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole up twitch amp hit post cue fl tirals'])
    
    figure(2);clf;hold on
%     imagesc(cat(1,nolickAch(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),1:100)))
    imagesc(onelickAch(intersect(ampIdx_early,twitchOnlyIdx_early,'stable'),1:100))
    colorbar
    ax=gca;
    ax.CLim = [-0.02 .04];
    colormap(gray)
    ax = gca;
    xticks([33-2*15.44:15.44:33+9*15.44]);
    xticklabels({'-2','-1','0','1','2','3','4','5','6','7','8','9'});

    xlabel('time from first lick(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*15.44) 

    title(['Mouse ' M(mouse).summary(1).name(1:4) 'Ach heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole up twitch amp hit post cue fl tirals'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole up twitch amp hit post cue fl tirals'])
    
end    

for mouse=1:8
     nolickAch=trialDFF2{mouse}(goodTrial{mouse} & numLicks{mouse}==0,:);
    nolickWhisk=trialAmp{mouse}(goodTrial{mouse} & numLicks{mouse}==0,:);
    %sort by size of late whisker twitch
%     twitchWindow = 330:414
%     twitchWindow = 957:1041 %pole down twitch
    twitchWindow =  311*2+[336:504]; 
%     excludeAmpWindow = {415:600,1:300}
    excludeAmpWindow = {1:310} % first second want to exclude trials with ongoing whisking pre cue
    [~,ampIdx] = sort(mean(nolickWhisk(:,twitchWindow),2))
%     [twitchOnlyIdx] = find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5 & mean(nolickWhisk(:,excludeAmpWindow{2}),2)<3)
    [twitchOnlyIdx] =find(mean(nolickWhisk(:,excludeAmpWindow{1}),2)<5) % exclude trials with ongoing whisking pre cue
    % covariance of whisker twitch with ach response, no lick trials
%     achWindow = 20:27
%     achWindow=50:57
    achWindow=31+[18:33];
%     achCueResponse = mean(nolickAch(:,achWindow),2);
%     twitchCueResponse = mean(nolickWhisk(:,twitchWindow),2);
    figure(3);;clf;hold on
    imagesc(nolickWhisk(intersect(ampIdx,twitchOnlyIdx,'stable'),:))
    colorbar
    ax=gca;
    ax.CLim = [2 30];
    colormap(hot)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*311)
    set(gca,'xtick', [0:6]*311, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'amplitude heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole down twitch amp'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' amplitude heatmap sorted by pole down twitch amp'])
    
    figure(4);clf;hold on
%     imagesc(cat(1,nolickAch(intersect(ampIdx,twitchOnlyIdx,'stable'),1:100)))
    imagesc(nolickAch(intersect(ampIdx,twitchOnlyIdx,'stable'),1:100))
    colorbar
    ax=gca;
    ax.CLim = [-0.02 .04];
    colormap(gray)
    xlabel('time(seconds)','FontSize',20)
    ylabel('trial','FontSize',20)
    set(gca,'xlim', [0 6]*15.44)
    set(gca,'xtick', [0:6]*15.44, 'xticklabel',[0:6])
    title(['Mouse ' M(mouse).summary(1).name(1:4) 'Ach heatmap'])
    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole down twitch amp'])
    print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) ' Ach heatmap sorted by pole down twitch amp'])
end
