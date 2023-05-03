%plot lick number against the half width of the first hump of the Ach
%release

%% Gather the first licks in dataset
firstLicks = cell(8,1);
firstLicksEarly = cell(8,1);
firstLicksLate = cell(8,1);
numLicks= cell(8,1);
numLicksEarly= cell(8,1);
numLicksLate = cell(8,1);
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
trialFrames = [0:153]; % only include first 10 seconds of trial
preLickPad = -16;
baseAch = cell(8,1);
trialAch = cell(8,1);
trialDFF = cell(8,1);
goodTrial = cell(8,1);
rewardTrial = cell(8,1);
goodTrial = cell(8,1);
firstLickDFF = cell(8,1);
firstLickAch = cell(8,1);
isExpert = cell(8,1);
gotReward = cell(8,1);
isBeginner = cell(8,1);
baseline2 = [-16:-1]; % frames
baseAch2 = cell(8,1);
isSession= cell(8,1);

for mouse = 1:8
    useSessions = find(arrayfun(@(x)~isempty(x.theta),M(mouse).summary,'uniformoutput',1)); % get sessions with whisker data
    
    for i = useSessions
        
        % pad frames that don't exist past last trial with NaN
        rawAch = nan(M(mouse).summary(i).trialStart(end)+trialFrames(end)+154,1);
        rawAch(1:length(M(mouse).summary(i).maskedFOVraw)) = M(mouse).summary(i).maskedFOVraw;
        
        %Preallocate
        
        baseAchTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        trialAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        goodTrialTmp = (M(mouse).summary(i).trialStart >1544)';
        firstLickAchTmp = zeros(length(M(mouse).summary(i).trialStart),length(trialFrames));
        isExpertTmp = zeros(length(M(mouse).summary(i).trialStart),1);
        gotRewardTmp = M(mouse).summary(i).trialMatrix(:,1);
        isBeginnerTmp= zeros(length(M(mouse).summary(i).trialStart),1);
        baseAchTmp2= zeros(length(M(mouse).summary(i).trialStart),1);   %use 16 frames before first lick as baseline
        isSessionTmp=zeros(length(M(mouse).summary(i).trialStart),1);
        
        isSessionTmp(:)=i;
        
        if i >= useSessions(end-2);
            isExpertTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        if i <= useSessions(3);
            isBeginnerTmp(:) = 1;   %flag expertsessions with a 1 based on what session we are in
        end
        
        fl = cellfun(@min,M(mouse).summary(i).cleanLicks,'uniformoutput',0);
        
        for t = 1:length(M(mouse).summary(i).trialStart)
            baseAchTmp(t) = mean(rawAch(M(mouse).summary(i).trialStart(t)+baseline));            
            trialAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames);
            if isempty(fl{t})
                
                firstLickAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad + round(1.7*15.44));
                
                baseAchTmp2(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(1.7*15.44)+baseline2));
            else
                
                firstLickAchTmp(t,:) = rawAch(M(mouse).summary(i).trialStart(t)+trialFrames+preLickPad+round(15.44*fl{t}));
                
                baseAchTmp2(t)=mean(rawAch(M(mouse).summary(i).trialStart(t)+round(min(M(mouse).summary(i).licks{t})*15.44)+baseline2)); %use 16 frames before first lick as baseline
            end
        end
        
        
        baseAch{mouse} = vertcat(baseAch{mouse},baseAchTmp);
        trialAch{mouse} = vertcat(trialAch{mouse},trialAchTmp);
        goodTrial{mouse} = vertcat(goodTrial{mouse},goodTrialTmp);
        firstLickAch{mouse} = vertcat(firstLickAch{mouse},firstLickAchTmp);
        isExpert{mouse} = vertcat(isExpert{mouse},isExpertTmp);
        gotReward{mouse} = vertcat(gotReward{mouse},gotRewardTmp);
        isBeginner{mouse}=vertcat(isBeginner{mouse},isBeginnerTmp);
        baseAch2{mouse} = vertcat(baseAch2{mouse},baseAchTmp2);
        isSession{mouse}= vertcat( isSession{mouse}, isSessionTmp);
    end
    goodTrial{mouse} = logical(goodTrial{mouse});
    trialDFF{mouse} = trialAch{mouse}./repmat(baseAch{mouse},1,size(trialAch{mouse},2))-1;
    firstLickDFF{mouse} = firstLickAch{mouse}./baseAch{mouse}-1;
    firstLickDFF2{mouse} = firstLickAch{mouse}./baseAch2{mouse}-1;  %use 16 frames before first lick as baseline
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


