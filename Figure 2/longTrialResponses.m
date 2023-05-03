d = dir('*Struct.mat')

for m = 1:length(d)
    
    load(d(m).name);
    goodSessions = find([summary.polePresent]+[summary.hasWhisker]-[summary.hasScopolamine]+[arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3);
    %arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3 is used to find
    %sessions that have FA trials (means introduced no go)
    nowhiskerSessions=find([summary.hasScopolamine]+[summary.hasWhisker]==0);
    %%
    % Choose sessions to analyze
    chooseSessions = 1:length(summary);
    
    
    hitFMat = cell(1,length(summary));
    missFMat = cell(1,length(summary));
    FAFMat = cell(1,length(summary));
    CRFMat = cell(1,length(summary));
    
    for i=1:length(summary)
        
        % find frames to use for the non-corrected long duration response
        % comparisions
        
        trimTrialStart = 1:min([length(summary(i).trialStart) length(summary(i).poleOnset)]);
        
        hitIdx = summary(i).trialStart(find(summary(i).trialMatrix(trimTrialStart,1)));
        missIdx = summary(i).trialStart(find(summary(i).trialMatrix(trimTrialStart,2)));
        FAIdx = summary(i).trialStart(find(summary(i).trialMatrix(trimTrialStart,3)));
        CRIdx = summary(i).trialStart(find(summary(i).trialMatrix(trimTrialStart,4)));
        
        % Trim indicies to avoid bleaching start and padded end
        endCutoff = 300 %in frames
        startCutoff = 1500 % in frames
        totalFrames = length(summary(i).maskedFOVraw); % in frames
        frameWindow = 0:299; % number of frames to sample
        frameRate = 15.44; % fps
        
        hitIdx = hitIdx(hitIdx > startCutoff & hitIdx < totalFrames - endCutoff)';
        missIdx = missIdx(missIdx > startCutoff & missIdx < totalFrames - endCutoff)';
        FAIdx = FAIdx(FAIdx > startCutoff & FAIdx < totalFrames - endCutoff)';
        CRIdx = CRIdx(CRIdx > startCutoff & CRIdx < totalFrames - endCutoff)';
        
        try
            hitMatIdx = repmat(hitIdx,1,length(frameWindow))+repmat(frameWindow,length(hitIdx),1);
        catch
            hitMatIdx = [];
        end
        
        try
            missMatIdx = repmat(missIdx,1,length(frameWindow))+repmat(frameWindow,length(missIdx),1);
        catch
            missMatIdx = [];
        end
        
        try
            FAMatIdx = repmat(FAIdx,1,length(frameWindow))+repmat(frameWindow,length(FAIdx),1);
        catch
            FAMatIdx = [];
        end
        
        try
            CRMatIdx = repmat(CRIdx,1,length(frameWindow))+repmat(frameWindow,length(CRIdx),1);
        catch
            CRMatIdx = [];
        end
        
        hitFMat{i}  = summary(i).maskedFOVraw(hitMatIdx);
        missFMat{i} = summary(i).maskedFOVraw(missMatIdx);
        FAFMat{i}  = summary(i).maskedFOVraw(FAMatIdx);
        CRFMat{i}  = summary(i).maskedFOVraw(CRMatIdx);
        
        %this is dumb fix for a transpose that happens if there is only one
        %trial in the session that matches criteria
        
        if size(CRFMat{i},2)==1
            CRFMat{i} = CRFMat{i}';
        end
        
    end
    
    F(m).hitFMat  = hitFMat;
    F(m).missFMat = missFMat;
    F(m).FAFMat   = FAFMat;
    F(m).CRFMat   = CRFMat;
    F(m).goodSessions      = goodSessions;
    F(m).nowhiskerSessions = nowhiskerSessions;
    
    selectSessions =  F(m).goodSessions(1:3);
    
    % Reimplement this as a function please
    
    selectFHit = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,hitFMat(selectSessions),'uniformoutput',0);
    
    %another stupid edge case fix if the session has no miss trials use
    %only sessions that have miss trials
    
    try
        selectFMiss = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,missFMat(selectSessions),'uniformoutput',0);
    catch
        selectFMiss = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,missFMat(selectSessions(find(cellfun(@(x)numel(x),missFMat(selectSessions))))),'uniformoutput',0);
        
    end
    
    
    selectFFA = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,FAFMat(selectSessions),'uniformoutput',0);
    selectFCR = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,CRFMat(selectSessions),'uniformoutput',0);
    
    F(m).earlyF.hit  = mean(cat(1,selectFHit{:}));
    F(m).earlyF.miss = mean(cat(1,selectFMiss{:}));
    F(m).earlyF.FA   = mean(cat(1,selectFFA{:}));
    F(m).earlyF.CR   = mean(cat(1,selectFCR{:}));
    
    selectSessions =  F(m).goodSessions(end-2:end);
    
    selectFHit = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,hitFMat(selectSessions),'uniformoutput',0);
    
     %another stupid edge case fix if the session has no miss trials use
    %only sessions that have miss trials
    
    try
    selectFMiss = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,missFMat(selectSessions),'uniformoutput',0);
    catch
            selectFMiss = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,missFMat(selectSessions(find(cellfun(@(x)numel(x),missFMat(selectSessions))))),'uniformoutput',0);
      
    end
    selectFFA = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,FAFMat(selectSessions),'uniformoutput',0);
    selectFCR = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,CRFMat(selectSessions),'uniformoutput',0);
    
    F(m).lateF.hit  = mean(cat(1,selectFHit{:}));
    F(m).lateF.miss = mean(cat(1,selectFMiss{:}));
    F(m).lateF.FA   = mean(cat(1,selectFFA{:}));
    F(m).lateF.CR   = mean(cat(1,selectFCR{:}));
    
    selectSessions =  F(m).nowhiskerSessions;
    
    
    selectFHit = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,hitFMat(selectSessions),'uniformoutput',0);
    selectFMiss = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,missFMat(selectSessions),'uniformoutput',0);
    selectFFA = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,FAFMat(selectSessions),'uniformoutput',0);
    selectFCR = cellfun(@(x)mean(x,1)./mean(mean(x(:,1:15)))-1,CRFMat(selectSessions),'uniformoutput',0);
    
    F(m).nowhiskerF.hit  = mean(cat(1,selectFHit{:}));
    F(m).nowhiskerF.miss = mean(cat(1,selectFMiss{:}));
    F(m).nowhiskerF.FA   = mean(cat(1,selectFFA{:}));
    F(m).nowhiskerF.CR   = mean(cat(1,selectFCR{:}));
    
