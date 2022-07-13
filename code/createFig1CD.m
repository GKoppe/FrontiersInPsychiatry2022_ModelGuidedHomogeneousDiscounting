clear all; close all; clc

discountfun=@(kappa,delay) 1./(1+kappa.*delay);
probfun=@(V1,V2,beta) 1/(1+exp(beta.*(V2-V1)));
condition=@(Vdel,p_imm,beta)  Vdel+log(p_imm/(1-p_imm))/beta;

k1=.01;
k2=.001;
betas=[.1 .4];
ps=[.3 .5 .7];
D=[7, 30, 90, 180, 365];
Ds=0:365;
V1=-100:.1:100; %=r1
r2=50;
Di=90;

c1=[.5 .5 .5];
c2=[0 0 0 ];
col=colormap('hsv');
col=col(1:5:end,:);

curve1=discountfun(k1,Ds);
curve2=discountfun(k2,Ds);


%% figure 3D
h1=figure('color','white');  hold on; box on;
iplot=1;
fs=10; ms=4; lw=2;
nrow=1; ncol=3;

subplot(nrow, ncol, iplot); hold on; box on
beta=betas(1);

V2=discountfun(k2,Di)*r2;
probfun=@(V1,V2,beta) 1./(1+exp(beta.*(V2-V1)));
pa=probfun(V1,V2,beta);
l1=plot(V1-V2,pa,'LineWidth',lw,'color','r');

beta=betas(2);
V2=discountfun(k2,Di)*r2;
probfun=@(V1,V2,beta) 1./(1+exp(beta.*(V2-V1)));
pa=probfun(V1,V2,beta);
l2=plot(V1-V2,pa,'LineWidth',lw,'color','b');

ylabel('p(a_{imm})','FontSize',fs); xlabel('V_{imm}-V_{del}','FontSize',fs)
set(gca,'FontSize',fs);
xlim([-10 10])
legend([l1 l2],{'$\beta=.1$','$\beta=.4$'},'Interpreter','Latex','Box','off','Location','Best');
iplot=iplot+1;

for ibeta=1:2 %for two theoretical betas
    beta=betas(ibeta);
  
    subplot(nrow,ncol,iplot);  hold on; box on;
    l1=plot(Ds,curve1*r2,'-','color',c1,'LineWidth',lw);
    l2=plot(Ds,curve2*r2,'-','color',c2,'LineWidth',lw);
    ylabel('V(r)','FontSize',fs); xlabel('delay','FontSize',fs)
    xlim([0 max(D)])
    
    for ik=1:2 %for 2 theoretical kappas
        switch ik
            case 1
                k=k1;
            case 2
                k=k2;
        end
        
        for l=1:length(ps) %for all immediate probs        
            for j=1:length(D) %for all delays
                delay=D(j);
                rdel=r2;
                Vdel=discountfun(k,delay)*rdel;
                
                p_imm=ps(l);
                c=col(l,:);
                r1=condition(Vdel,p_imm,beta);
                Vimm=r1;
                
                txt=sprintf('p=%1.1f, D=%d, r_2=%2.0f, r_1=%2.2f, Vdel - Vimm=%2.3f',p_imm,delay,rdel,r1,Vdel-Vimm);
                disp(txt)
                subplot(nrow,ncol,iplot); hold on; box on
                if ibeta==1
                    title('$\beta=.1$','Interpreter','Latex');
                elseif ibeta==2
                    title('$\beta=.4$','Interpreter','Latex');
                end
                plot(delay,Vimm,'o','color',c,'MarkerFaceColor',c,'LineWidth',lw,'MarkerSize',ms);
            end
            
        end
    end
    set(gca,'XTick',D,'XTickLabel',D,'YTick',[0:10:r2+10]);
    ylim([0 r2+10])
    set(gca,'FontSize',fs)
    iplot=iplot+1;
end
set(h1,'Position',[200 200 900 200])

