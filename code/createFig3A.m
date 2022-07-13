%%
clear all; close all; clc
load_behavioral_results

%% rearrange results as necessary
NA=numel(Arew_pc_imm)+numel(Aloss_pc_imm);
NB=numel(Brew_pc_imm)+numel(Bloss_pc_imm);
task=[ones(1,NA) ones(1,NB)*2]';
cond=[ones(1,numel(Arew_pc_imm)) ones(1,numel(Aloss_pc_imm))*2,...
    ones(1,numel(Brew_pc_imm)) ones(1,numel(Bloss_pc_imm))*2]';
imm=[Arew_pc_imm; Aloss_pc_imm; Brew_pc_imm ; Bloss_pc_imm];
res=[repmat(batch,4,1) task cond imm];


%% plot discounting
h1=figure('color','white'); hold on; box on

lw=2; ms=6;
n=1;
xlabs={'Exp1-A','Exp2-A'};
icond=1; %reward
for iexp=1:2 %experiments
    y=res;
    if iexp==1
        cFace=getColor('A');
        ind=y(:,1)<3;
    else
        cFace=getColor('reward');
        ind=y(:,1)==3;
    end
    y=y(ind,:);
    c=cFace;
    
    ind=y(:,2)==1 & y(:,3)==icond;
    y=y(ind,4);
    errorbar(n, nanmean(y),nanstd(y)/sqrt(length(y)),'.','color',c,'LineWidth',lw);
    bar(n, nanmean(y),'FaceColor',cFace,'EdgeColor',c,'LineWidth',lw);
    n=n+1;
end
xlim([0 3])
ylim([0 100])
text(1.4,55,'*','FontSize',15)
ylabel('% discounted')
set(gca,'XTick',1:2,'XTickLabel',xlabs);
set(h1,'Position', [150 200 150 200])
title('Reward')
xtickangle(30)

%%
h1=figure('color','white'); hold on; box on
n=1;
icond=2; %reward
for iexp=1:2 %experiments
    y=res;
    if iexp==1
        cFace=getColor('A');
        ind=y(:,1)<3;
    else
        cFace=getColor('loss');
        ind=y(:,1)==3;
    end
    y=y(ind,:);
    c=cFace;
    
    ind=y(:,2)==1 & y(:,3)==icond;
    y=100-y(ind,4);
    errorbar(n, nanmean(y),nanstd(y)/sqrt(length(y)),'.','color',c,'LineWidth',lw);
    bar(n, nanmean(y),'FaceColor',cFace,'EdgeColor',c,'LineWidth',lw);
    n=n+1;
end
xlim([0 3])
ylim([0 100])
text(1.4,40,'*','FontSize',15)
ylabel('% discounted')
set(gca,'XTick',1:2,'XTickLabel',xlabs);
set(h1,'Position', [150 200 150 200])
title('Loss')
xtickangle(30)