%% plot figures
maxLickNum=15;
lickalignTrace=cell(maxLickNum+1,1);
for i=1:(maxLickNum+1)
    
        lickalignTraceTmp=NaN(8,size(firstLickDFF3{1,1},2));
        for mouse=1:8
        lickalignTraceTmp(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==i-1,:));
        end 
        lickalignTrace{i}=lickalignTraceTmp;
end
for i=1:maxLickNum
    figure(i);clf
    plot(nanmean(lickalignTrace{i+1}))
    LickNum=i;
    LickNum2=sprintf('%.1f',LickNum);  
   title([ LickNum 'Licks'])
%    print(gcf,'-dpng','-r300',[LickNum 'Lick Ach Trace'])
%    print(gcf,'-depsc2',[LickNum 'Lick Ach Trace'])
end



%manually type the lick duration
lickduration=NaN(11,1);
lickduration(1)=30/15.44;
lickduration(2)=31/15.44;
lickduration(3)=32/15.44;
lickduration(4)=32/15.44;
lickduration(5)=31/15.44;
lickduration(6)=32/15.44;
lickduration(7)=30/15.44;
lickduration(8)=22/15.44;
lickduration(9)=19/15.44;
lickduration(10)=23/15.44;
lickduration(11)= 26/15.44;
lickduration(12)= 26/15.44;
lickduration(13)= 26/15.44;
lickduration(14)= 39/15.44;
lickduration(15)= 46/15.44;
figure(1);
bar([1:15],lickduration,'k')
xlabel('Lick Number','FontSize', 20,'FontWeight','bold')
ylabel('First lick Ach duration/s','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['Lick count vs Ach duration'])
print(gcf,'-depsc2',['Lick count vs Ach duration'])

%%
%1 lick
LickNumDurationMatrix=NaN(15,9);
lickalignTrace1=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace1(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==1,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==1,:)))
  title([M(mouse).summary(1).name(1:4) ' one lick'])
%    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' one lick'])
%  print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) 'one lick'])
end
LickNumDurationMatrix(1,1)= (58-33)/15.44;
LickNumDurationMatrix(1,2)= (55-33)/15.44;
LickNumDurationMatrix(1,3)= (47-33)/15.44;
LickNumDurationMatrix(1,4)= (61-33)/15.44;
LickNumDurationMatrix(1,5)= (62-33)/15.44;
LickNumDurationMatrix(1,6)= NaN;
LickNumDurationMatrix(1,7)= (40-33)/15.44;
LickNumDurationMatrix(1,8)= (66-33)/15.44;
%2 lick

lickalignTrace2=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace2(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==2,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==2,:)))
  title([M(mouse).summary(1).name(1:4) ' two lick'])
%      print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' two lick'])
%  print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) 'two lick'])
end
LickNumDurationMatrix(2,1)= (57-33)/15.44;
LickNumDurationMatrix(2,2)= (59-33)/15.44;
LickNumDurationMatrix(2,3)= (60-33)/15.44;
LickNumDurationMatrix(2,4)= (45-33)/15.44;
LickNumDurationMatrix(2,5)= (68-33)/15.44;
LickNumDurationMatrix(2,6)= (63-33)/15.44;
LickNumDurationMatrix(2,7)= (44-33)/15.44;
LickNumDurationMatrix(2,8)= (69-33)/15.44;
%3 lick

lickalignTrace3=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace3(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==3,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==3,:)))
   title([M(mouse).summary(1).name(1:4) ' three lick'])
