% figure 1b, to get sample whisking data
figure(1);
clf
hold on
plot(M(1).summary(6).amplitude{62},'k','LineWidth',2)
plot(1.09*311+[0 1*311], [35 35],'-m','linewidth',2)
plot(1.09*311+[1*311 2*311], [35 35],'-c','linewidth',2)
% plot([1.09*311 1.09*311], [0 35],':m','linewidth',1)
% plot([2.09*311 2.09*311], [0 35],':c','linewidth',1)
set(gca,'xlim', [0 9]*311)
set(gca,'xtick', [1:8]*311, 'xticklabel',[1:8])
axis off
ax = gca;
ax.Clipping = 'off';
tempX = ones(1,6)*-1.5*311;
tempY = [0:5];
plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
text(-1.5*311,2.5,sprintf(' 5 degree '), 'HorizontalAlignment', 'left','FontSize',8);
tempX = [-1.5 -1]*311;
tempY = [0 0];
plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
text(-1.25*311,0,sprintf('500 ms.'), 'VerticalAlignment', 'top','FontSize',8);
ax = gca;
ax.OuterPosition = [0.1 0.1 0.9 0.9];
print(gcf,'-dpng','-r300',['fig1b_whiskingSample'])
print(gcf,'-depsc2',['fig1b_whiskingSample'])


% tempX = ones(1,51)*-1.5;
% tempY = [0:50];
% plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
% text(-1.5,25,sprintf(' 50 trials '), 'HorizontalAlignment', 'left','FontSize',8);






figure(2)
clf
hold on
plot(M(1).summary(6).maskedFOVrigid(M(1).summary(6).trialStart(62):M(1).summary(6).trialEnd(62)),'k','LineWidth',2)
plot(1.09*15.44+[0 1*15.44], [3800 3800],'-m','linewidth',2)
plot(1.09*15.44+[1*15.44 2*15.44], [3800 3800],'-c','linewidth',2)
set(gca,'xlim', [0 9]*15.44)
set(gca,'xtick', [1:8]*15.44, 'xticklabel',[1:8])
axis off
ax = gca;
ax.Clipping = 'off';
tempX = ones(1,101)*-1.5*15.44;
tempY = [3300:3400];
plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
text(-1.5*15.44,3350,sprintf(' %3 '), 'HorizontalAlignment', 'left','FontSize',8);
tempX = [-1.5 -1]*15.44;
tempY = [3300 3300];
plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
text(-1.25*15.44,3300,sprintf('500 ms.'), 'VerticalAlignment', 'top','FontSize',8);
ax = gca;
ax.OuterPosition = [0.1 0.1 0.9 0.9];
print(gcf,'-dpng','-r300',['fig1b_AchTraceSample'])
print(gcf,'-depsc2',['fig1b_AchTraceSample'])


%plot lick ticks below the fluorescence trace
figure(3)
clf
hold on
plot(M(1).summary(6).maskedFOVrigid(M(1).summary(6).trialStart(62):M(1).summary(6).trialEnd(62)),'k','LineWidth',2)
plot(1.09*15.44+[0 1*15.44], [3800 3800],'-m','linewidth',2)
plot(1.09*15.44+[1*15.44 2*15.44], [3800 3800],'-c','linewidth',2)
hold on
for i=1:length(M(1).summary(6).cleanLicks{62,1})
    plot([(M(1).summary(6).cleanLicks{62,1}(i))*15.44 (M(1).summary(6).cleanLicks{62,1}(i))*15.44], [4000 4050],'-k','linewidth',2)
end
set(gca,'xlim', [0 9]*15.44)
set(gca,'xtick', [1:8]*15.44, 'xticklabel',[1:8])
axis off
ax = gca;
ax.Clipping = 'off';
tempX = ones(1,101)*-1.5*15.44;
tempY = [3300:3400];
plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
text(-1.5*15.44,3350,sprintf('3 percent'), 'HorizontalAlignment', 'left','FontSize',8);
tempX = [-1.5 -1]*15.44;
tempY = [3300 3300];
plot(tempX, tempY, 'Color', 'k', 'LineWidth', 2);
text(-1.25*15.44,3300,sprintf('500 ms.'), 'VerticalAlignment', 'top','FontSize',8);
ax = gca;
print(gcf,'-dpng','-r300',['fig1b_AchTraceSamplewithLick'])
print(gcf,'-depsc2',['fig1b_AchTraceSamplewithLick'])
ax.OuterPosition = [0.1 0.1 0.9 0.9];