end



%% Experts plot
figure(1);clf;hold on
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.hit,F,'uniformoutput',0)')),'-b')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.miss,F,'uniformoutput',0)')),'-k')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.CR,F,'uniformoutput',0)')),'-r')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.FA,F,'uniformoutput',0)')),'-g')


xlim([0 10])
ylabel('Expert dF/F')
xlabel('Time (s)')



%% Early plot
figure(2);clf
subplot(3,1,1)
;hold on
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.hit,F,'uniformoutput',0)')),'-b')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.miss,F,'uniformoutput',0)')),'-k')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.CR,F,'uniformoutput',0)')),'-r')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.FA,F,'uniformoutput',0)')),'-g')
xlim([0 10])
ylabel('Early dF/F')




%% plot results Grand Mean

figure(2);clf
subplot(3,1,1)
;hold on
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.hit,F,'uniformoutput',0)')),'-b')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.miss,F,'uniformoutput',0)')),'-k')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.CR,F,'uniformoutput',0)')),'-r')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.earlyF.FA,F,'uniformoutput',0)')),'-g')
xlim([0 10])
ylabel('Early dF/F')

subplot(3,1,2)
;hold on
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.hit,F,'uniformoutput',0)')),'-b')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.miss,F,'uniformoutput',0)')),'-k')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.CR,F,'uniformoutput',0)')),'-r')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.lateF.FA,F,'uniformoutput',0)')),'-g')
xlim([0 10])
ylabel('Expert dF/F')