end
LickNumDurationMatrix(3,1)= (60-33)/15.44;
LickNumDurationMatrix(3,2)= (66-33)/15.44;
LickNumDurationMatrix(3,3)= (52-33)/15.44;
LickNumDurationMatrix(3,4)= (47-33)/15.44;
LickNumDurationMatrix(3,5)= (69-33)/15.44;
LickNumDurationMatrix(3,6)= (63-33)/15.44;
LickNumDurationMatrix(3,7)= (45-33)/15.44;
LickNumDurationMatrix(3,8)= (72-33)/15.44;
%4 lick

lickalignTrace4=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace4(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==4,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==4,:)))
   title([M(mouse).summary(1).name(1:4) ' four lick'])
end
LickNumDurationMatrix(4,1)= (66-33)/15.44;
LickNumDurationMatrix(4,2)= (69-33)/15.44;
LickNumDurationMatrix(4,3)= (52-33)/15.44;
LickNumDurationMatrix(4,4)= (49-33)/15.44;
LickNumDurationMatrix(4,5)= (71-33)/15.44;
LickNumDurationMatrix(4,6)= (63-33)/15.44;
LickNumDurationMatrix(4,7)= (49-33)/15.44;
LickNumDurationMatrix(4,8)= (71-33)/15.44;
%5 lick

lickalignTrace5=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace5(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==5,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==5,:)))
   title([M(mouse).summary(1).name(1:4) ' five lick'])
end
LickNumDurationMatrix(5,1)= (67-33)/15.44;
LickNumDurationMatrix(5,2)= (72-33)/15.44;
LickNumDurationMatrix(5,3)= (56-33)/15.44;
LickNumDurationMatrix(5,4)= (52-33)/15.44;
LickNumDurationMatrix(5,5)= (70-33)/15.44;
LickNumDurationMatrix(5,6)= (54-33)/15.44;
LickNumDurationMatrix(5,7)= (51-33)/15.44;
LickNumDurationMatrix(5,8)= (71-33)/15.44;
%6 lick

lickalignTrace6=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace6(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==6,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==6,:)))
   title([M(mouse).summary(1).name(1:4) ' six lick'])
end
LickNumDurationMatrix(6,1)= (67-33)/15.44;
LickNumDurationMatrix(6,2)= (63-33)/15.44;
LickNumDurationMatrix(6,3)= (56-33)/15.44;
LickNumDurationMatrix(6,4)= (54-33)/15.44;
LickNumDurationMatrix(6,5)= (72-33)/15.44;
LickNumDurationMatrix(6,6)= (54-33)/15.44;
LickNumDurationMatrix(6,7)= (53-33)/15.44;
LickNumDurationMatrix(6,8)= (73-33)/15.44;
%7 lick

lickalignTrace7=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace7(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==7,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==7,:)))
  title([M(mouse).summary(1).name(1:4) ' seven lick'])
end
LickNumDurationMatrix(7,1)= (69-33)/15.44;
LickNumDurationMatrix(7,2)= (64-33)/15.44;
LickNumDurationMatrix(7,3)= (59-33)/15.44;
LickNumDurationMatrix(7,4)= (61-33)/15.44;
LickNumDurationMatrix(7,5)= (74-33)/15.44;
LickNumDurationMatrix(7,6)= (59-33)/15.44;
LickNumDurationMatrix(7,7)= (55-33)/15.44;
LickNumDurationMatrix(7,8)= (75-33)/15.44;
%8 lick

lickalignTrace8=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace8(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==8,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==8,:)))
  title([M(mouse).summary(1).name(1:4) ' eight lick'])
end
LickNumDurationMatrix(8,1)= (71-33)/15.44;
LickNumDurationMatrix(8,2)= (71-33)/15.44;
LickNumDurationMatrix(8,3)= (59-33)/15.44;
LickNumDurationMatrix(8,4)=(58-33)/15.44 ;
LickNumDurationMatrix(8,5)=(82-33)/15.44 ;
LickNumDurationMatrix(8,6)= (58-33)/15.44;
LickNumDurationMatrix(8,7)=(56-33)/15.44 ;
LickNumDurationMatrix(8,8)= (72-33)/15.44;
%9 lick

