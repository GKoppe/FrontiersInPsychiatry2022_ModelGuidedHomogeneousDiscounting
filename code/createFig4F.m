%%
clear all; close all; clc
set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

addpath(pwd)

model={'m01a','m01b','m01c','m01d','m01e','m01f','m01g'};
modellabs={'hyperbolic','exponential','constant-sensitivity','hyperboloid modified',...
    'quasi-hyperbolic','hyperboloid','double-exponential'};
index=[1 2 5 6 4 7 3];
model=model(index);
modellabs=modellabs(index);

errortype=1; %1= mean p(a|s), 2=weighted response accuracy

pati=[pwd '\rlmodels\'];

nmodels=length(model);
for imodel=1:nmodels
    folder=[pati model{imodel} '\MLE\_batch4\'];
    files=dir([folder '*.mat']);
    nfiles=size(files,1);
    
    for i=1:nfiles
        filename=[folder files(i).name];
        load(filename);
        task=x.task;
        cond=x.cond;
        LL=x.LL;
        par=x.winpar;
        vps{i}=x.info.vp;
        batch=x.info.dat.batch;
        
        if isnan(par)
            disp(filename)
        end
        
        %load data from task to predict on
        switch task
            case 1 %A
                run='_B_';  %predict on...
            case 2 %B
                run='_A_';
        end
        switch cond
            case 1 %reward parameter
                tasklab='reward'; %predict on...
            case 2 %loss parameter
                tasklab='loss';
        end
        txt=[model{imodel} '_' vps{i} run tasklab '.mat'];
        
        filename2=[folder txt];
        p=load(filename2);
        data=p.x.data;
        
        cd([pati model{imodel} ])
        
        try
            [logL, L, p]=getLL(par, data);
            
            if errortype ==1
                outlier=isinf(p)|isnan(p);
                tmp=sum(outlier);
                if tmp>0
                    disp(filename)
                end
                p(outlier)=[];
                noutlier(i,imodel)=sum(outlier);
                p_mean(i,imodel)=mean(p);
                res(i,:,imodel)=[i task cond mean(p)];
            
            elseif errortype==2
                % response weighted prediction
                ind=data(:,4)==0;%omissions
                data(ind,:)=[];  %omit omissions
                a=data(:,4);
                p_mean1=nanmean(p(a==1));
                p_mean2=nanmean(p(a==2));
                if isempty(p_mean1) | isempty(p_mean2)
                    res(i,:,imodel)=[i task cond nan];
                else
                    res(i,:,imodel)=[i task cond (p_mean1+p_mean2)/2];
                end
            end
            
        catch
            noutlier(i,imodel)=nan;
            p_mean(i,imodel)=nan;
            res(i,:,imodel)=[i task cond nan];
        end
        clear LL par task cond filename* data p x p_m*
    end
end

y=[isnan(res(:,4,1)) isnan(res(:,4,2))];
y=sum(y')';
y=y>0;
res(y,:,:)=[];

%% plot
h1=figure('color','white'); hold on; box on
lw=2; ms=4;
grey=[.5 .5 .5];

col=getColor('models')

n=1;
xlabs={'A predict B-reward','A predicts B-loss','B predicts A-reward','B predicts A-loss'};
for itask=1:2 %A/B
    for icond=1:2 %reward/loss
        x=1; xx=0;
        for imodel=1:nmodels
            y=res(:,:,imodel);
            ind=y(:,2)==itask & y(:,3)==icond;
            y=y(ind,4);
            y(isinf(y))=[];
            
            c=col(x,:);
            errorbar(n+xx, nanmean(y),nanstd(y)/sqrt(length(y)),'.','color',c,'LineWidth',lw);
            l(imodel)=plot(n+xx, nanmean(y),'s','color',c,'MarkerSize',ms,'LineWidth',lw);
            
            x=x+1;
            xx=xx+.05;
        end
        n=n+1;
    end
end
xlim([0 5])
ylim([0.5 1])
plot(0:5,ones(1,6)*.5,'-k')
legend(l,modellabs,'Location','Best','Box','off')

if errortype==1
    ylabel('$\hat{p}_j$')
else
    ylabel('balanced $\hat{p}_j$')
end
set(gca,'XTick',[1.2 2.2 3.3 4.4],'XTickLabel',xlabs);
set(h1,'Position', [150 200 250 200])
xtickangle(30)

%averaged over A and B
h2=figure('color','white'); hold on; box on
n=1;
for icond=1:2 %reward/loss
    x=1; xx=0;
    for imodel=1:nmodels
        y=res(:,:,imodel);
        ind=y(:,3)==icond;
        y=y(ind,4);
        y(isinf(y))=[];
                
        condition={'reward','loss'};
        txt=sprintf('%s %s %2.3f', modellabs{imodel}, condition{icond},nanmean(y));
        disp(txt)
        
        c=col(x,:);
        errorbar(n+xx, nanmean(y),nanstd(y)/sqrt(length(y)),'.','color',c,'LineWidth',lw);
        l(imodel)=plot(n+xx, nanmean(y),'s','color',c,'MarkerSize',ms,'LineWidth',lw);
        
        x=x+1;
        xx=xx+.05;
    end
    n=n+1;
end
xlim([0.7 2.5])
ylim([0.5 1])
plot(0:5,ones(1,6)*.5,'-k')
legend(l,modellabs,'Location','Best','Box','off')

if errortype==1
    ylabel('$\hat{p}_j$')
else
    ylabel('balanced $\hat{p}_j$')
end

xlabs={'reward','loss'}
set(gca,'XTick',[1.2 2.2 ],'XTickLabel',xlabs);
set(h2,'Position', [150 200 250 300])
xtickangle(30)
%%

