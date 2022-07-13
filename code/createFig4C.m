%%
clear all; close all; clc
load_behavioral_results
%%


filtVP=false;
for icond=1:2
    h1=figure('color','white'); hold on; box on
    lw=2; ms=6;
    
    for iexp=1:2
        for iprob=1:3   
            if icond==1 & iprob==1
                res=[batch Brew_pc_imm_p3];
                c=getColor('rewardp3'); sp=.3;
            end
            if icond==2 & iprob==1
                res=[batch Bloss_pc_imm_p3];
                c=getColor('lossp3'); sp=.3;
            end
            if icond==1 & iprob==2
                res=[batch Brew_pc_imm_p5];
                c=getColor('rewardp5'); sp=.5;
            end
            if icond==2 & iprob==2
                res=[batch Bloss_pc_imm_p5];
                c=getColor('lossp5'); sp=.5;
            end
            if icond==1 & iprob==3
                res=[batch Brew_pc_imm_p7];
                c=getColor('rewardp7'); sp=.7;
            end
            if icond==2 & iprob==3
                res=[batch Bloss_pc_imm_p7];
                c=getColor('lossp7'); sp=.7;
            end
            if iexp==1
                c=getColor('A');
            end
            
            if iexp==1
                ind=res(:,1)==3;
            elseif iexp==2
                ind=res(:,1)==4;
            end
            res=res(ind,:);
            
            %filter outlying VP?
            if filtVP
                filt=res(:,2)>95 | res(:,2)<5;
                res(filt,:)=nan;
            end
            
            ind=isnan(res(:,1));
            res(ind,:)=[];
            
            figure(h1);
            subplot(3,1,iprob); hold on; box on
            ss=.1;
            bins=[0:ss:1];
            
            x=res(:,2)/100;
            x(x==0)=.0001; x(x==1)=.9999; %to make sure x=1 is in last bin
            vals=histc(x,bins);
            vals=vals/sum(vals);
            
            if icond==1
                yl=.4;
            elseif icond==2
                yl=.6;
            end
            grey=[.7 .7 .7];
            SP=sp; line([SP SP],get(gca,'Ylim'),'Color',grey,'LineWidth',lw)
            stairs(bins,vals,'color',c,'LineWidth',lw)
            alphai=.9;
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
            
            ylabel('rel. # subjects'); xlabel('rel. freq. immediate');
            ylim([0 yl]);  xlim([0 1])
            set(gca,'XTick',bins(1:2:end),'XTickLabel',bins(1:2:end))
            set(h1,'Position',[150 30 250 550])
            
        end
    end
end

keyboard