lickalignTrace9=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace9(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==9,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==9,:)))
  title([M(mouse).summary(1).name(1:4) ' nine lick'])
end
LickNumDurationMatrix(9,1)= (65-33)/15.44;
LickNumDurationMatrix(9,2)= (68-33)/15.44;
LickNumDurationMatrix(9,3)= (61-33)/15.44;
LickNumDurationMatrix(9,4)= (61-33)/15.44;
LickNumDurationMatrix(9,5)= (61-33)/15.44;
LickNumDurationMatrix(9,6)= (55-33)/15.44;
LickNumDurationMatrix(9,7)= (57-33)/15.44;
LickNumDurationMatrix(9,8)= (77-33)/15.44;
%10 lick

lickalignTrace10=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace10(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==10,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==10,:)))
  title([M(mouse).summary(1).name(1:4) ' ten lick'])
end
LickNumDurationMatrix(10,1)= (63-33)/15.44;
LickNumDurationMatrix(10,2)= (75-33)/15.44;
LickNumDurationMatrix(10,3)= (62-33)/15.44;
LickNumDurationMatrix(10,4)= (59-33)/15.44;
LickNumDurationMatrix(10,5)= (64-33)/15.44;
LickNumDurationMatrix(10,6)= (61-33)/15.44;
LickNumDurationMatrix(10,7)= (58-33)/15.44;
LickNumDurationMatrix(10,8)= (85-33)/15.44;
%11 lick

lickalignTrace11=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace11(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==11,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==11,:)))
  title([M(mouse).summary(1).name(1:4) ' eleven lick'])
end
LickNumDurationMatrix(11,1)= (67-33)/15.44;
LickNumDurationMatrix(11,2)= (47-33)/15.44;
LickNumDurationMatrix(11,3)= (63-33)/15.44;
LickNumDurationMatrix(11,4)= (62-33)/15.44;
LickNumDurationMatrix(11,5)= (64-33)/15.44;
LickNumDurationMatrix(11,6)= (59-33)/15.44;
LickNumDurationMatrix(11,7)= (56-33)/15.44;
LickNumDurationMatrix(11,8)= (78-33)/15.44;
%12 lick

lickalignTrace12=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace12(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==12,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==12,:)))
  title([M(mouse).summary(1).name(1:4) ' twelve lick'])
end
LickNumDurationMatrix(12,1)= (66-33)/15.44;
LickNumDurationMatrix(12,2)= (76-33)/15.44;
LickNumDurationMatrix(12,3)= (64-33)/15.44;
LickNumDurationMatrix(12,4)= (63-33)/15.44;
LickNumDurationMatrix(12,5)= (76-33)/15.44;
LickNumDurationMatrix(12,6)= (59-33)/15.44;
LickNumDurationMatrix(12,7)= (46-33)/15.44;
LickNumDurationMatrix(12,8)= (72-33)/15.44;
%13 lick

lickalignTrace13=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace13(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==13,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==13,:)))
   title([M(mouse).summary(1).name(1:4) ' 13 lick'])
end
LickNumDurationMatrix(13,1)= (60-33)/15.44;
LickNumDurationMatrix(13,2)= (77-33)/15.44;
LickNumDurationMatrix(13,3)= (59-33)/15.44;
LickNumDurationMatrix(13,4)= (62-33)/15.44;
LickNumDurationMatrix(13,5)= (84-33)/15.44;
LickNumDurationMatrix(13,6)= (61-33)/15.44;
LickNumDurationMatrix(13,7)= (46-33)/15.44;
LickNumDurationMatrix(13,8)= (75-33)/15.44;
%14 lick

lickalignTrace14=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace14(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==14,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==14,:)))
  title([M(mouse).summary(1).name(1:4) ' 14 lick'])
end
LickNumDurationMatrix(14,1)= (60-33)/15.44;
LickNumDurationMatrix(14,2)= (51-33)/15.44;
LickNumDurationMatrix(14,3)= (48-33)/15.44;
LickNumDurationMatrix(14,4)= (61-33)/15.44;
LickNumDurationMatrix(14,5)= (78-33)/15.44;
LickNumDurationMatrix(14,6)= (60-33)/15.44;
LickNumDurationMatrix(14,7)= (43-33)/15.44;
LickNumDurationMatrix(14,8)= (79-33)/15.44;
%15 lick