subplot(3,1,3)
;hold on
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.nowhiskerF.hit,F(5:8),'uniformoutput',0)')),'-b')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.nowhiskerF.miss,F(5:8),'uniformoutput',0)')),'-k')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.nowhiskerF.CR,F(5:8),'uniformoutput',0)')),'-r')
plot(frameWindow/frameRate,nanmean(cell2mat(arrayfun(@(x)x.nowhiskerF.FA,F(5:8),'uniformoutput',0)')),'-g')
xlim([0 10])
xlabel('Time (s)')
ylabel('Nowhisker dF/F')



%% Plot results

selectSessions = [10:17 20:22]


selectFHit = cellfun(@(x)mean(x)./mean(mean(x(:,1:15)))-1,hitFMat(selectSessions),'uniformoutput',0);
selectMeanHit = mean(cat(1,selectFHit{:}));

selectFMiss = cellfun(@(x)mean(x)./mean(mean(x(:,1:15)))-1,missFMat(selectSessions),'uniformoutput',0);
selectMeanMiss = mean(cat(1,selectFMiss{:}));

selectFFA = cellfun(@(x)mean(x)./mean(mean(x(:,1:15)))-1,FAFMat(selectSessions),'uniformoutput',0);
selectMeanFA = mean(cat(1,selectFFA{:}));

selectFCR = cellfun(@(x)mean(x)./mean(mean(x(:,1:15)))-1,CRFMat(selectSessions),'uniformoutput',0);
selectMeanCR = mean(cat(1,selectFCR{:}));

figure(2);clf;hold on
plot(frameWindow/frameRate,selectMeanHit,'-b')
plot(frameWindow/frameRate,selectMeanMiss,'-k')
plot(frameWindow/frameRate,selectMeanFA,'-g')
plot(frameWindow/frameRate,selectMeanCR,'-r')
xlabel('Time (s)')
xlim([0 20])
xlabel('Time (s)')
ylabel('dF/F')

%%


d = dir('*Struct.mat')

for m = 1:length(d)
    
    load(d(m).name);
    goodSessions = find([summary.polePresent]+[summary.hasWhisker]-[summary.hasScopolamine]+[arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3);
    %arrayfun(@(x) sum(x.trialMatrix(:,3)),summary)>0]==3 is used to find
    %sessions that have FA trials (means introduced no go)
    nowhiskerSessions=find([summary.hasScopolamine]+[summary.hasWhisker]==0);
    %%
    % Choose sessions to analyze
    chooseSessions = 1:length(summary);
    
    hitLR = cell(1,length(chooseSessions));
    missLR = cell(1,length(chooseSessions));
    FALR = cell(1,length(chooseSessions));
    CRLR = cell(1,length(chooseSessions));
    edges = [0:0.1:6];
    midEdges = [edges(1:end-1)+edges(2:end)]/2;
    
    
    for i= 1:length(chooseSessions)
        % Extract trial types from the selected sessions
        chooseTM = cat(1,summary(chooseSessions(i)).trialMatrix);
        
        % Extract clean licks from sessions
        chooseCL = cat(1,summary(chooseSessions(i)).cleanLicks);
        
        % Sort clean licks into trial type
        %    For choose sessions
        chooseHitCL = chooseCL(find(chooseTM(:,1)));
        chooseHitCL = cat(1,chooseHitCL{:});
        
        chooseMissCL = chooseCL(find(chooseTM(:,2)));
        chooseMissCL = cat(1,chooseMissCL{:});
        
        chooseFACL = chooseCL(find(chooseTM(:,3)));
        chooseFACL = cat(1,chooseFACL{:});
        
        chooseCRCL = chooseCL(find(chooseTM(:,4)));
        chooseCRCL = cat(1,chooseCRCL{:});
        
        
        
        L(m).hitLR{chooseSessions(i)} = histcounts(chooseHitCL,edges)/(sum(chooseTM(:,1))*edges(2));
        L(m).missLR{chooseSessions(i)} = histcounts(chooseMissCL,edges)/(sum(chooseTM(:,2))*edges(2));
        L(m).FALR{chooseSessions(i)} = histcounts(chooseFACL,edges)/(sum(chooseTM(:,3))*edges(2));
        L(m).CRLR{chooseSessions(i)} = histcounts(chooseCRCL,edges)/(sum(chooseTM(:,4))*edges(2));
        L(m).goodSessions =goodSessions;
        L(m).nowhiskerSessions=nowhiskerSessions;
    end
end

%% Legacy plotting code, Pre cell arry format

figure(1);clf;hold on
plot(frameWindow/frameRate,mean(hitFMat),'-b')
plot(frameWindow/frameRate,mean(missFMat),'-k')
plot(frameWindow/frameRate,mean(FAFMat),'-g')
plot(frameWindow/frameRate,mean(CRFMat),'-r')

xlabel('Time (s)')
ylabel('raw F')

figure(2);clf;hold on
plot(frameWindow/frameRate,mean(hitFMat)./mean(mean(hitFMat(:,1:15)))-1,'-b')
plot(frameWindow/frameRate,mean(missFMat)./mean(mean(missFMat(:,1:15)))-1,'-k')
plot(frameWindow/frameRate,mean(FAFMat)./mean(mean(FAFMat(:,1:15)))-1,'-g')
plot(frameWindow/frameRate,mean(CRFMat)./mean(mean(CRFMat(:,1:15)))-1,'-r')
xlabel('Time (s)')

xlabel('Time (s)')
ylabel('dF/F')

