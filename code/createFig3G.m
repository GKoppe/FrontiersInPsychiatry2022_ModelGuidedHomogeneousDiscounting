%%
%comments from the author:
%please note: this program reproduces Fig. 3G as portrayed in the article
%unfortunately, the data used to produce the figure is from experiment 3,
%not 2, and reflects an honest mistake made
%however, in all experiments (i.e. 1, 2, and 3) the s parameter is
%consistently lower in the loss condition (the statement made by the
%figure)
%in fact, this effect was even more prominent in experiment 1 and 2. Here, we 
%see lower average s during loss in both run A and run B, whereas in experiment 3, 
%we see it only in run B
%for questions, please contact georgia.koppe@zi-mannheim.de
%%
clear all; close all; clc
pati=['..\data\'];
filei='m01d_ModelResults.xlsx';
% import results
opts = spreadsheetImportOptions("NumVariables", 18);

% Specify sheet and range
opts.Sheet = "Tabelle1";
opts.DataRange = "A2:R199";

% Specify column names and types
opts.VariableNames = ["vp", "batch", "runArew_LL", "runArew_beta", "runArew_kappa", "runArew_s", "runAloss_LL", "runAloss_beta", "runAloss_kappa", "runAloss_s", "runBrew_LL", "runBrew_beta", "runBrew_kappa", "runBrew_s", "runBloss_LL", "runBloss_beta", "runBloss_kappa", "runBloss_s"];
opts.SelectedVariableNames = ["vp", "batch", "runArew_LL", "runArew_beta", "runArew_kappa", "runArew_s", "runAloss_LL", "runAloss_beta", "runAloss_kappa", "runAloss_s", "runBrew_LL", "runBrew_beta", "runBrew_kappa", "runBrew_s", "runBloss_LL", "runBloss_beta", "runBloss_kappa", "runBloss_s"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "WhitespaceRule", "preserve");
opts = setvaropts(opts, 1, "EmptyFieldRule", "auto");

% Import the data
tab = readtable([pati filei], opts, "UseExcel", false);

varlabs=opts.VariableNames;
nvars=length(varlabs);
clear opts

for i=1:nvars
    eval([varlabs{i} '=table2array(tab(:,i));'])
end
ind=batch==4;

%fig for paper
h1=figure('color','white'); lw=2; box on; hold on; fs=12;
x=runArew_s(ind); y=runAloss_s(ind);
c=getColor('models');
c=c(5,:);
errorbar([1 2],[mean(x) mean(y)],[std(x)/sqrt(numel(x)) std(y)/sqrt(numel(y))],...
    '.','color',c,'LineWidth',lw)
l1=plot([1 2],[mean(x) mean(y)],'Color',c,'LineWidth',lw)

x=runBrew_s(ind); y=runBloss_s(ind);
errorbar([1 2],[mean(x) mean(y)],[std(x)/sqrt(numel(x)) std(y)/sqrt(numel(y))],...
    '.','color',c,'LineWidth',lw)
l2=plot([1 2],[mean(x) mean(y)],'-.','Color',c,'LineWidth',lw)

legend([l1 l2],{'A','B'},'box','off')
ylabel('s');
text(1.4,.6,'*','FontSize',fs)
set(gca,'XTick',[1 2],'XTickLabel',{'reward','loss'})
xtickangle(30)
xlim([0.5 2.5])
set(h1,'Position',[150 30 200 250])

keyboard