lickalignTrace15=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace15(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==15,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks{mouse}==15,:)))
  title([M(mouse).summary(1).name(1:4) ' 15 lick'])
end
LickNumDurationMatrix(15,1)= (69-33)/15.44;
LickNumDurationMatrix(15,2)= (45-33)/15.44;
LickNumDurationMatrix(15,3)= (47-33)/15.44;
LickNumDurationMatrix(15,4)= (71-33)/15.44;
LickNumDurationMatrix(15,5)= (69-33)/15.44;
LickNumDurationMatrix(15,6)= (65-33)/15.44;
LickNumDurationMatrix(15,7)= (42-33)/15.44;
LickNumDurationMatrix(15,8)= (75-33)/15.44;

for lickNumPerTrial=1:15
    LickNumDurationMatrix(lickNumPerTrial,9)=nanmean(LickNumDurationMatrix(lickNumPerTrial,1:8));
end
figure(1);clf
bar([1:15],[LickNumDurationMatrix(1:15,9)],'k')
hold on
for lickNumPerTrial=1:15
   for mouse=1:8
       plot(lickNumPerTrial,LickNumDurationMatrix(lickNumPerTrial,mouse),'o','color',[.5 .5 .5])
   end
end
xlabel('Licks in trial','FontSize', 20,'FontWeight','bold')
ylabel('Ach relese duration/s','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts against Ach duration'])
print(gcf,'-depsc2',['lick counts against Ach duration'])

figure(2);clf
bar([1:10],[LickNumDurationMatrix(1:10,9)],'k')
hold on
for lickNumPerTrial=1:10
   for mouse=1:8
       plot(lickNumPerTrial,LickNumDurationMatrix(lickNumPerTrial,mouse),'o','color',[.5 .5 .5])
   end
end
xlabel('Licks in trial','FontSize', 20,'FontWeight','bold')
ylabel('Ach relese duration/s','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts against Ach duration 10 lick'])
print(gcf,'-depsc2',['lick counts against Ach duration 10 lick'])




%% Use lick count within 2s after first lick as x axis, numLicks_2s is already defined
%1 lick
LickNumDurationMatrix2=NaN(15,9);
lickalignTrace1=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace1(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==1,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==1,:)))
  title([M(mouse).summary(1).name(1:4) ' one lick'])
%    print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' one lick'])
%  print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) 'one lick'])
end
LickNumDurationMatrix2(1,1)= (58-33)/15.44;
LickNumDurationMatrix2(1,2)= (55-33)/15.44;
LickNumDurationMatrix2(1,3)= (44-33)/15.44;
LickNumDurationMatrix2(1,4)= (64-33)/15.44;
LickNumDurationMatrix2(1,5)= (62-33)/15.44;
LickNumDurationMatrix2(1,6)= NaN;
LickNumDurationMatrix2(1,7)= (40-33)/15.44;
LickNumDurationMatrix2(1,8)= (66-33)/15.44;
%2 lick

lickalignTrace2=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace2(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==2,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==2,:)))
  title([M(mouse).summary(1).name(1:4) ' two lick'])
%      print(gcf,'-dpng','-r300',[M(mouse).summary(1).name(1:4) ' two lick'])
%  print(gcf,'-depsc2',[M(mouse).summary(1).name(1:4) 'two lick'])
end
LickNumDurationMatrix2(2,1)= (57-33)/15.44;
LickNumDurationMatrix2(2,2)= (59-33)/15.44;
LickNumDurationMatrix2(2,3)= (47-33)/15.44;
LickNumDurationMatrix2(2,4)= (45-33)/15.44;
LickNumDurationMatrix2(2,5)= (64-33)/15.44;
LickNumDurationMatrix2(2,6)= (59-33)/15.44;
LickNumDurationMatrix2(2,7)= (44-33)/15.44;
LickNumDurationMatrix2(2,8)= (66-33)/15.44;
%3 lick

