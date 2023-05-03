whisk_theta_early= cell(8,1);
whisk_amplitude_early= cell(8,1);
whisk_theta_late= cell(8,1);
whisk_amplitude_late= cell(8,1);

for mouse = 1:length(M)
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    earlySessions=useSessions(1:3);
    lateSessions=useSessions(end-2:end);
        for i=earlySessions
            earlyTrialMatrix=cat(1,M(mouse).summary(earlySessions).trialMatrix);
            earlywhiskamp=cat(1,M(mouse).summary(earlySessions).amplitude);
            earlywhisktheta=cat(1,M(mouse).summary(earlySessions).theta);
            whisktheta_early=earlywhisktheta(find(~cellfun(@isempty,earlywhisktheta))); 
            whiskamp_early=earlywhiskamp(find(~cellfun(@isempty,earlywhiskamp)));       
        end
%       includeTrials=find(M(mouse).summary(i).trialStart>1544);
        whiskLength_early=cell2mat(cellfun(@length,earlywhiskamp,'uniformoutput',0));
        minwhiskLength_early=min([whiskLength_early(whiskLength_early>0)]);
        maxwhiskLength_early=max([whiskLength_early]);
      
        whisktheta2_early=NaN(length(whisktheta_early),maxwhiskLength_early);
        for k=1:length(whisktheta_early)
            whisktheta2_early(k,1:length(whisktheta_early{k,1}))=whisktheta_early{k,1};
        end
   
        whiskamp2_early=NaN(length(whiskamp_early),maxwhiskLength_early);
        for k=1:length(whiskamp_early)
            whiskamp2_early(k,1:length(whiskamp_early{k,1}))=whiskamp_early{k,1};
        end
        whisk_theta_early{mouse}=nanmean(whisktheta2_early);
        whisk_amplitude_early{mouse}=nanmean(whiskamp2_early);
   
    
        for i=lateSessions    
        lateTrialMatrix=cat(1,M(mouse).summary(lateSessions ).trialMatrix);
        latewhiskamp=cat(1,M(mouse).summary(lateSessions ).amplitude);
        latewhisktheta=cat(1,M(mouse).summary(lateSessions ).theta);
        whisktheta_late=latewhisktheta(find(~cellfun(@isempty,latewhisktheta))); 
        whiskamp_late=latewhiskamp(find(~cellfun(@isempty,latewhiskamp)));       
        end
%         includeTrials=find(M(mouse).summary(i).trialStart>1544);
        whiskLength_late=cell2mat(cellfun(@length,latewhiskamp,'uniformoutput',0));
        minwhiskLength_late=min([whiskLength_late(whiskLength_late>0)]);
        maxwhiskLength_late=max([whiskLength_late]);
%     find(~cellfun(@isempty,M(mouse).summary(i).theta))       
   
        whisktheta2_late=NaN(length(whisktheta_late),maxwhiskLength_late);
        for k=1:length(whisktheta_late)
            whisktheta2_late(k,1:length(whisktheta_late{k,1}))=whisktheta_late{k,1};
        end

        whiskamp2_late=NaN(length(whiskamp_late),maxwhiskLength_late);
        for k=1:length(whiskamp_late)
            whiskamp2_late(k,1:length(whiskamp_late{k,1}))=whiskamp_late{k,1};
        end

        whisk_theta_late{mouse}=nanmean(whisktheta2_late);
        whisk_amplitude_late{mouse}=nanmean(whiskamp2_late);
   
    
    
end
 
%% plot figures
minLength_late=min([cell2mat(cellfun(@length,whisk_amplitude_late,'uniformoutput',0))]);
whisk_amp_grandmean_late=NaN(8,minLength_late);
for i=1:length(whisk_amplitude_late)
    whisk_amp_grandmean_late(i,:)=whisk_amplitude_late{i}(1:minLength_late);
end

minLength_early=min([cell2mat(cellfun(@length,whisk_amplitude_early,'uniformoutput',0))]);
whisk_amp_grandmean_early=NaN(8,minLength_early);
for i=1:length(whisk_amplitude_early)
    whisk_amp_grandmean_early(i,:)=whisk_amplitude_early{i}(1:minLength_early);
end

figure(1)
clf
hold on
shadedErrorBar([],nanmean(whisk_amp_grandmean_early),std(whisk_amp_grandmean_early)/sqrt(size(whisk_amp_grandmean_early,1)),'lineprops',{'color','[0.5 0.5 0.5]','linewidth',4})
shadedErrorBar([],nanmean(whisk_amp_grandmean_late),std(whisk_amp_grandmean_late)/sqrt(size(whisk_amp_grandmean_late,1)),'lineprops',{'color','k','linewidth',4})

plot(1.09*311+[0 1*311], [10 10],'-m','linewidth',2)
plot(1.09*311+[1*311 2*311], [10 10],'-c','linewidth',2)
plot([1.09*311 1.09*311], [0 10],':m','linewidth',1)
plot([2.09*311 2.09*311], [0 10],':c','linewidth',1)

set(gca,'xlim', [0 10]*311)
set(gca,'xtick', [0:10]*311, 'xticklabel',[0:10],'FontSize',20,'fontweight','bold')
xlabel('Time (s)','FontSize',20,'FontWeight','bold')
ylabel('Average Amplitude','FontSize',20,'FontWeight','bold')
legend({'early sessions','late sessions'}, 'FontSize', 12);
print(gcf,'-depsc2',['whiskamp_GrandMean_comparison']);
print(gcf,'-dpng','-r300',['whiskamp_GrandMean_comparison']);












