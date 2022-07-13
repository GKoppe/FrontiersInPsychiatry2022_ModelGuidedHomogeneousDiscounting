%ana data of online task in B08
%10/08/2021 GKoppe
clear all; close all; clc

pato='C:\Users\georg\Desktop\TRR265\B08\OnlineTask\figs\';

hyperbolicmodel=true;
discountfactor=true;

if hyperbolicmodel
    %%
    %% Setup the Import Options
    opts = spreadsheetImportOptions("NumVariables", 14);
    
    % Specify sheet and range
    opts.Sheet = "Tabelle1";
    opts.DataRange = "A2:N199";
    
    % Specify column names and types
    opts.VariableNames = ["vp", "batch", "runArew_LL", "runArew_beta", "runArew_kappa", "runAloss_LL", "runAloss_beta", "runAloss_kappa", "runBrew_LL", "runBrew_beta", "runBrew_kappa", "runBloss_LL", "runBloss_beta", "runBloss_kappa"];
    opts.SelectedVariableNames = ["vp", "batch", "runArew_LL", "runArew_beta", "runArew_kappa", "runAloss_LL", "runAloss_beta", "runAloss_kappa", "runBrew_LL", "runBrew_beta", "runBrew_kappa", "runBloss_LL", "runBloss_beta", "runBloss_kappa"];
    opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    opts = setvaropts(opts, 1, "WhitespaceRule", "preserve");
    opts = setvaropts(opts, 1, "EmptyFieldRule", "auto");
    
    % Import the data
    cd ..
    tabname=[pwd '\data\m01a_ModelResults.xlsx'];
    tab = readtable(tabname, opts, "UseExcel", false);
    
    
else 
    %see separate code
end

varlabs=opts.VariableNames;
nvars=length(varlabs);
clear opts

for i=1:nvars
    eval([varlabs{i} '=table2array(tab(:,i));'])
end
% Clear temporary variables
clear opts
%%

h1=figure('color','white');

t=30;

ind=batch<5;
x=runArew_kappa(ind);
y=runBrew_kappa(ind);
try  s1=runArew_s(ind); end
try  s2=runBrew_s(ind); end
if discountfactor
    if hyperbolicmodel
        x=1./(1+x.*t); y=1./(1+y.*t); 
    else
        x=1./(1+x.*t.^s1); y=1./(1+y.*t.^s2);
    end
else
    out=x>thresh | y>thresh  | isnan(x) |isnan(y); x(out)=[]; y(out)=[];
end
[r,p]=corrcoef(x,y);
txt=sprintf('r=%2.2f, p=%2.4f',r(1,2),p(1,2));

subplot(1,4,1); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('A-discountf rew'); ylabel('B-discountf rew')

x=runAloss_kappa(ind);
y=runBloss_kappa(ind);
try  s1=runAloss_s(ind); end
try  s2=runBloss_s(ind); end
if discountfactor
    if hyperbolicmodel
        x=1./(1+x*t); y=1./(1+y*t);
    else
        x=1./(1+x.*t.^s1); y=1./(1+y.*t.^s2);
    end
else
    out=x>thresh | y>thresh  | isnan(x) |isnan(y); x(out)=[]; y(out)=[];
end
[r,p]=corrcoef(x,y);
txt=sprintf('r=%2.2f, p=%2.4f',r(1,2),p(1,2));

subplot(1,4,2); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('A-discountf loss'); ylabel('B-discountf loss')


x=runArew_kappa(ind);
y=runAloss_kappa(ind);
try  s1=runArew_s(ind); end
try  s2=runAloss_s(ind); end
if discountfactor
    if hyperbolicmodel
        x=1./(1+x*t); y=1./(1+y*t);
    else
        x=1./(1+x.*t.^s1); y=1./(1+y.*t.^s2);
    end
else
    out=x>thresh | y>thresh  | isnan(x) |isnan(y); x(out)=[]; y(out)=[];
end
[r,p]=corrcoef(x,y);
txt=sprintf('r=%2.2f, p=%2.4f',r(1,2),p(1,2));

subplot(1,4,3); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('A-discountf rew'); ylabel('A-discountf loss')


x=runBrew_kappa(ind);
y=runBloss_kappa(ind);
try  s1=runBrew_s(ind); end
try  s2=runBloss_s(ind); end
if discountfactor
    if hyperbolicmodel
        x=1./(1+x*t); y=1./(1+y*t);
    else
        x=1./(1+x.*t.^s1); y=1./(1+y.*t.^s2);
    end
else
    out=x>thresh | y>thresh  | isnan(x) |isnan(y); x(out)=[]; y(out)=[];
end
[r,p]=corrcoef(x,y);
txt=sprintf('r=%2.2f, p=%2.4f',r(1,2),p(1,2));

subplot(1,4,4); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('B-discountf rew'); ylabel('B-discountf loss')


set(h1,'Position',[200 200 1100 180])


