%% SFig1 whisking pattern sorted by trial types
 whisk_hitamp_early=cell(1,8);
 whisk_missamp_early=cell(1,8);
 whisk_FAamp_early=cell(1,8);
 whisk_CRamp_early=cell(1,8);
 whisk_hitamp_late=cell(1,8);
 whisk_missamp_late=cell(1,8);
 whisk_FAamp_late=cell(1,8);
 whisk_CRamp_late=cell(1,8);

%  figure(1);clf
%  figure(2);clf
 
for mouse =1:length(M)
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    earlySessions=useSessions(1:3);
    lateSessions=useSessions(end-2:end);
    
    for i=earlySessions
        earlyTrialMatrix=cat(1,M(mouse).summary(earlySessions).trialMatrix);
        earlywhiskamp=cat(1,M(mouse).summary(earlySessions).amplitude);
               
        hitwhiskamp_early=earlywhiskamp(find(earlyTrialMatrix(:,1)));
        hitwhiskamp_earlytrim=hitwhiskamp_early(find(~cellfun(@isempty,hitwhiskamp_early)));
        
        misswhiskamp_early=earlywhiskamp(find(earlyTrialMatrix(:,2)));
        misswhiskamp_earlytrim=misswhiskamp_early(find(~cellfun(@isempty,misswhiskamp_early)));
        
        FAwhiskamp_early=earlywhiskamp(find(earlyTrialMatrix(:,3)));
        FAwhiskamp_earlytrim=FAwhiskamp_early(find(~cellfun(@isempty,FAwhiskamp_early)));
        
        CRwhiskamp_early=earlywhiskamp(find(earlyTrialMatrix(:,4)));
        CRwhiskamp_earlytrim=CRwhiskamp_early(find(~cellfun(@isempty,CRwhiskamp_early)));  
    end
    
        whiskLength_early=cell2mat(cellfun(@length,earlywhiskamp,'uniformoutput',0));
        minwhiskLength_early=min([whiskLength_early(whiskLength_early>0)]);
        maxwhiskLength_early=max([whiskLength_early]);    
    
        hitwhiskamp_early2=NaN(length(hitwhiskamp_earlytrim),maxwhiskLength_early);
        misswhiskamp_early2=NaN(length(misswhiskamp_earlytrim),maxwhiskLength_early);
        FAwhiskamp_early2=NaN(length(FAwhiskamp_earlytrim),maxwhiskLength_early);
        CRwhiskamp_early2=NaN(length(CRwhiskamp_earlytrim),maxwhiskLength_early);
        
        for k=1:length(hitwhiskamp_earlytrim)
            hitwhiskamp_early2(k,1:length(hitwhiskamp_earlytrim{k,1}))=hitwhiskamp_earlytrim{k,1};
        end
        whisk_hitamp_early{mouse}=nanmean(hitwhiskamp_early2);
        
        for k=1:length(misswhiskamp_earlytrim)
            misswhiskamp_early2(k,1:length(misswhiskamp_earlytrim{k,1}))=misswhiskamp_earlytrim{k,1};
        end
        whisk_missamp_early{mouse}=nanmean(misswhiskamp_early2);
        
        for k=1:length(FAwhiskamp_earlytrim)
            FAwhiskamp_early2(k,1:length(FAwhiskamp_earlytrim{k,1}))=FAwhiskamp_earlytrim{k,1};
        end
        whisk_FAamp_early{mouse}=nanmean(FAwhiskamp_early2);
        
        for k=1:length(CRwhiskamp_earlytrim)
            CRwhiskamp_early2(k,1:length(CRwhiskamp_earlytrim{k,1}))=CRwhiskamp_earlytrim{k,1};
        end
        whisk_CRamp_early{mouse}=nanmean(CRwhiskamp_early2); 
    
    
    for i=lateSessions
        lateTrialMatrix=cat(1,M(mouse).summary(lateSessions).trialMatrix);
        latewhiskamp=cat(1,M(mouse).summary(lateSessions).amplitude);
               
        hitwhiskamp_late=latewhiskamp(find(lateTrialMatrix(:,1)));
        hitwhiskamp_latetrim=hitwhiskamp_late(find(~cellfun(@isempty,hitwhiskamp_late)));
        
        misswhiskamp_late=latewhiskamp(find(lateTrialMatrix(:,2)));
        misswhiskamp_latetrim=misswhiskamp_late(find(~cellfun(@isempty,misswhiskamp_late)));
        
        FAwhiskamp_late=latewhiskamp(find(lateTrialMatrix(:,3)));
        FAwhiskamp_latetrim=FAwhiskamp_late(find(~cellfun(@isempty,FAwhiskamp_late)));
        
        CRwhiskamp_late=latewhiskamp(find(lateTrialMatrix(:,4)));
        CRwhiskamp_latetrim=CRwhiskamp_late(find(~cellfun(@isempty,CRwhiskamp_late)));
    end
 
        whiskLength_late=cell2mat(cellfun(@length,latewhiskamp,'uniformoutput',0));
        minwhiskLength_late=min([whiskLength_late(whiskLength_late>0)]);
        maxwhiskLength_late=max([whiskLength_late]);    
    
        hitwhiskamp_late2=NaN(length(hitwhiskamp_latetrim),maxwhiskLength_late);
        misswhiskamp_late2=NaN(length(misswhiskamp_latetrim),maxwhiskLength_late);
        FAwhiskamp_late2=NaN(length(FAwhiskamp_latetrim),maxwhiskLength_late);
        CRwhiskamp_late2=NaN(length(CRwhiskamp_latetrim),maxwhiskLength_late);
        
        for k=1:length(hitwhiskamp_latetrim)
            hitwhiskamp_late2(k,1:length(hitwhiskamp_latetrim{k,1}))=hitwhiskamp_latetrim{k,1};
        end
        whisk_hitamp_late{mouse}=nanmean(hitwhiskamp_late2);
        
        for k=1:length(misswhiskamp_latetrim)
            misswhiskamp_late2(k,1:length(misswhiskamp_latetrim{k,1}))=misswhiskamp_latetrim{k,1};
        end
        whisk_missamp_late{mouse}=nanmean(misswhiskamp_late2);
        
        for k=1:length(FAwhiskamp_latetrim)
            FAwhiskamp_late2(k,1:length(FAwhiskamp_latetrim{k,1}))=FAwhiskamp_latetrim{k,1};
        end
        whisk_FAamp_late{mouse}=nanmean(FAwhiskamp_late2);
        
        for k=1:length(CRwhiskamp_latetrim)
            CRwhiskamp_late2(k,1:length(CRwhiskamp_latetrim{k,1}))=CRwhiskamp_latetrim{k,1};
        end
        whisk_CRamp_late{mouse}=nanmean(CRwhiskamp_late2);     
 
