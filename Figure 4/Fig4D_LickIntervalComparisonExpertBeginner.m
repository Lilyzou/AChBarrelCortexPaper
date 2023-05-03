%Figure 4D inter lick interval comparison
%% Gather the first licks in dataset
firstLicks = cell(8,1);
firstLicksEarly = cell(8,1);
firstLicksLate = cell(8,1);
allLicks = cell(8,1);
allLicksEarly = cell(8,1);
allLicksLate = cell(8,1);
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
        allLicksLate{mouse} = vertcat(allLicksLate{mouse},M(mouse).summary(i).cleanLicks);
    end
    
    
    for i = useSessions(1:3)
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        fl(cellfun(@isempty,fl)) = {NaN};
        firstLicksEarly{mouse} = vertcat(firstLicksEarly{mouse}, fl);
        numLicksEarly{mouse} = vertcat(numLicksEarly{mouse}, cellfun(@numel,M(mouse).summary(i).cleanLicks,'uniformoutput',0));
        allLicksEarly{mouse} = vertcat(allLicksEarly{mouse}, M(mouse).summary(i).cleanLicks);
        
    end
    
    
    for i = useSessions
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        fl(cellfun(@isempty,fl)) = {NaN};
        firstLicks{mouse} = vertcat(firstLicks{mouse}, fl);
        numLicks{mouse} = vertcat(numLicks{mouse}, cellfun(@numel,M(mouse).summary(i).cleanLicks,'uniformoutput',0));
        allLicks{mouse} = vertcat(allLicks{mouse}, M(mouse).summary(i).cleanLicks);
        
    end
    firstLicks{mouse} = cell2mat(firstLicks{mouse});
    numLicks{mouse}  = cell2mat(numLicks{mouse});
    
end

catLicks  = vertcat(allLicks{:});
catLicks = vertcat(catLicks{:});

catEarlyLicks  = vertcat(allLicksEarly{:});
catEarlyLicks = vertcat(catEarlyLicks{:});

catLateLicks  = vertcat(allLicksLate{:});
catLateLicks = vertcat(catLateLicks{:});
%%

figure(1);clf
histogram(diff(catEarlyLicks),[0:.01:10],'Normalization','probability','FaceColor',[0.7 0.7 0.7])
hold on
histogram(diff(catLateLicks),[0:.01:10],'Normalization','probability','FaceColor','k')
set(gca,'xlim',[0 1])
xlabel('Inter-lick Interval (s)')
ylabel('Count probability')
legend('Early','Expert')
title('Lick interval distribution')
set(gcf,'paperposition',[0 0 4 4])
print(gcf,'-depsc2','LickIntervalDistributionCountProbability')
print(gcf,'-dpng','LickIntervalDistributionCountProbability')