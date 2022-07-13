%%
clear all; close all; clc
addpath(pwd)
load_behavioral_results
%%

filtVP=true;
filttaskA=false; %if true, ana task A

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
        res=[batch Brew_pc_imm_p3./100 Brew_pc_imm_p5./100 Brew_pc_imm_p7./100 Brew_pc_imm./100];
        filtvar=Arew_pc_imm./100;
    end
    if filtloss & ~filttaskA %run B-reward
        res=[batch Bloss_pc_imm_p3./100 Bloss_pc_imm_p5./100 Bloss_pc_imm_p7./100 Bloss_pc_imm./100];
        filtvar=Aloss_pc_imm./100;
    end
    ind=res(:,1)==1 | res(:,1)==2;
    res=res(ind,:);
    filtvar=filtvar(ind);
    
    %filter outliers
    if filtVP
        filt=filtvar>.95 | filtvar <.05;
        sum(filt)
        res(filt,:)=nan;
    end
    
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
    errorbar(x,mean(y),std(y),'.','color',c,'LineWidth',lw)
    plot(x,mean(y),'s','color',c,'LineWidth',lw,'MarkerFaceColor',c,'MarkerSize',ms)
    xlim([0.5 3.5])
    set(gca,'XTick',x,'XTickLabel',xlab, 'YTick',[0 .3 .5 .7 1])
    ylabel('rel. freq. immediate')
    xlabel('$p_1$')
    ylim([-.1 1.1])
    set(h1,'Position',[150 30 350 250])
    
    grey=[.8 .8 .8];
    plot(0:4,ones(1,5)*.3,'-','color',grey)
    plot(0:4,ones(1,5)*.5,'-','color',grey)
    plot(0:4,ones(1,5)*.7,'-','color',grey)
end