%         figure(1)
%         subplot(4,2,mouse)
%  imagesc([hitwhiskamp_early2; FAwhiskamp_early2; CRwhiskamp_early2; misswhiskamp_early2])
% 
%         figure(2)
%         
%         subplot(4,2,mouse)
%  imagesc([hitwhiskamp_late2; FAwhiskamp_late2; CRwhiskamp_late2; misswhiskamp_late2])

        
end



%% plot the figures
hitminLength_late=min([cell2mat(cellfun(@length,whisk_hitamp_late,'uniformoutput',0))]);
whisk_hitamp_grandmean_late=NaN(8,hitminLength_late);
for i=1:length(whisk_hitamp_late)
    whisk_hitamp_grandmean_late(i,:)=whisk_hitamp_late{i}(1:hitminLength_late);
end

hitminLength_early=min([cell2mat(cellfun(@length,whisk_hitamp_early,'uniformoutput',0))]);
whisk_hitamp_grandmean_early=NaN(8,hitminLength_early);
for i=1:length(whisk_hitamp_early)
    whisk_hitamp_grandmean_early(i,:)=whisk_hitamp_early{i}(1:hitminLength_early);
end

missminLength_late=min([cell2mat(cellfun(@length,whisk_missamp_late,'uniformoutput',0))]);
whisk_missamp_grandmean_late=NaN(8,missminLength_late);
for i=1:length(whisk_missamp_late)
    whisk_missamp_grandmean_late(i,:)=whisk_missamp_late{i}(1:missminLength_late);