lickalignTrace3=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace3(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==3,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==3,:)))
   title([M(mouse).summary(1).name(1:4) ' three lick'])
end
LickNumDurationMatrix2(3,1)= (60-33)/15.44;
LickNumDurationMatrix2(3,2)= (63-33)/15.44;
LickNumDurationMatrix2(3,3)= (52-33)/15.44;
LickNumDurationMatrix2(3,4)= (45-33)/15.44;
LickNumDurationMatrix2(3,5)= (66-33)/15.44;
LickNumDurationMatrix2(3,6)= (63-33)/15.44;
LickNumDurationMatrix2(3,7)= (45-33)/15.44;
LickNumDurationMatrix2(3,8)= (71-33)/15.44;
%4 lick

lickalignTrace4=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace4(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==4,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==4,:)))
   title([M(mouse).summary(1).name(1:4) ' four lick'])
end
LickNumDurationMatrix2(4,1)= (66-33)/15.44;
LickNumDurationMatrix2(4,2)= (70-33)/15.44;
LickNumDurationMatrix2(4,3)= (52-33)/15.44;
LickNumDurationMatrix2(4,4)= (49-33)/15.44;
LickNumDurationMatrix2(4,5)= (68-33)/15.44;
LickNumDurationMatrix2(4,6)= (48-33)/15.44;
LickNumDurationMatrix2(4,7)= (46-33)/15.44;
LickNumDurationMatrix2(4,8)= (71-33)/15.44;
%5 lick

lickalignTrace5=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace5(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==5,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==5,:)))
   title([M(mouse).summary(1).name(1:4) ' five lick'])
end
LickNumDurationMatrix2(5,1)= (65-33)/15.44;
LickNumDurationMatrix2(5,2)= (73-33)/15.44;
LickNumDurationMatrix2(5,3)= (53-33)/15.44;
LickNumDurationMatrix2(5,4)= (49-33)/15.44;
LickNumDurationMatrix2(5,5)= (72-33)/15.44;
LickNumDurationMatrix2(5,6)= (54-33)/15.44;
LickNumDurationMatrix2(5,7)= (46-33)/15.44;
LickNumDurationMatrix2(5,8)= (71-33)/15.44;
%6 lick

lickalignTrace6=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace6(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==6,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==6,:)))
   title([M(mouse).summary(1).name(1:4) ' six lick'])
end
LickNumDurationMatrix2(6,1)= (70-33)/15.44;
LickNumDurationMatrix2(6,2)= (72-33)/15.44;
LickNumDurationMatrix2(6,3)= (56-33)/15.44;
LickNumDurationMatrix2(6,4)= (60-33)/15.44;
LickNumDurationMatrix2(6,5)= (74-33)/15.44;
LickNumDurationMatrix2(6,6)= (54-33)/15.44;
LickNumDurationMatrix2(6,7)= (44-33)/15.44;
LickNumDurationMatrix2(6,8)= (73-33)/15.44;
%7 lick

lickalignTrace7=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace7(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==7,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==7,:)))
  title([M(mouse).summary(1).name(1:4) ' seven lick'])
end
LickNumDurationMatrix2(7,1)= (69-33)/15.44;
LickNumDurationMatrix2(7,2)= (64-33)/15.44;
LickNumDurationMatrix2(7,3)= (59-33)/15.44;
LickNumDurationMatrix2(7,4)= (58-33)/15.44;
LickNumDurationMatrix2(7,5)= (76-33)/15.44;
LickNumDurationMatrix2(7,6)= (60-33)/15.44;
LickNumDurationMatrix2(7,7)= (45-33)/15.44;
LickNumDurationMatrix2(7,8)= (75-33)/15.44;
%8 lick

lickalignTrace8=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace8(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==8,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==8,:)))
  title([M(mouse).summary(1).name(1:4) ' eight lick'])
