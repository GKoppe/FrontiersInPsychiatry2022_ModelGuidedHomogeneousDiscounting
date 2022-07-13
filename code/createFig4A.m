%%
clear all; close all; clc

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


%% separated for reward and loss
%% plot discounting
h1=figure('color','white'); hold on; box on
lw=2; ms=6;
n=1;
itask=1;
if itask==1
    xlabs={'Exp1-A','Exp2-A','Exp3-A'};
elseif itask==2
    xlabs={'Exp1-B','Exp2-B','Exp3-B'};
end
icond=1; %reward
for iexp=1:3 %experiments
    y=res;
    if iexp==1
        cFace=[0 0 0];
        ind=y(:,1)<3;
    elseif iexp==2
        cFace=getColor('A');
        ind=y(:,1)==3;
    elseif iexp==3
        cFace=getColor('reward');
        ind=y(:,1)==4;
    end
    y=y(ind,:);
    c=cFace;
    
    ind=y(:,2)==itask & y(:,3)==icond;
    
    %# individuals
    y=y(ind,4);
    y=y<5; %Anzahl Leute die in weniger 95% der Fälle nicht non-discounted haben
    y=y/numel(y);
    bar(n, nansum(y),'FaceColor',cFace,'EdgeColor',c,'LineWidth',lw);
    n=n+1;
end
xlim([0 4])
ylim([0 1])
ylabel('rel. # non discounter')
set(gca,'XTick',1:3,'XTickLabel',xlabs);
set(h1,'Position', [150 200 150 200])
title('Reward')
xtickangle(30)


%%
h1=figure('color','white'); hold on; box on
n=1;
icond=2; %reward
for iexp=1:3 %experiments
    y=res;
    if iexp==1
        cFace=[0 0 0];
        ind=y(:,1)<3;
    elseif iexp==2
        cFace=getColor('A');
        ind=y(:,1)==3;
    elseif iexp==3
        cFace=getColor('loss');
        ind=y(:,1)==4;
    end
    y=y(ind,:);
    c=cFace;
    
    ind=y(:,2)==itask & y(:,3)==icond;
    y=y(ind,4);
    y=y>95; 
    sum(y)
    y=y/numel(y);
    bar(n, nansum(y),'FaceColor',cFace,'EdgeColor',c,'LineWidth',lw);
    n=n+1;
end
xlim([0 4])
ylim([0 1])
ylabel('rel. # non discounter')
set(gca,'XTick',1:3,'XTickLabel',xlabs);
set(h1,'Position', [150 200 150 200])
title('Loss')
xtickangle(30)

keyboard