clear all; close all; clc
addpath(pwd)

%% load results
load_behavioral_results

%% rearrange results as necessary
NA=numel(Arew_pc_imm)+numel(Aloss_pc_imm);
NB=numel(Brew_pc_imm)+numel(Bloss_pc_imm);
task=[ones(1,NA) ones(1,NB)*2]';
cond=[ones(1,numel(Arew_pc_imm)) ones(1,numel(Aloss_pc_imm))*2,...
    ones(1,numel(Brew_pc_imm)) ones(1,numel(Bloss_pc_imm))*2]';
imm=[Arew_pc_imm; Aloss_pc_imm; Brew_pc_imm ; Bloss_pc_imm];
res=[repmat(batch,4,1) task cond imm];
  
%% filter experiment
ind=res(:,1)<3;
res=res(ind,:);
      
%% plot discounting
h1=figure('color','white'); hold on; box on
grey=[.8 .8 .8];
lw=2; ms=6;
n=1;
xlabs={'run A','run B'};
for icond=1:1 %reward/loss
    for itask=1:2 %A/B
        if itask==1
            cFace=getColor('A');
        else
            cFace=getColor('reward');
        end
        c=cFace;
        
        y=res;
        ind=y(:,2)==itask & y(:,3)==icond;
        y=y(ind,4);
        errorbar(n, nanmean(y),nanstd(y)/sqrt(length(y)),'.','color',c,'LineWidth',lw);
        bar(n, nanmean(y),'FaceColor',cFace,'EdgeColor',c,'LineWidth',lw);
        n=n+1; 
    end
end
xlim([0 3])
ylim([0 100])
text(1.4,45,'*','FontSize',15)
ylabel('% discounted')
set(gca,'XTick',1:2,'XTickLabel',xlabs);
set(h1,'Position', [150 200 150 200])
title('Reward')
xtickangle(30)

%%

h2=figure('color','white'); hold on; box on
n=1;
xlabs={'run A','run B'};
for icond=2:2 %loss
    for itask=1:2 %A/B
        if itask==1
            cFace=getColor('A');
        else
            cFace=getColor('loss');
        end
        c=cFace;
        
        y=res;
        ind=y(:,2)==itask & y(:,3)==icond;
        y=100-y(ind,4);

        errorbar(n, nanmean(y),nanstd(y)/sqrt(length(y)),'.','color',c,'LineWidth',lw);
        bar(n, nanmean(y),'FaceColor',cFace,'EdgeColor',c,'LineWidth',lw);
        n=n+1; 
    end
end
xlim([0 3])
ylabel('% discounted')
set(gca,'XTick',1:2,'XTickLabel',xlabs);
set(h2,'Position', [150 200 150 200])
title('Loss')
xtickangle(30)
text(1.4,30,'*','FontSize',15)
ylim([0 100])

keyboard