end
LickNumDurationMatrix2(8,1)= (69-33)/15.44;
LickNumDurationMatrix2(8,2)= (69-33)/15.44;
LickNumDurationMatrix2(8,3)= (60-33)/15.44;
LickNumDurationMatrix2(8,4)=(63-33)/15.44 ;
LickNumDurationMatrix2(8,5)=(85-33)/15.44 ;
LickNumDurationMatrix2(8,6)= (59-33)/15.44;
LickNumDurationMatrix2(8,7)=(45-33)/15.44 ;
LickNumDurationMatrix2(8,8)= (78-33)/15.44;
%9 lick

lickalignTrace9=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace9(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==9,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==9,:)))
  title([M(mouse).summary(1).name(1:4) ' nine lick'])
end
LickNumDurationMatrix2(9,1)= (69-33)/15.44;
LickNumDurationMatrix2(9,2)= (68-33)/15.44;
LickNumDurationMatrix2(9,3)= (62-33)/15.44;
LickNumDurationMatrix2(9,4)= (61-33)/15.44;
LickNumDurationMatrix2(9,5)= (87-33)/15.44;
LickNumDurationMatrix2(9,6)= (58-33)/15.44;
LickNumDurationMatrix2(9,7)= (64-33)/15.44;
LickNumDurationMatrix2(9,8)= (87-33)/15.44;
%10 lick

lickalignTrace10=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace10(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==10,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==10,:)))
  title([M(mouse).summary(1).name(1:4) ' ten lick'])
end
LickNumDurationMatrix2(10,1)= (68-33)/15.44;
LickNumDurationMatrix2(10,2)= (75-33)/15.44;
LickNumDurationMatrix2(10,3)= (62-33)/15.44;
LickNumDurationMatrix2(10,4)= (61-33)/15.44;
LickNumDurationMatrix2(10,5)= (89-33)/15.44;
LickNumDurationMatrix2(10,6)= (59-33)/15.44;
LickNumDurationMatrix2(10,7)= (58-33)/15.44;
LickNumDurationMatrix2(10,8)= (95-33)/15.44;
%11 lick

lickalignTrace11=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace11(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==11,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==11,:)))
  title([M(mouse).summary(1).name(1:4) ' eleven lick'])
end
LickNumDurationMatrix2(11,1)= (67-33)/15.44;
LickNumDurationMatrix2(11,2)= (70-33)/15.44;
LickNumDurationMatrix2(11,3)= (67-33)/15.44;
LickNumDurationMatrix2(11,4)= (65-33)/15.44;
LickNumDurationMatrix2(11,5)= (85-33)/15.44;
LickNumDurationMatrix2(11,6)= (60-33)/15.44;
LickNumDurationMatrix2(11,7)= (56-33)/15.44;
LickNumDurationMatrix2(11,8)= (88-33)/15.44;
%12 lick

lickalignTrace12=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace12(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==12,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==12,:)))
  title([M(mouse).summary(1).name(1:4) ' twelve lick'])
end
LickNumDurationMatrix2(12,1)= (66-33)/15.44;
LickNumDurationMatrix2(12,2)= (69-33)/15.44;
LickNumDurationMatrix2(12,3)= (69-33)/15.44;
LickNumDurationMatrix2(12,4)= (71-33)/15.44;
LickNumDurationMatrix2(12,5)= (89-33)/15.44;
LickNumDurationMatrix2(12,6)= (59-33)/15.44;
LickNumDurationMatrix2(12,7)= (46-33)/15.44;
LickNumDurationMatrix2(12,8)= (95-33)/15.44;
%13 lick

lickalignTrace13=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace13(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==13,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==13,:)))
   title([M(mouse).summary(1).name(1:4) ' 13 lick'])
end
LickNumDurationMatrix2(13,1)= (60-33)/15.44;
LickNumDurationMatrix2(13,2)= (77-33)/15.44;
LickNumDurationMatrix2(13,3)= (59-33)/15.44;
LickNumDurationMatrix2(13,4)= (62-33)/15.44;
LickNumDurationMatrix2(13,5)= (78-33)/15.44;
LickNumDurationMatrix2(13,6)= (61-33)/15.44;
LickNumDurationMatrix2(13,7)= (70-33)/15.44;
LickNumDurationMatrix2(13,8)= NaN;
%14 lick