end

missminLength_early=min([cell2mat(cellfun(@length,whisk_missamp_early,'uniformoutput',0))]);
whisk_missamp_grandmean_early=NaN(8,missminLength_early);
for i=1:length(whisk_missamp_early)
    whisk_missamp_grandmean_early(i,:)=whisk_missamp_early{i}(1:missminLength_early);
end

CRminLength_late=min([cell2mat(cellfun(@length,whisk_CRamp_late,'uniformoutput',0))]);
whisk_CRamp_grandmean_late=NaN(8,CRminLength_late);
for i=1:length(whisk_CRamp_late)
    whisk_CRamp_grandmean_late(i,:)=whisk_CRamp_late{i}(1:CRminLength_late);
end

CRminLength_early=min([cell2mat(cellfun(@length,whisk_CRamp_early,'uniformoutput',0))]);
whisk_CRamp_grandmean_early=NaN(8,CRminLength_early);
for i=1:length(whisk_CRamp_early)
    whisk_CRamp_grandmean_early(i,:)=whisk_CRamp_early{i}(1:CRminLength_early);
end

FAminLength_late=min([cell2mat(cellfun(@length,whisk_FAamp_late,'uniformoutput',0))]);
whisk_FAamp_grandmean_late=NaN(8,FAminLength_late);
for i=1:length(whisk_FAamp_late)
    whisk_FAamp_grandmean_late(i,:)=whisk_FAamp_late{i}(1:FAminLength_late);
end

FAminLength_early=min([cell2mat(cellfun(@length,whisk_FAamp_early,'uniformoutput',0))]);
whisk_FAamp_grandmean_early=NaN(8,FAminLength_early);
for i=1:length(whisk_FAamp_early)
    whisk_FAamp_grandmean_early(i,:)=whisk_FAamp_early{i}(1:FAminLength_early);
end

figure(1);clf

subplot(2,1,1)
shadedErrorBar([],nanmean(whisk_hitamp_grandmean_early),std(whisk_hitamp_grandmean_early)/sqrt(size(whisk_hitamp_grandmean_early,1)),'lineprops',{'color','b','linewidth',2})
shadedErrorBar([],nanmean(whisk_missamp_grandmean_early),std(whisk_missamp_grandmean_early)/sqrt(size(whisk_missamp_grandmean_early,1)),'lineprops',{'color','k','linewidth',2})
shadedErrorBar([],nanmean(whisk_CRamp_grandmean_early),std(whisk_CRamp_grandmean_early)/sqrt(size(whisk_CRamp_grandmean_early,1)),'lineprops',{'color','r','linewidth',2})
shadedErrorBar([],nanmean(whisk_FAamp_grandmean_early),std(whisk_FAamp_grandmean_early)/sqrt(size(whisk_FAamp_grandmean_early,1)),'lineprops',{'color','g','linewidth',2})
hold on
plot(1.09*311+[0 1*311], [13 13],'-m','linewidth',2)
plot(1.09*311+[1*311 2*311], [13 13],'-c','linewidth',2)
plot([1.09*311 1.09*311], [0 13],':m','linewidth',1)
plot([2.09*311 2.09*311], [0 13],':c','linewidth',1)

set(gca,'xlim', [0 6]*311,'ylim',[0 13])
set(gca,'xtick', [1:6]*311, 'xticklabel',[1:6],'FontSize',20,'fontweight','bold')
% xlabel('Time (s)','FontSize',20,'FontWeight','bold')
ylabel('Average Amplitude','FontSize',20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);

