%%
clear all; close all; clc
load_behavioral_results
%%

h1=figure('color','white');
ind=batch<5;
x=Arew_pc_imm(ind); x1=x;
y=Brew_pc_imm(ind); y1=y;
[r,p]=corrcoef(x,y); 
txt=sprintf('r=%2.2f, p=%2.3f',r(1,2),p(1,2));

subplot(1,4,1); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('A-imm freq rew'); ylabel('B-imm freq rew')

x=Aloss_pc_imm(ind); x2=x;
y=Bloss_pc_imm(ind); y2=y;
[r,p]=corrcoef(x,y); 
txt=sprintf('r=%2.2f, p=%2.3f',r(1,2),p(1,2));

subplot(1,4,2); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('A-imm freq loss'); ylabel('B-imm freq loss')


x=Arew_pc_imm(ind); x3=x;
y=Aloss_pc_imm(ind); y3=y;
[r,p]=corrcoef(x,y); 
txt=sprintf('r=%2.2f, p=%2.3f',r(1,2),p(1,2));

subplot(1,4,3); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('A-imm freq rew'); ylabel('A-imm freq loss')

x=Brew_pc_imm(ind); x4=x;
y=Bloss_pc_imm(ind); y4=y;
[r,p]=corrcoef(x,y); 
txt=sprintf('r=%2.2f, p=%2.3f',r(1,2),p(1,2));

subplot(1,4,4); hold on; box on
title(txt);
plot(x,y,'ok','MarkerFaceColor','k'); lsline
xlabel('B-imm freq rew'); ylabel('B-imm freq loss')
set(h1,'Position',[200 200 1100 180])

