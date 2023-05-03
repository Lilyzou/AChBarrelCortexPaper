% This script combines both the Heat Maps and Traces scripts and adds
% subplot functions

mkdir('Heat Maps Long');
mkdir('Traces Long');
mkdir('Heat Maps and Traces Long');
currFolder = pwd;
saveTo = strcat(currFolder,'\Heat Maps Long\');

figNum = 1;

d = dir('*Struct.mat');

for m = 1:length(d)
    load(d(m).name);
    
    cd 'Heat Maps Long'
    mkdir(['AH' summary(1).name(1:4)]);
    cd ..
    cd 'Traces Long'
    mkdir(['AH' summary(1).name(1:4)]);
    cd ..
    cd 'Heat Maps and Traces Long'
    mkdir(['AH' summary(1).name(1:4)]);
    cd ..
    
    for i = 1:length(summary)
        currIndex = 0;
        
        %uncomment whichever one you want to get figures for
        currFolder = pwd;
        saveTo = strcat(currFolder,['\Heat Maps Long\AH',summary(i).name(1:4),'\']);
        
        
%         FOV = summary(i).wholeFOVrigid;
        FOV = summary(i).maskedFOVrigid;
%         FOV = summary(i).c2FOVrigid;
%         FOV = summary(i).c2SurroundFOVrigid;
%         FOV = summary(i).wholeFOVraw;


        if (isempty(FOV))
            continue;
        end
        
        avgPoleOnset = nanmean([summary(i).poleOnset{:}]);
        
        %% heat maps
        
        
        fmap = figure(figNum);
        hitTrialIndex = find(summary(i).trialMatrix(:,1));
        missTrialIndex = find(summary(i).trialMatrix(:,2));
        faTrialIndex = find(summary(i).trialMatrix(:,3));
        crTrialIndex = find(summary(i).trialMatrix(:,4));
        
        if strcmp(summary(i).name, '1151_1029_000')
            hitTrialIndex = hitTrialIndex(hitTrialIndex <= 190);
            missTrialIndex = missTrialIndex(missTrialIndex <= 190);
            faTrialIndex = faTrialIndex(faTrialIndex <= 190);
            crTrialIndex = crTrialIndex(crTrialIndex <= 190);
        end
        
        hitTrialIndex = hitTrialIndex(summary(i).trialStart(hitTrialIndex) > 1500);
        missTrialIndex = missTrialIndex(summary(i).trialStart(missTrialIndex) > 1500);
        faTrialIndex = faTrialIndex(summary(i).trialStart(faTrialIndex) > 1500);
        crTrialIndex = crTrialIndex(summary(i).trialStart(crTrialIndex) > 1500);
        
        
        hitTrials = NaN(length(hitTrialIndex),max(summary(i).trialLength));
        missTrials = NaN(length(missTrialIndex),max(summary(i).trialLength));
        faTrials = NaN(length(faTrialIndex),max(summary(i).trialLength));
        crTrials = NaN(length(crTrialIndex),max(summary(i).trialLength));
        
        minOfMaxTrials = min([max(summary(i).trialLength(hitTrialIndex)), max(summary(i).trialLength(missTrialIndex)), max(summary(i).trialLength(faTrialIndex)), max(summary(i).trialLength(crTrialIndex))]);
        
        poleOnset.hit(1) = NaN;
        for j = 1:length(hitTrialIndex)
            hitTrials(j,1:summary(i).trialLength(hitTrialIndex(j))) = FOV(summary(i).trialStart(hitTrialIndex(j)):summary(i).trialStart(hitTrialIndex(j))+summary(i).trialLength(hitTrialIndex(j))-1);
            poleOnset.hit(j) = cell2mat(summary(i).poleOnset(hitTrialIndex(j)));
        end
        poleOnset.miss(1) = NaN;
        for j = 1:length(missTrialIndex)
            missTrials(j,1:summary(i).trialLength(missTrialIndex(j))) = FOV(summary(i).trialStart(missTrialIndex(j)):summary(i).trialStart(missTrialIndex(j))+summary(i).trialLength(missTrialIndex(j))-1);
            poleOnset.miss(j) = cell2mat(summary(i).poleOnset(missTrialIndex(j)));
        end
        poleOnset.fa(1) = NaN;
        for j = 1:length(faTrialIndex)
            faTrials(j,1:summary(i).trialLength(faTrialIndex(j))) = FOV(summary(i).trialStart(faTrialIndex(j)):summary(i).trialStart(faTrialIndex(j))+summary(i).trialLength(faTrialIndex(j))-1);
            poleOnset.fa(j) = cell2mat(summary(i).poleOnset(faTrialIndex(j)));
        end
        poleOnset.cr(1) = NaN;
        for j = 1:length(crTrialIndex)
            crTrials(j,1:summary(i).trialLength(crTrialIndex(j))) = FOV(summary(i).trialStart(crTrialIndex(j)):summary(i).trialStart(crTrialIndex(j))+summary(i).trialLength(crTrialIndex(j))-1);
            poleOnset.cr(j) = cell2mat(summary(i).poleOnset(crTrialIndex(j)));
        end
        emptySpace = NaN(25,max(summary(i).trialLength));
        sorted = vertcat(hitTrials, emptySpace, missTrials, emptySpace, crTrials, emptySpace, faTrials);
        
        for k = 1:size(sorted,1)
            sorted(k,:) = sorted(k,:)/nanmean(sorted(k,1:16)) - 1; %first 16 frames normalization
        end
        xVals = 1:minOfMaxTrials;
        xVals = xVals/15.44;
        yVals = 1:size(sorted,1);
        imagesc(xVals,yVals,sorted(:,1:minOfMaxTrials), [-0.02, 0.05]);
        hold on;
        
        axis xy;
        xlabel('Time(s)');
        xticks([avgPoleOnset-1:1:avgPoleOnset+10]);
        xticklabels({'-1','0','1','2','3','4','5','6','7','8','9','10'});
        set(gca,'YTick',[], 'XLim', [0 minOfMaxTrials/15.44]);
        colormap('gray');
        colorbar('Ticks',[-0.02,-0.01,0,0.01,0.02,0.03,0.04,0.05]);
        set(gca,'fontweight', 'bold');
        ax = gca;
        ax.Clipping = 'off';
        
        scatter([poleOnset.hit]-20/15.44,1:length(poleOnset.hit),'bo','filled');
        currIndex = length(poleOnset.hit)+25;
        scatter([poleOnset.miss]-20/15.44,currIndex+1:currIndex+length(poleOnset.miss),'ko','filled');
        currIndex = currIndex + length(poleOnset.miss) + 25;
        scatter([poleOnset.cr]-20/15.44,currIndex+1:currIndex+length(poleOnset.cr),'ro','filled');
        currIndex = currIndex + length(poleOnset.cr) + 25;
        scatter([poleOnset.fa]-20/15.44,currIndex+1:currIndex+length(poleOnset.fa),'go','filled');
        tempX = ones(1,51)*-1.5;
        tempY = [0:50];
        plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
        text(-1.5,25,sprintf(' 50 trials '), 'HorizontalAlignment', 'left','FontSize',8);
        
        tempX = [-1.5 -1.3];
        tempY = [0 0];
        plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
        text(-1.25,0,sprintf('200 ms.'), 'VerticalAlignment', 'top','FontSize',8);
        ax = gca;
        ax.OuterPosition = [0.1 0.1 0.9 0.9];
        axmap = gca;
        box off;
        saveas(figNum,strcat(saveTo,['Heat Map AH', summary(i).name(1:13)]),'png');
        saveas(figNum,strcat(saveTo,['Heat Map AH', summary(i).name(1:13)]),'eps');
        figNum = figNum + 1;
        
        
        
        %% Traces     
        saveTo = strcat(currFolder,['\Traces Long\AH',summary(i).name(1:4),'\']);
        ftrace = figure(figNum);
        set(ftrace,'Position',[300 232 800 600])
        
        for k = 1:size(hitTrials,1)
            hitTrials(k,:) = hitTrials(k,:)/nanmean(hitTrials(k,1:16)) - 1; %first 16 frames normalization
        end
        for k = 1:size(missTrials,1)
            missTrials(k,:) = missTrials(k,:)/nanmean(missTrials(k,1:16)) - 1; %first 16 frames normalization
        end
        for k = 1:size(faTrials,1)
            faTrials(k,:) = faTrials(k,:)/nanmean(faTrials(k,1:16)) - 1; %first 16 frames normalization
        end
        for k = 1:size(crTrials,1)
            crTrials(k,:) = crTrials(k,:)/nanmean(crTrials(k,1:16)) - 1; %first 16 frames normalization
        end
        
        
        allMeans.hit = mean(hitTrials,'omitnan');
        allSEM.hit = std(hitTrials,'omitnan')./sqrt(size(hitTrials,1));
        allMeans.miss = mean(missTrials,'omitnan');
        allSEM.miss = std(missTrials,'omitnan')./sqrt(size(missTrials,1));
        allMeans.fa = mean(faTrials,'omitnan');
        allSEM.fa = std(faTrials,'omitnan')./sqrt(size(faTrials,1));
        allMeans.cr = mean(crTrials,'omitnan');
        allSEM.cr = std(crTrials,'omitnan')./sqrt(size(crTrials,1));
        if (size(hitTrials,1) == 1)
            allMeans.hit = hitTrials;
            allSEM.hit = zeros(1,max(summary(i).trialLength));
        end
        if (size(missTrials,1) == 1)
            allMeans.miss = missTrials;
            allSEM.miss = zeros(1,max(summary(i).trialLength));
        end
        if (size(faTrials,1) == 1)
            allMeans.fa = faTrials;
            allSEM.fa = zeros(1,max(summary(i).trialLength));
        end
        if (size(crTrials,1) == 1)
            allMeans.cr = crTrials;
            allSEM.cr = zeros(1,max(summary(i).trialLength));
        end
        
        xVals = 1:minOfMaxTrials;
        xVals = xVals/15.44;
        
        
        legendText = [];
        if ~all(isnan(allMeans.hit))
            legendText = [legendText "Hit"];
            shadedErrorBar(xVals,allMeans.hit(1:minOfMaxTrials),allSEM.hit(1:minOfMaxTrials),'lineprops',{'b','linewidth',2});
            hold on;
        end
        if ~all(isnan(allMeans.miss))
            legendText = [legendText "Miss"];
            shadedErrorBar(xVals,allMeans.miss(1:minOfMaxTrials),allSEM.miss(1:minOfMaxTrials),'lineprops',{'k','linewidth',2});
            hold on;
        end
        if ~all(isnan(allMeans.cr))
            legendText = [legendText "CR"];
            shadedErrorBar(xVals,allMeans.cr(1:minOfMaxTrials),allSEM.cr(1:minOfMaxTrials),'lineprops',{'r','linewidth',2});
            hold on;
        end
        if ~all(isnan(allMeans.fa))
            legendText = [legendText "FA"];
            shadedErrorBar(xVals,allMeans.fa(1:minOfMaxTrials),allSEM.fa(1:minOfMaxTrials),'lineprops',{'g','linewidth',2});
            hold on;
        end
        
        set(gca,'XLim',[0 minOfMaxTrials/15.44],'fontweight', 'bold');
        xticks([avgPoleOnset-1:1:avgPoleOnset+10]);
        xticklabels({'-1','0','1','2','3','4','5','6','7','8','9','10'});
        axis manual
        ax = gca;
        ax.Clipping = 'off';
        ax.YAxis.Exponent = -3;
        

        myYLims = ylim;
        plot([avgPoleOnset avgPoleOnset], [myYLims(1) myYLims(2)], '-.k', 'linewidth', 2);
        
        xlabel('Time (s)');
        ylabel('\DeltaF/F')
        
        tempX = [-1.5 -1.5];
        tempY = [myYLims(1) myYLims(1)+0.005];
        plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
        text(-1.5,myYLims(1)+0.0025,'0.5% ', 'HorizontalAlignment', 'right','FontSize',8);
        
        tempX = [-1.5 -1.3];
        tempY = [myYLims(1) myYLims(1)];
        plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
        text(-1.5,myYLims(1),sprintf('200 ms.'), 'VerticalAlignment', 'top','FontSize',8);
        
        
        legend(legendText,'Location','northeastoutside')
        ax.OuterPosition = [0.1 0.1 0.9 0.9];
        
        axtrace = gca;
        
        saveas(figNum,strcat(saveTo,['Trace AH', summary(i).name(1:13)]),'png');
        saveas(figNum,strcat(saveTo,['Trace AH', summary(i).name(1:13)]),'eps');
        figNum = figNum + 1;
        
        clear poleOnset hitTrials missTrials faTrials crTrials allMeans allSEM
        
        %% Subplots
        saveTo = strcat(currFolder,['\Heat Maps and Traces Long\AH',summary(i).name(1:4),'\']);
        fsub = figure(figNum);
        set(fsub,'Position',[300 232 970 590])
        
        a1 = subplot(2,1,1);    
        a1.OuterPosition = [0.13 0.5838 0.8 0.4];
        set(gca,'xtick', [], 'xticklabel',[]);
        set(gca,'ytick',[],'yticklabel',[]);
        set(gca,'Visible','off');
        axcp = copyobj(axmap,fsub);
        set(axcp,'Position',get(a1,'position'));
        colormap('gray');
        colorbar(axcp,'Location', 'manual','Position', [0.9 0.6179, 0.025 0.3359]);
        
        a2 = subplot(2,1,2);        
        a2.OuterPosition = [0.13 0.11 0.8 0.4];
        set(gca,'xtick', [], 'xticklabel',[]);
        set(gca,'ytick',[],'yticklabel',[]);
        axcp = copyobj(axtrace,fsub);
        set(axcp,'Position',get(a2,'position'));
        legend(axcp,legendText,'Location', 'none','Position', [0.87 0.34, 0.12 0.15]);
        saveas(figNum,strcat(saveTo,['Map and Trace AH', summary(i).name(1:13)]),'png');
        saveas(figNum,strcat(saveTo,['Map and Trace AH', summary(i).name(1:13)]),'eps');
        figNum = figNum + 1;
    end
    close all
end