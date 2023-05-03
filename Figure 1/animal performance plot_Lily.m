%plot animal performance
hitrate = cell(8,1);
farate = cell(8,1);
correct_rate = cell(8,1);
for mouse = 1:8
    for k = 1:length(M(mouse).summary)
        if (M(mouse).summary(k).hasScopolamine == 0 && M(mouse).summary(k).polePresent == 1 && M(mouse).summary(k).hasWhisker == 1)
            hitTrials = find(M(mouse).summary(k).trialMatrix(:,1));
            hitTrials = hitTrials(find(hitTrials<= M(mouse).summary(k).cutoffIndex));
            missTrials = find(M(mouse).summary(k).trialMatrix(:,2));
            missTrials = missTrials(find(missTrials<= M(mouse).summary(k).cutoffIndex));            
            goTrialsnum = length(hitTrials)+length(missTrials);
            
            faTrials = find(M(mouse).summary(k).trialMatrix(:,3));
            faTrials = faTrials(find(faTrials<= M(mouse).summary(k).cutoffIndex));
            crTrials = find(M(mouse).summary(k).trialMatrix(:,4));
            crTrials = crTrials(find(crTrials<= M(mouse).summary(k).cutoffIndex));            
            nogoTrialsnum = length(faTrials)+length(crTrials);
            
            hitrate{mouse}(k)= length(hitTrials)/goTrialsnum;
            farate{mouse}(k)= length(faTrials)/nogoTrialsnum;
            correct_rate{mouse}(k)= (length(hitTrials)+length(crTrials))/M(mouse).summary(k).cutoffIndex;
        else
            hitrate{mouse}(k)= NaN;
            farate{mouse}(k) = NaN;
            correct_rate{mouse}(k) = NaN;
        end
    end

end

hitrate{2} = hitrate{2}(1:11);
farate{2} = farate{2}(1:11);
correct_rate{2} = correct_rate{2}(1:11);
hitrate{3} = hitrate{3}(1:12);
farate{3} = farate{3}(1:12);
correct_rate{3} = correct_rate{3}(1:12);
hitrate{4} = hitrate{4}(1:13);
farate{4} = farate{4}(1:13);
correct_rate{4} = correct_rate{4}(1:13);
hitrate{5} = hitrate{5}(1:25);
farate{5} = farate{5}(1:25);
correct_rate{5} = correct_rate{5}(1:25);
hitrate{6} = hitrate{6}(2:24);
farate{6} = farate{6}(2:24);
correct_rate{6} = correct_rate{6}(2:24);
hitrate{7} = hitrate{7}(2:13);
farate{7} = farate{7}(2:13);
correct_rate{7} = correct_rate{7}(2:13);
hitrate{8} = hitrate{8}(5:19);
farate{8} = farate{8}(5:19);
correct_rate{8} = correct_rate{8}(5:19);

% plot learning curve
figure(1)
for i=1:length(correct_rate)
   plot([correct_rate{i}],'k')
   hold on
end



f1 = cellfun(@length,hitrate,'uniformoutput',0);
f2 = cellfun(@length,farate,'uniformoutput',0);

f3= NaN(length(hitrate),max(cell2mat(f1)));
f4= NaN(length(farate),max(cell2mat(f2)));

for i=1:length(correct_rate)
    f3(i,1:length(hitrate{i}))=hitrate{i};
    f4(i,1:length(farate{i}))=farate{i};
end
figure(2);
for i=1:length(correct_rate)
   plot([hitrate{i}],'color',[0.6,0.6,0.9])
   hold on
   plot([farate{i}],'color',[0.6,0.9,0.6])
   hold on
end
hold on 
plot(nanmean(f3),'b','linewidth',3)
plot(nanmean(f4),'g','linewidth',3)
xlabel('Sessions of training','FontSize',20)
print(gcf,'-dpng','-r300',['HitRateFalseAlarmRateacrosslearning'])
print(gcf,'-depsc2',['HitRateFalseAlarmRateacrosslearning'])

