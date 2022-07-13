%%
clear all; close all; clc
load_behavioral_results
%%

ibatch=4;
filttaskA=false; %if true, ana task A
filtreward=true; %if true, ana reward
filtloss=false; %if true, ana loss

h1=figure('color','white'); hold on; box on
lw=2; ms=6;

for icond=1:2
    if icond==1
        filtreward=true;
        filtloss=false;
    elseif icond==2
        filtloss=true;
        filtreward=false;
    end
    
    if filtreward & ~filttaskA %run B-reward
        res=[batch Brew_rt_p3 Brew_rt_p5 Brew_rt_p7 Brew_rt];
    end
    if filtloss & ~filttaskA %run B-reward
        res=[batch Bloss_rt_p3 Bloss_rt_p5 Bloss_rt_p7 Bloss_rt];
    end
    filtvar=[Brew_pc_imm Bloss_pc_imm];
    
    ind=res(:,1)==ibatch;
    res=res(ind,:);
    ind=isnan(res(:,1));
    res(ind,:)=[];
    
    if filtreward
        c1=getColor('rewardp3');
        c2=getColor('rewardp5');
        c3=getColor('rewardp7');
        colors=[c1; c2; c3];
    elseif filtloss
        c1=getColor('lossp3');
        c2=getColor('lossp5');
        c3=getColor('lossp7');
        colors=[c1; c2; c3];
    else
        colors=[204 204 204; 150 150 150 ; 99 99 99]/256;
    end
    c=colors(1,:);
    y=res(:,2:4);
    x=1:3;
    if filtloss
        x=x+.1;
    end
    xlab={'.3','.5','.7'};
    errorbar(x,nanmean(y),nanstd(y)/sqrt(length(y)),'.','color',c,'LineWidth',lw)
    plot(x,nanmean(y),'s','color',c,'LineWidth',lw,'MarkerFaceColor',c,'MarkerSize',ms)
    xlim([0.5 3.5])
    set(gca,'XTick',x,'XTickLabel',xlab, 'YTick',[0:500:3000])
    ylabel('RT')
    xlabel('$p_1$')
    set(h1,'Position',[150 30 350 250])
end

