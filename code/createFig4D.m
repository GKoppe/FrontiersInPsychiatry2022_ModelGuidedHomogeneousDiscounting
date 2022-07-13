%%
clear all; close all; clc
load_behavioral_results

%%
filtVP=true;
ibatch=4;
iplot=1;
l=1;
for icond=1:2
    h2=figure('color','white'); hold on; box on
    for ibatch=4
        
        filtVP=false;
        filttaskA=false; %if true, ana task A
        filtreward=true; %if true, ana reward
        filtloss=false; %if true, ana loss
        
        lw=1; ms=6;
        
        if icond==1
            filtreward=true;
            filtloss=false;
        elseif icond==2
            filtloss=true;
            filtreward=false;
        end
        
        if filtreward & ~filttaskA %run B-reward
            res=[batch Brew_pc_imm_p3./100 Brew_pc_imm_p5./100 Brew_pc_imm_p7./100 Brew_pc_imm./100];
        end
        if filtloss & ~filttaskA %run B-reward
            res=[batch Bloss_pc_imm_p3./100 Bloss_pc_imm_p5./100 Bloss_pc_imm_p7./100 Bloss_pc_imm./100];
        end
        ind=res(:,1)==ibatch;
        res=res(ind,:);
        if filtVP
            filt=res(:,5)>.95 | res(:,5)<.05;
            res(filt,:)=nan;
        end      
        ind=isnan(res(:,1));
        res(ind,:)=[];
        
        
        y=res(:,2:4);
        x=1:3;
 
        figure(h2)
        hold on; box on
        
        c=colormap('gray'); 
        for j=1:size(y,1)
            plot(x,y(j,:),'-','color',c(j,:),'LineWidth',lw,'MarkerSize',ms)
        end
        xlim([0.5 3.5])
        xlab={'.3','.5','.7'};
        set(gca,'XTick',x,'XTickLabel',xlab, 'YTick',[0 .3 .5 .7 1])
        ylabel('rel. freq. immediate')
        xlabel('$p_1$')
        ylim([-.1 1.1])
        set(h2,'Position',[150 30 180 200])
        
        grey=[.8 .8 .8];
        plot(0:4,ones(1,5)*.3,'-','color',grey)
        plot(0:4,ones(1,5)*.5,'-','color',grey)
        plot(0:4,ones(1,5)*.7,'-','color',grey)
        l=l+1;
        
        iplot=iplot+1;
    end
end


