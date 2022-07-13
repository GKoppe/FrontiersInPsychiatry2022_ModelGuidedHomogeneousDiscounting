function maxL(mname,par0, lb,ub,pati)
%maximize log likelihood


[~, modelname]=fileparts(mname(1:end-1));
mno=str2num(modelname(3));

version='_v01';
pato=[mname 'MLE\'];
if ~isdir(pato),    mkdir(pato); end

dum1=strcat(pati,'*.mat');
files1=dir(dum1);
files=[files1];
[nFiles, ~]=size(files);

options = optimset('Display','off','MaxFunEvals',500,...
    'TolFun',1e-06,...
    'Algorithm','interior-point');

parInit=par0;

%pooli=parpool('local',12); %for parallel computing
%par
for i=1:nFiles
    filename=files(i).name;
    dat=load([pati filename]);
    
    vpn=dat.vp;
    
    tasklabs={'A','B'};
    condlabs={'reward','loss'};
    for itask=1:2 %A/B
        for icond=1:2 %reward/loss
            data=dat.mtx;
            taskname=tasklabs{itask};
            condname=condlabs{icond};
            %codes=dat.mtxcodes;
            
            ind=data(:,7)==icond & data(:,8)==itask; %1=reward, 2=loss (condition); 1=A, 2=B (task)
            data=data(ind,:);
                     
            index_immOutcome=1;
            index_delOutcome=2;
            index_delay=3;
            index_choice=4;
            indexes=[index_immOutcome index_delOutcome index_delay index_choice];
            data=data(:,indexes);
            
            %in case of corrupted data store nans
            ind=sum(isnan(data(:,1)));
            if sum(ind)>0
                vpname=[modelname '_' num2str(vpn)];
                npars=nan;
                x=struct('model',vpname);
                x.model_no=mno;
                x.winpar=nan;
                x.winparnames={'beta','kappa'};
                x.LL=nan;
                x.npar=npars;
                x.allestimates=nan;
                x.estimationoptions=options;
                x.ub=ub;
                x.lb=lb;
                x.pathdata=pati;
                x.pathmodel=pwd;
                x.pathoutput=pato;
                x.info.vp=vpn;
                x.info.dat=dat;
                x.task=itask;
                x.cond=icond;
                x.data=data;
                filename=[pato vpname '_' taskname '_' condname '.mat'];
                save(filename, 'x');
                
                continue
            else
                %     keyboard
                %     p=[.1 .1];
                %     tmp= getLL(p,data)
                
                %%
                
                Mtx=ones(1,10)*-10000;
                zsp=zeros(1,1+size(parInit,2)*2);
                A=[];B=[];Aeq=[]; Beq=[];
                for j = 1:size(parInit,1) %loop through init conditions
                    par0=parInit(j,:);
                    try
                        p=fmincon(@(p) -getLL(p,data),par0,A,B,Aeq,Beq,lb,ub); %maximize logL
                    catch
                    %    keyboard
                    end
                    l=getLL(p,data);
                    disp(['Estimated par:' num2str(p) ' LL:' num2str(l)])
                    tmp=[ par0 p l];
                    
                    if  l>Mtx(end), Mtx=tmp; end
                    zsp=[zsp; tmp];
                end
                [~,ind]=sort(zsp(:,end),'descend'); zsp=zsp(ind,:);
                zsp(1,:)=[];
                %     keyboard
                %     p=zsp(1,4:5);
                %     [l, Vs, qs, L]=getLL(p,data);
                
                %     figure; hold on;
                %     subplot(1,2,1); hold on
                %     plot(Vs,'r');
                %     plot(qs,'g');
                %     subplot(1,2,2); hold on
                %     plot(L,'b')
                %     keyboard
                
                %save all info to mat-file
                %             vpname=[modelname '_' num2str(vpn) version];
                vpname=[modelname '_' num2str(vpn)];
                npars=size(parInit,2);
                x=struct('model',vpname);
                x.model_no=mno;
                x.winpar=Mtx(1,(npars+1):(2*npars));
                x.winparnames={'beta','kappa'};
                x.LL=Mtx(1,end);
                x.npar=npars;
                x.allestimates=zsp;
                x.estimationoptions=options;
                x.ub=ub;
                x.lb=lb;
                x.pathdata=pati;
                x.pathmodel=pwd;
                x.pathoutput=pato;
                x.info.vp=vpn;
                x.info.dat=dat;
                x.task=itask;
                x.cond=icond;
                x.data=data;
                %            varname=pareval(vpname,x);
                %             parsave([pato vpname '_' taskname '_' condname '.mat'], varname);
                filename=[pato vpname '_' taskname '_' condname '.mat'];
                save(filename, 'x');
            end
            clear x data tmp Mtx zsp
        end
    end
end
%delete(pooli)
