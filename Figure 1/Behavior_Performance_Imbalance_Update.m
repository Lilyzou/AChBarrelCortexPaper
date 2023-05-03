Naive = [];
Expert = [];
noWhisker = [];
Scopolamine = [];
toCont = true;
noWhiskerCount = 1;
naiveCount = 1;
expertCount=1;
scopCount = 1;

mkdir('Behavior Performance');
currFolder = pwd;
saveTo = strcat(currFolder,'\Behavior Performance\');

figNum = 1;

d = dir('*Struct.mat');

for m = 1:length(d)
    
    load(d(m).name);
    
    Clean_Behavior;
    upCR = updateCR(summary);
    for i = 1:length(upCR)
        summary(i).updatedCR = upCR(i);
    end
    
    thisNaive = [];
    thisExpert = [];
    thisnoWhisker = [];
    thisScop = [];
    thisnoWhiskerCount = 1;
    thisnaiveCount = 1;
    thisexpertCount = 1;
    thisscopCount = 1;
    expertNum = isExpert(summary);
    imbalancedNaive = [];
    imbalancedNaiveCount = 1;
    for (i = 1:length(summary))
        
        wasImbalanced = false;
        if (summary(i).hasScopolamine == 0 && summary(i).polePresent == 1)
            goTrials = find(summary(i).trialMatrix(:,1:2));
            nogoTrials = find(summary(i).trialMatrix(:,3:4));
            if (length(nogoTrials)/length(summary(i).trialMatrix) < 0.4)
                wasImbalanced = true;
                disp([num2str(m), ' ', num2str(i), ' ', num2str(summary(i).updatedCR)]);
            end
            if (summary(i).hasWhisker == 0)
                thisnoWhisker(thisnoWhiskerCount) = summary(i).updatedCR;
                thisnoWhiskerCount = thisnoWhiskerCount+1;
            elseif (expertNum ~= 0)
                if (i < expertNum)
                    if wasImbalanced
                        imbalancedNaive(imbalancedNaiveCount) = summary(i).updatedCR;
                        imbalancedNaiveCount = imbalancedNaiveCount + 1;
                        
                    else
                        thisNaive(thisnaiveCount) = summary(i).updatedCR;
                        thisnaiveCount = thisnaiveCount + 1;
                    end
                else
                    thisExpert(thisexpertCount) = summary(i).updatedCR;
                    thisexpertCount = thisexpertCount + 1;
                end
            else
                thisNaive(thisnaiveCount) = summary(i).updatedCR;
                thisnaiveCount = thisnaiveCount+1;
            end
        elseif (summary(i).hasScopolamine == 1 && summary(i).polePresent == 1)
            thisScop(thisscopCount) = summary(i).updatedCR;
            thisscopCount = thisscopCount+1;
        end
    end
    
    if (~isempty(thisNaive))
        Naive(naiveCount) = thisNaive(1);
        naiveCount = naiveCount+1;
    end
    if (~isempty(thisExpert))
        Expert(expertCount) = max(thisExpert);
        expertCount = expertCount+1;
    end
    if (~isempty(thisnoWhisker))
        noWhisker(noWhiskerCount) = thisnoWhisker(1);
        noWhiskerCount = noWhiskerCount+1;
    end
    
    if (~isempty(thisScop))
        Scopolamine(scopCount) = thisScop(1);
        scopCount = scopCount+1;
    end
    
    figure(figNum);
    if (~isempty(imbalancedNaive))
        imbalancedNaive = imbalancedNaive * 100;
        x = ones(1,length(imbalancedNaive));
        scatter(x, imbalancedNaive,'bo','filled');
        hold on;
    end
    if (~isempty(thisNaive))
        thisNaive = thisNaive * 100;
        x = ones(1,length(thisNaive));
        scatter(x, thisNaive,'ko','filled');
        hold on;
    end
    if (~isempty(thisExpert))
        thisExpert = thisExpert * 100;
        x = 2 * ones(1,length(thisExpert)-1);
        scatter(x, thisExpert(2:end),'ko','filled');
        hold on;
        scatter(2,thisExpert(1),'ro','filled');
    end
    if (~isempty(thisnoWhisker))
        thisnoWhisker = thisnoWhisker * 100;
        x = 3 * ones(1,length(thisnoWhisker));
        scatter(x, thisnoWhisker,'ko','filled');
        hold on;
    end
    if (~isempty(thisScop))
        thisScop = thisScop * 100;
        x = 4 * ones(1,length(thisScop));
        scatter(x, thisScop,'ko','filled');
        hold on;
    end
    ax = gca;
    ax.XTick = [1, 2, 3, 4];
    ax.XTickLabels = {'Naive','Expert', 'No Whisker', 'Scopolamine'};
    xlim([0,5]);
    ylim([0,100]);
    ax.YTick = [0:10:100];
    ylabel('% correct');
    xtickangle(30);
    set(gca,'FontSize',15,'fontweight','bold');
    saveas(figNum,strcat(saveTo,['Behavior Performance ', d(m).name(1:6)]),'png');
    saveas(figNum,strcat(saveTo,['Behavior Performance ', d(m).name(1:6)]),'eps');
    figNum = figNum+1;
    
end
figure(figNum);
if (~isempty(Naive))
    Naive = Naive * 100;
    x = ones(1,length(Naive));
    scatter(x, Naive,'ko','filled');
    hold on;
end
if (~isempty(Expert))
    Expert = Expert * 100;
    x = 2 * ones(1,length(Expert));
    scatter(x, Expert,'ko','filled');
end
if (~isempty(noWhisker))
    noWhisker = noWhisker * 100;
    x = 3 * ones(1,length(noWhisker));
    scatter(x, noWhisker,'ko','filled');
    hold on;
end
if (~isempty(Scopolamine))
    Scopolamine = Scopolamine * 100;
    x = 4 * ones(1,length(Scopolamine));
    scatter(x, Scopolamine,'ko','filled');
    hold on;
end
ax = gca;
ax.XTick = [1, 2, 3, 4];
ax.XTickLabels = {'Naive','Expert', 'No Whisker','Scopolamine'};
xlim([0,5]);
ylim([0,100]);
ax.YTick = [0:10:100];
ylabel('% correct');
xtickangle(30);
set(gca,'FontSize',15,'fontweight','bold');
saveas(figNum,strcat(saveTo,'All Animals Behavior Performance'),'png');
saveas(figNum,strcat(saveTo,'All Animals Behavior Performance'),'eps');


function expertNum = isExpert(summary)
    expertNum = 0;
    for i = 1:length(summary)
        if summary(i).updatedCR > 0.7
            if (i+2 <= length(summary))
                if (summary(i+1).updatedCR > 0.7 && summary(i+2).updatedCR > 0.7)
                    expertNum = i;
                    break;
                end
            end
        end
    end
end

function updatedCR = updateCR(summary)
    for i = 1:length(summary)
        if summary(i).cutoffIndex == length(summary(i).trialMatrix) || (summary(i).hasScopolamine == 1 && length(summary(i).trialMatrix) < 250)
            summary(i).crUpdate = summary(i).CorrectRate;
        else
            correct = 0;
            for k = 1:summary(i).cutoffIndex
                if (summary(i).trialMatrix(k,1) == 1) || (summary(i).trialMatrix(k,4) == 1)
                    correct = correct+1;
                end
            end
            summary(i).crUpdate= correct/summary(i).cutoffIndex;
        end
    end
    updatedCR = [summary.crUpdate];
    
end