lickalignTrace14=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace14(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==14,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==14,:)))
  title([M(mouse).summary(1).name(1:4) ' 14 lick'])
end
LickNumDurationMatrix2(14,1)= (60-33)/15.44;
LickNumDurationMatrix2(14,2)= (51-33)/15.44;
LickNumDurationMatrix2(14,3)= (48-33)/15.44;
LickNumDurationMatrix2(14,4)= (61-33)/15.44;
LickNumDurationMatrix2(14,5)= (78-33)/15.44;
LickNumDurationMatrix2(14,6)= (60-33)/15.44;
LickNumDurationMatrix2(14,7)= (43-33)/15.44;
LickNumDurationMatrix2(14,8)= (79-33)/15.44;
%15 lick

lickalignTrace15=NaN(8,size(firstLickDFF3{1,1},2));
for mouse=1:8
  lickalignTrace15(mouse,:)=nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==15,:));
  figure(mouse);clf
  plot(nanmean(firstLickDFF3{mouse}(goodTrial{mouse} & numLicks_2s{mouse}==15,:)))
  title([M(mouse).summary(1).name(1:4) ' 15 lick'])
end
LickNumDurationMatrix2(15,1)= (69-33)/15.44;
LickNumDurationMatrix2(15,2)= (45-33)/15.44;
LickNumDurationMatrix2(15,3)= (47-33)/15.44;
LickNumDurationMatrix2(15,4)= (71-33)/15.44;
LickNumDurationMatrix2(15,5)= (69-33)/15.44;
LickNumDurationMatrix2(15,6)= (65-33)/15.44;
LickNumDurationMatrix2(15,7)= (42-33)/15.44;
LickNumDurationMatrix2(15,8)= (75-33)/15.44;

for lickNumPerTrial=1:15
    LickNumDurationMatrix2(lickNumPerTrial,9)=nanmean(LickNumDurationMatrix2(lickNumPerTrial,1:8));
end
figure(1);clf
bar([1:15],[LickNumDurationMatrix2(1:15,9)],'k')
hold on
for lickNumPerTrial=1:15
   for mouse=1:8
       plot(lickNumPerTrial,LickNumDurationMatrix2(lickNumPerTrial,mouse),'o','color',[.5 .5 .5])
   end
end
xlabel('Licks in trial','FontSize', 20,'FontWeight','bold')
ylabel('Ach relese duration/s','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts against Ach duration'])
print(gcf,'-depsc2',['lick counts against Ach duration'])

figure(2);clf
bar([1:10],[LickNumDurationMatrix2(1:10,9)],'k')
hold on
for lickNumPerTrial=1:10
   for mouse=1:8
       plot(lickNumPerTrial,LickNumDurationMatrix2(lickNumPerTrial,mouse),'o','color',[.5 .5 .5])
   end
end
xlabel('Licks in trial','FontSize', 20,'FontWeight','bold')
ylabel('Ach relese duration/s','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within 2s after FL against Ach duration 10 lick'])
print(gcf,'-depsc2',['lick counts within 2s after FL against Ach duration 10 lick'])

% plot linear fit 
for lickNumPerTrial=1:10
    for k=1:8
       x(k+(lickNumPerTrial-1)*8)=lickNumPerTrial;
       y(k+(lickNumPerTrial-1)*8)=LickNumDurationMatrix2(lickNumPerTrial,k);
    end
end
idx=~isnan(y);
x=x(idx);
y=y(idx);
fp=fit(x',y','poly1');

sz=25
figure(5);clf
scatter(x,y,sz,'MarkerEdgeColor','k','MarkerFaceColor','k')
hold on 
plot(fp,'k')
xlim([0 11])
xlabel('licks within 2s after FL','FontSize', 20,'FontWeight','bold')
ylabel('Ach relese duration/s','FontSize', 20,'FontWeight','bold')
print(gcf,'-dpng','-r300',['lick counts within 2s after FL against Ach duration 10 lick scatter plot with fit curve'])
print(gcf,'-depsc2',['lick counts within 2s after FL against Ach duration 10 lick scatter plot with fit curve'])