subplot(2,1,2)
shadedErrorBar([],nanmean(whisk_hitamp_grandmean_late),std(whisk_hitamp_grandmean_late)/sqrt(size(whisk_hitamp_grandmean_late,1)),'lineprops',{'color','b','linewidth',2})
shadedErrorBar([],nanmean(whisk_missamp_grandmean_late),std(whisk_missamp_grandmean_late)/sqrt(size(whisk_missamp_grandmean_late,1)),'lineprops',{'color','k','linewidth',2})
shadedErrorBar([],nanmean(whisk_CRamp_grandmean_late),std(whisk_CRamp_grandmean_late)/sqrt(size(whisk_CRamp_grandmean_late,1)),'lineprops',{'color','r','linewidth',2})
shadedErrorBar([],nanmean(whisk_FAamp_grandmean_late),std(whisk_FAamp_grandmean_late)/sqrt(size(whisk_FAamp_grandmean_late,1)),'lineprops',{'color','g','linewidth',2})
hold on
plot(1.09*311+[0 1*311], [13 13],'-m','linewidth',2)
plot(1.09*311+[1*311 2*311], [13 13],'-c','linewidth',2)
plot([1.09*311 1.09*311], [0 13],':m','linewidth',1)
plot([2.09*311 2.09*311], [0 13],':c','linewidth',1)
set(gca,'xlim', [0 6]*311,'ylim',[0 13])
set(gca,'xtick', [1:6]*311, 'xticklabel',[1:6],'FontSize',20,'fontweight','bold')
xlabel('Time (s)','FontSize',20,'FontWeight','bold')
ylabel('Average Amplitude','FontSize',20,'FontWeight','bold')
legend({'Hit','Miss','CR','FA'}, 'FontSize', 12);
print(gcf,'-depsc2',['whiskamp_bytrialtypes_GrandMean']);
print(gcf,'-dpng','-r300',['whiskamp_bytrialtypes_GrandMean']);


%plot Hit and miss on one plot, FA and CR on another plot using late
%sessions
figure(2);clf
subplot(2,1,1)
shadedErrorBar([],nanmean(whisk_hitamp_grandmean_late),std(whisk_hitamp_grandmean_late)/sqrt(size(whisk_hitamp_grandmean_late,1)),'lineprops',{'color','b','linewidth',2})
shadedErrorBar([],nanmean(whisk_missamp_grandmean_late),std(whisk_missamp_grandmean_late)/sqrt(size(whisk_missamp_grandmean_late,1)),'lineprops',{'color','k','linewidth',2})
hold on
plot(1.09*311+[0 1*311], [13 13],'-m','linewidth',2)
plot(1.09*311+[1*311 2*311], [13 13],'-c','linewidth',2)
plot([1.09*311 1.09*311], [0 13],':m','linewidth',1)
plot([2.09*311 2.09*311], [0 13],':c','linewidth',1)
set(gca,'xlim', [0 6]*311,'ylim',[0 13])
set(gca,'xtick', [1:6]*311, 'xticklabel',[1:6],'FontSize',20,'fontweight','bold')
xlabel('Time (s)','FontSize',20,'FontWeight','bold')
ylabel('Average Amplitude','FontSize',20,'FontWeight','bold')
legend({'Hit','Miss'}, 'FontSize', 12);

subplot(2,1,2)
shadedErrorBar([],nanmean(whisk_CRamp_grandmean_late),std(whisk_CRamp_grandmean_late)/sqrt(size(whisk_CRamp_grandmean_late,1)),'lineprops',{'color','r','linewidth',2})
shadedErrorBar([],nanmean(whisk_FAamp_grandmean_late),std(whisk_FAamp_grandmean_late)/sqrt(size(whisk_FAamp_grandmean_late,1)),'lineprops',{'color','g','linewidth',2})
hold on
plot(1.09*311+[0 1*311], [13 13],'-m','linewidth',2)
plot(1.09*311+[1*311 2*311], [13 13],'-c','linewidth',2)
plot([1.09*311 1.09*311], [0 13],':m','linewidth',1)
plot([2.09*311 2.09*311], [0 13],':c','linewidth',1)
set(gca,'xlim', [0 6]*311,'ylim',[0 13])
set(gca,'xtick', [1:6]*311, 'xticklabel',[1:6],'FontSize',20,'fontweight','bold')
xlabel('Time (s)','FontSize',20,'FontWeight','bold')
ylabel('Average Amplitude','FontSize',20,'FontWeight','bold')
legend({'CR','FA'}, 'FontSize', 12);
print(gcf,'-depsc2',['whiskamp_bytrialtypes_ExpertSessions']);
print(gcf,'-dpng','-r300',['whiskamp_bytrialtypes_ExpertSessions']);


