function col=getColor(condition)

%B08 color scheme

if strcmp(condition,'A')
    col=[.5 .5 .5];
    
elseif strcmp(condition,'reward')
    col=[142 1 82]/256;
    
elseif strcmp(condition,'loss')
    col=[39 100 25]/256;
    
elseif strcmp(condition,'rewardp3')
    col=[142 1 82]/256;
    
elseif strcmp(condition,'rewardp5')
    col=[222 119 174]/256;
    
elseif strcmp(condition,'rewardp7')
    col=[254 224 239]/256;
    
elseif strcmp(condition,'lossp3')
    col=[39 100 25]/256;
    
elseif strcmp(condition,'lossp5')
    col=[127 188 65]/256;
    
elseif strcmp(condition,'lossp7')
    col=[230 245 208]/256;
    
elseif strcmp(condition,'models')
    col=[
        239,237,245;
        218,218,235;
        188,189,220
        158,154,200;
        128,125,186
        106,81,163;
        84,39,143
        63,0,125]/256;
    
   col=[228,26,28;
       55,126,184;
       77,175,74;
       152,78,163;
       255,127,0;
       166,86,40;
       247,129,191;
       153,153,153]/256;
end 