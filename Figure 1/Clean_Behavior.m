%script to get cutoff index, get rid of the non-performing trials at end of
%the session

for j = 1:length(summary)
    counter = 0;
    lengthMatrix = length(summary(j).trialMatrix);
    for i = lengthMatrix:-1:1
        if (summary(j).trialMatrix(i,2) == 1) || (summary(j).trialMatrix(i,4) == 1)
            counter = counter+1;
        else
            break;
        end
    end
    if (counter > 10)
        %summary(j).trialMatrix = summary(j).trialMatrix(1:end-(counter-10),:);
        summary(j).cutoffIndex = lengthMatrix-(counter-10);
%         correct = 0;
%         for k = 1:length(summary(j).trialMatrix)
%             if (summary(j).trialMatrix(k,1) == 1) || (summary(j).trialMatrix(k,4) == 4)
%                 correct = correct+1;
%             end
%         end
%         summary(j).correctRate = correct/length(summary(j).trialMatrix);
    
    else
        summary(j).cutoffIndex = lengthMatrix;
    end
        
end