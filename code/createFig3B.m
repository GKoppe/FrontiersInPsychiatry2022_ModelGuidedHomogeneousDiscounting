%%
clear all; close all; clc
set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

load_behavioral_results
%%

filtVP=true;
for icond=1:2
    h1=figure('color','white'); hold on; box on
    lw=2; ms=6;
    
    for iexp=1:2
        if icond==1 & iexp==1
            res=[batch Arew_pc_imm];
            c=getColor('A');
        end
        if icond==2 & iexp==1
            res=[batch Aloss_pc_imm];
            c=getColor('A')
        end
        if icond==1 & iexp==2
            res=[batch Arew_pc_imm];
            c=getColor('reward');
        end
        if icond==2 & iexp==2
            res=[batch Aloss_pc_imm];
            c=getColor('loss')
        end
       
        if iexp==1
            ind=res(:,1)<3;
        elseif iexp==2
            ind=res(:,1)==3;
        end
        res=res(ind,:);
        
        %filter outlying VP
        if filtVP
            filt=res(:,2)>95 | res(:,2)<5;
            res(filt,:)=nan;
        end
        
        ind=isnan(res(:,1));
        res(ind,:)=[];
        
        figure(h1);
        ss=.1;
        bins=[0:ss:1];
        
        x=res(:,2)/100;
        x(x==0)=.0001; x(x==1)=.9999; %to make sure x=1 is in last bin
        vals=histc(x,bins);
        vals=vals/sum(vals);
        
        if icond==1
            yl=.5;
        elseif icond==2
            yl=.8;
        end
        %yl=1;%max(vals)+1;
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
        ylim([0 yl]);  xlim([0 1])
        set(gca,'XTick',bins(1:2:end),'XTickLabel',bins(1:2:end))                
        set(h1,'Position',[150 30 200 150])   
    end
end

keyboard

