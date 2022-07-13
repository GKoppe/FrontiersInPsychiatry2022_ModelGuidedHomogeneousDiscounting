%%
clear all; close all; clc
set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

load_behavioral_results
%%
filttaskA=true; %if true, ana task A

for icond=1:2
    if icond==1
        filtreward=true; %if true, ana reward
        filtloss=false; %if true, ana loss
    elseif icond==2
        filtreward=false; %if true, ana reward
        filtloss=true; %if true, ana loss
    end
    h1=figure('color','white'); hold on; box on
    lw=2; ms=6;
    
    for irun=1:2
        
        if irun==1 & filtreward %run A-reward
            res=[batch Arew_pc_imm];
            c=getColor('A')
        end
        if irun==2 & filtreward %run B-reward
            res=[batch Brew_pc_imm];
            c=getColor('reward')
        end
        if irun==1 & filtloss %run A-loss
            res=[batch Aloss_pc_imm];
            c=getColor('A')
        end
        if irun==2 & filtloss %run B-loss
            res=[batch Bloss_pc_imm];
            c=getColor('loss')
        end
        
        ind=res(:,1)<3;
        res=res(ind,:);        
        ind=isnan(res(:,1));
        res(ind,:)=[];
        
        figure(h1);
        ss=.1;
        bins=[0:ss:1];
        
        x=res(:,2)/100;
        x(x==0)=.0001; x(x==1)=.9999; %to make sure x=1 is in last bin
        vals=histc(x,bins);
        vals=vals/sum(vals);
        
        if filtreward
            yl=.5;
        elseif filtloss
            yl=.8;
        end
        stairs(bins,vals,'color',c,'LineWidth',lw)
        alphai=.5;
        for j=1:length(bins)
            xb=bins(j);
            if j<length(bins)
                yb=bins(j+1);
            else
                yb=bins(j)+ss;
            end
            a=area([xb,yb],[vals(j) vals(j)],'FaceColor',c,'EdgeColor','none');
            a.FaceAlpha=alphai;
        end
        
        ylabel('rel. \# subjects'); xlabel('rel. freq. immediate');
        ylim([0 .8]);  xlim([0 1])
        set(gca,'XTick',bins(1:2:end),'XTickLabel',bins(1:2:end))
        set(h1,'Position',[150 30 200 150])       
    end
end
keyboard

