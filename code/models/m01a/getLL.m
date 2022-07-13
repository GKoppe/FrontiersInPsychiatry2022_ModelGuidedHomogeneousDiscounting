function [logL, L, p, p_imm]= getLL(pars,mtx)
%computes log-likelihood

%pars=beta kappa
%mtx=actions,outcome_imm, outcome_del, delay
%actions need to be handed over as discounted/non-discounted actions
ind=mtx(:,4)==0;%omissions
mtx(ind,:)=[];  %omit omissions
outcome_imm=mtx(:,1);
outcome_del=mtx(:,2);
delay=mtx(:,3);
actions=mtx(:,4);

%define discounting function
discountfun=@(kappa,delay) 1./(1+kappa.*delay);

%parameters
beta=pars(1);   %choice parameter
kappa=pars(2);  %discounting parameter

%model
V(:,1)=outcome_imm;           %values for immediate choice
V(:,2)=discountfun(kappa,delay).*outcome_del;     %values for delayed choice

%compute likelihood
T=length(actions);
for t=1:T    
    Vt=V(t,actions(t));
    V1=V(t,1);
    V2=V(t,2);
    
    Vmax=max(V1,V2);
    V1=V1-Vmax;
    V2=V2-Vmax;
    Vt=Vt-Vmax;
    
    ebV1=exp(beta*V1);
    ebV2=exp(beta*V2);
    
    L(t)=beta*Vt-log(sum(ebV1+ ebV2)); 
    p_imm(t)=ebV1/(ebV1+ebV2);
end
logL=sum(L);
p=exp(L);
L=exp(logL);
