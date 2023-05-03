Naive = [];
Expert = [];
noWhisker = [];
Scopolamine = [];
toCont = true;
noWhiskerCount = 1;
naiveCount = 1;
expertCount=1;
scopCount = 1;


while (toCont)
    thisNaive = [];
    thisExpert = [];
    thisnoWhisker = [];
    thisScop = [];
    thisnoWhiskerCount = 1;
    thisnaiveCount = 1;
    thisexpertCount = 1;
    thisscopCount = 1;
    expertNum = isExpert(summary);
    for (i = 1:length(summary))
        if (summary(i).hasScopolamine == 0 && summary(i).polePresent == 1)
            if (summary(i).hasWhisker == 0)
                thisnoWhisker(thisnoWhiskerCount) = summary(i).CorrectRate;
                thisnoWhiskerCount = thisnoWhiskerCount+1;
            elseif (expertNum ~= 0)
                if (i < expertNum)
                    thisNaive(thisnaiveCount) = summary(i).CorrectRate;
                    thisnaiveCount = thisnaiveCount + 1;
                else
                    thisExpert(thisexpertCount) = summary(i).CorrectRate;
                    thisexpertCount = thisexpertCount + 1;
                end
            else
                thisNaive(thisnaiveCount) = summary(i).CorrectRate;
                thisnaiveCount = thisnaiveCount+1;
            end
        elseif (summary(i).hasScopolamine == 1 && summary(i).polePresent == 1)
            thisScop(thisscopCount) = summary(i).CorrectRate;
            thisscopCount = thisscopCount+1;
        end
    end
    
    if (~isempty(thisNaive))
        Naive(naiveCount) = thisNaive(3);
        naiveCount = naiveCount+1;
    end
    if (~isempty(thisExpert))
        Expert(expertCount) = thisExpert(length(thisExpert)-2);
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
    
    disp('load next struct, then dbcont to continue, or if finished, "toCont = false" and dbcont to continue');
    keyboard;
end
figure(1);
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
        hold on;
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


function expertNum = isExpert(summary)
    expertNum = 0;
    for i = 1:length(summary)
        if summary(i).CorrectRate > 0.7
            if (i+2 <= length(summary))
                if (summary(i+1).CorrectRate > 0.7 && summary(i+2).CorrectRate > 0.7)
                    expertNum = i;
                    break;
                end
            end
        end
    end
end