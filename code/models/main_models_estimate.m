% this routine provides code for model inference
% note that it calls the original data files which are not uploaded
% here to ensure privacy
% however, the data matrices used for inference are located in the
% data/datamatrices folder (one per subject, per run, per condition) 
% with these data matrices, the models can be reinferred
% for questions please contact georgia.koppe@zi-mannheim.de

clear all; close all; clc

addpath([pwd '/auxfun/']);

optionall=false; %all files or specific files
model={'m01a'}; 

%datapath=original file paths...

%get all subdirectories for model
if optionall
    files = dir;
    filenames = {files.name};
    subdirs = filenames([files.isdir]);
    zsp=strmatch('m',subdirs);
    for s = 1:length(zsp)
        subdir{s,:} = [pwd '/' subdirs{zsp(s)}];
    end
    clear filenames files s subdirs
else
    for s=1:length(model)
        subdir{s,:}=[pwd '\' model{s}];
    end
end

%% -> boundary conditions (beta kappa1 alpha delta s/kappa2 w)
switch char(model)
    case 'm01a' %hyperbolic *
        alllb=[1e-15 0 0 nan nan nan];
        allub=[100 inf inf nan nan nan];
    
    case 'm01b' %exponential *
        alllb=[1e-15 0 0 nan nan nan];
        allub=[100 1 inf nan nan nan]; 

    case 'm01c' % constant sensitivity model *
        alllb=[1e-15 0 nan nan 0 nan ];
        allub=[100 inf nan nan inf nan];

    case 'm01d' %hyperboloid modified *
         alllb=[1e-15 0 nan nan 0 nan];
        allub=[100 inf nan nan 1 nan];
         
    case 'm01e' %quasi-hyperbolic *
        alllb=[1e-15 0 nan 0 nan nan];
        allub=[100 1 nan 1 nan nan];
        
    case 'm01f' %hyperboloid *
         alllb=[1e-15 0 nan nan 0 nan];
        allub=[100 inf nan nan 1 nan];
        
    case 'm01g' %double exponential *
         alllb=[1e-15 0 nan nan 0 0];
        allub=[100 1 nan nan 1 1];       
end
%%

for idir=1:size(subdir,1)   %loop over all model folders
    npwd=char(subdir(idir,:));
    cd(npwd);
    modelpath=[npwd '\'];
    
    %determine parameters of model
    parinfofile=[npwd '\parameters.txt'];
    fid=fopen(parinfofile);
    c=textscan(fid,'%s %s %s %s %s %s');
    for ipar=1:size(c,2)
        dum=c{ipar};
        parlabels{ipar}=dum(1);
        parsused(ipar)=str2num(dum{2});
    end
    fclose(fid);
    parsused=parsused>0;
    
    %set initial conditions
    allpar0 = {[1 5 10],[0:.3:1],[0 10 100],[0 .5 1],[0 .5 1],[0 .5 1]};
    
    modelpar0=allpar0(parsused);
    lb=alllb(parsused);
    ub=allub(parsused);
    npar=size(modelpar0,2);
    switch npar
        case 2
            [x,y]=ndgrid(modelpar0{:}); par0=[x(:),y(:)];
        case 3
            [x,y,z]=ndgrid(modelpar0{:}); par0=[x(:),y(:),z(:)];
        case 4
            [x,y,z,w]=ndgrid(modelpar0{:}); par0=[x(:),y(:),z(:),w(:)];
        case 5
            [x,y,z,w,l]=ndgrid(modelpar0{:}); par0=[x(:),y(:),z(:),w(:),l(:)];
        case 6
            [x,y,z,w,l,xx]=ndgrid(modelpar0{:}); par0=[x(:),y(:),z(:),w(:),l(:) xx(:)];
        otherwise
            display('wrong number of parameters, please check'); keyboard;
    end
    
    %maximize log likelihood and save info to file
    maxL(modelpath,par0,lb,ub,datapath);
    
    clearvars -except subdir idir all* mall* iinit* datapath
end
