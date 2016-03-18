% simulates the original function, as well as Plefka and LNA


%% Declare variables
global dt;
global t;
global n;
global temp;
global j_glob;
global x0_glob;


%% Initialise variables
dt = 0.01;
t=50;
n=50;
%temp=0;

n_runs=20;
jamp=1;
x0amp=1.0;
eta = 1;

T_range = [0.001, 0.005, 0.010, 0.020, 0.030, 0.040, 0.050, 0.060, 0.070, 0.080, 0.090, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 2, 3, 4, 5];
%T_range = [0,1,3];
pathName = '/home/k1594876/Documents/theoretical_modelling/data/';

%% Save data for all the variables

for J=1:10
j_glob=j_sample_eta(n,jamp,eta);
x0_glob=x0amp*randn(n,1);
    
for T=1:length(T_range)
    temp = T_range(T);
    fileName = strcat('dt',num2str(dt),'_t',num2str(t),'_n',num2str(n),'_nRuns',num2str(n_runs),'_jamp',num2str(jamp),'_x0amp',num2str(x0amp),'_eta',num2str(eta),'_temp',num2str(temp), '_run', num2str(J));
    
 %ORIGINAL
    [mu_orig, c_ii_orig] = simulate_many_collect_data(n,x0_glob,j_glob,dt,temp,t,n_runs);
    
    %Print means
    myMuFile = strcat(pathName, fileName, '_muOrig', '.txt');
    
    fid=fopen(myMuFile,'w');
    for i=1:size(mu_orig,1)
     fprintf(fid, '%d ', mu_orig(i,:));
     fprintf(fid, '\n');
    end
    fclose(fid);
    
    %Print Covariances
    myCiiFile = strcat(pathName, fileName, '_CiiOrig', '.txt');
        fid=fopen(myCiiFile,'w');
    for i=1:size(c_ii_orig,1)
     fprintf(fid, '%d ', c_ii_orig(i,:));
     fprintf(fid, '\n');
    end
    fclose(fid);
    
    
 %LNA
    [mu_LNA, c_ii_LNA] = simulate_many_LNA_collect_data(n,x0_glob,j_glob,dt,temp,t);
       %Print means
    myMuFileLNA = strcat(pathName, fileName, '_muLNA', '.txt');
    
    fid=fopen(myMuFileLNA,'w');
    for i=1:size(mu_LNA,1)
     fprintf(fid, '%d ', mu_LNA(i,:));
     fprintf(fid, '\n');
    end
    fclose(fid);
    
    %Print Covariances
    myCiiFileLNA = strcat(pathName, fileName, '_CiiLNA', '.txt');
        fid=fopen(myCiiFileLNA,'w');
    for i=1:size(c_ii_LNA,1)
     fprintf(fid, '%d ', c_ii_LNA(i,:));
     fprintf(fid, '\n');
    end
    fclose(fid);
    
 %PLEFKA
     [mu_plefka, c_ii_plefka] = many_runs_plefka(n,x0_glob,j_glob,dt,t,temp);
       %Print means
    myMuFilePlefka = strcat(pathName, fileName, '_muPlefka', '.txt');
    
    fid=fopen(myMuFilePlefka,'w');
    for i=1:size(mu_plefka,1)
     fprintf(fid, '%d ', mu_plefka(i,:));
     fprintf(fid, '\n');
    end
    fclose(fid);
    
    %Print Covariances
    myCiiFilePlefka = strcat(pathName, fileName, '_CiiPlefka', '.txt');
        fid=fopen(myCiiFilePlefka,'w');
    for i=1:size(c_ii_plefka,1)
     fprintf(fid, '%d ', c_ii_plefka(i,:));
     fprintf(fid, '\n');
    end
    fclose(fid);
    
    
end
end
