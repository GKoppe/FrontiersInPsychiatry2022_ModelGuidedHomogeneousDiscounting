%load behavioral results of online task
pati='..\data\';
file='B08_BehaviorResults.xlsx';
cd(pati)

%% Import data from spreadsheet

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 42);

% Specify sheet and range
opts.Sheet = "Tabelle1";
opts.DataRange = "A2:AP199";

% Specify column names and types
opts.VariableNames = ["vp", "batch", "Arew_pc_imm", "Arew_rt_imm", "Arew_rt_del", "Aloss_pc_imm", "Aloss_rt_imm", "Aloss_rt_del", "Brew_pc_imm", "Brew_rt_imm", "Brew_rt_del", "Brew_pc_imm_p3", "Brew_rt_imm_p3", "Brew_rt_del_p3", "Brew_pc_imm_p5", "Brew_rt_imm_p5", "Brew_rt_del_p5", "Brew_pc_imm_p7", "Brew_rt_imm_p7", "Brew_rt_del_p7", "Bloss_pc_imm", "Bloss_rt_imm", "Bloss_rt_del", "Bloss_pc_imm_p3", "Bloss_rt_imm_p3", "Bloss_rt_del_p3", "Bloss_pc_imm_p5", "Bloss_rt_imm_p5", "Bloss_rt_del_p5", "Bloss_pc_imm_p7", "Bloss_rt_imm_p7", "Bloss_rt_del_p7", "Arew_rt", "Aloss_rt", "Brew_rt", "Bloss_rt", "Brew_rt_p3", "Brew_rt_p5", "Brew_rt_p7", "Bloss_rt_p3", "Bloss_rt_p5", "Bloss_rt_p7"];
opts.SelectedVariableNames = ["vp", "batch", "Arew_pc_imm", "Arew_rt_imm", "Arew_rt_del", "Aloss_pc_imm", "Aloss_rt_imm", "Aloss_rt_del", "Brew_pc_imm", "Brew_rt_imm", "Brew_rt_del", "Brew_pc_imm_p3", "Brew_rt_imm_p3", "Brew_rt_del_p3", "Brew_pc_imm_p5", "Brew_rt_imm_p5", "Brew_rt_del_p5", "Brew_pc_imm_p7", "Brew_rt_imm_p7", "Brew_rt_del_p7", "Bloss_pc_imm", "Bloss_rt_imm", "Bloss_rt_del", "Bloss_pc_imm_p3", "Bloss_rt_imm_p3", "Bloss_rt_del_p3", "Bloss_pc_imm_p5", "Bloss_rt_imm_p5", "Bloss_rt_del_p5", "Bloss_pc_imm_p7", "Bloss_rt_imm_p7", "Bloss_rt_del_p7", "Arew_rt", "Aloss_rt", "Brew_rt", "Bloss_rt", "Brew_rt_p3", "Brew_rt_p5", "Brew_rt_p7", "Bloss_rt_p3", "Bloss_rt_p5", "Bloss_rt_p7"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "WhitespaceRule", "preserve");
opts = setvaropts(opts, 1, "EmptyFieldRule", "auto");

% Import the data
tab = readtable([pati file], opts, "UseExcel", false);

varlabs=opts.VariableNames;
nvars=length(varlabs);
clear opts

for i=1:nvars
    eval([varlabs{i} '=table2array(tab(:,i));'])
end
