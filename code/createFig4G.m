%theoretical differences
clear all; close all; clc

%delays=[2 7 14 30 90 180 365 365*3];
delays=0:365;
k=.001;
ss=[.5 .75 1];

discountfun1=@(kappa,delay) 1./(1+kappa.*delay);
discountfun2=@(kappa,delay,s) 1./(1+kappa.*delay.^s);

h1=figure('color','white'); hold on; box on;
lw=2;

cols=colormap('autumn');
cols=cols([1 25 50],:);
r2=10; 
for i=1:length(ss)
    s=ss(i);
    V2=discountfun2(k,delays,s)*r2;
    
    c=cols(i,:);
    l(i)= plot(delays,V2,'color',c,'LineWidth',lw);
    
end
legend(l,{'s=.5','s=.75','s=1 (hyperbolic)'},'box','off','Location','Best')
xlabel('days');
ylabel('discounted value');
xlim([min(delays) max(delays)])

set(h1,'Position',[200 200 250 150])



