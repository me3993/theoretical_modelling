% Reads in files, takes averages over J and x_0 of the original vs prdicted
% values.

%temp = 0.01;
t = 400;
dt = 0.01;
n = 50;
j_samples = 1;
jamp=1;


%% Read in all the simulation files at the given temperature
pathName = '/home/k1594876/Documents/theoretical_modelling/data/';

T_range = [0.001, 0.010, 0.1, 1, 5];
n_runs_range = [20, 20, 40, 80, 100];
time_range = [400, 400, 400, 400, 400];
J_Amp_range = [0.01, 0.1, 0.5, 1,10];
%J_Amp_range = [1];

tRangeLength = length(T_range);
jAmpLength = length(J_Amp_range);
%data array for single temperature but different runs

muLNAGoodnessTimeAv = zeros(jAmpLength, tRangeLength);
muLNAGoodnessTimeAvStErr = zeros(jAmpLength, tRangeLength);
muPlefkaGoodnessTimeAv = zeros(jAmpLength, tRangeLength);
muPlefkaGoodnessTimeAvStErr = zeros(jAmpLength, tRangeLength);

 formatSpec = '%f';
 %TODO This is hard-coded for size 
 for jAmp=1:jAmpLength;
     jamp = J_Amp_range(jAmp);
 for T=1:tRangeLength
     temp = T_range(T);
     t = time_range(T);
     n_runs = n_runs_range(T);
     noSteps = round(t/dt/10) +1;
     sizeA = [noSteps, n];
    myOrigData = zeros(j_samples,n,noSteps);
    myLNAData = zeros(j_samples,n,noSteps);
    myPlefkaData = zeros(j_samples,n,noSteps);

    relativeErrorOrigMu = zeros(j_samples,noSteps);
    relativeJErrorsLNA = zeros(tRangeLength, noSteps);
    relativeJErrorsPlefka = zeros(tRangeLength, noSteps);

    muOrigErrors = zeros(j_samples,n,noSteps);

    muLNAGoodness = zeros(j_samples, noSteps);
    muPlefkaGoodness = zeros(j_samples, noSteps);

    muLNAGoodnessAveraged = zeros(tRangeLength, noSteps);
    muPlefkaGoodnessAveraged = zeros(tRangeLength, noSteps);

    %transients
    muOrigTransient = zeros(j_samples, noSteps);
    muLNATransient = zeros(j_samples, noSteps);
    muPlefkaTransient = zeros(j_samples, noSteps);

    muOrigTransientAveraged = zeros(tRangeLength, noSteps);
    muLNATransientAveraged = zeros(tRangeLength, noSteps);
    muPlefkaTransientAveraged = zeros(tRangeLength, noSteps);

    for J=1:10
        fileName = strcat('dt0.01_t', num2str(t),'_n', num2str(n), '_nRuns',num2str(n_runs),'_jamp',num2str(jamp),'_x0amp1_eta1_temp', num2str(temp), '_run', num2str(J));

       %Original 
        fileEndingOrig = '_muOrig.txt';
        absoluteFilePathOrig = strcat(pathName, fileName, fileEndingOrig);
        fileIDOrig = fopen(absoluteFilePathOrig,'r');
        tempData = fscanf(fileIDOrig,formatSpec, sizeA);
        tempData = tempData';
        myOrigData(J,:,:) = tempData;
        fclose(fileIDOrig);
        

        
        
        %Original errors
        fileEndingCiiOrig = '_CiiOrig.txt';
        absoluteFilePathCiiOrig = strcat(pathName, fileName, fileEndingCiiOrig);
        fileIDCiiOrig = fopen(absoluteFilePathCiiOrig,'r');
        tempData = fscanf(fileIDCiiOrig,formatSpec, sizeA);
        tempData = tempData';
        stdErr = standardErr(tempData, n);
        muOrigErrors(J,:,:) = squeeze(stdErr);
        fclose(fileIDCiiOrig);
        
    %LNA
        fileEndingLNA = '_muLNA.txt';
        absoluteFilePathLNA = strcat(pathName, fileName, fileEndingLNA);
        fileIDLNA = fopen(absoluteFilePathLNA,'r');
        tempDataLNA = fscanf(fileIDLNA,formatSpec, sizeA);
        tempDataLNA = tempDataLNA';
        myLNAData(J,:,:) = tempDataLNA;
        fclose(fileIDLNA);

     %Plefka
        fileEndingPlefka = '_muPlefka.txt';
        absoluteFilePathPlefka = strcat(pathName, fileName, fileEndingPlefka);
        fileIDPlefka = fopen(absoluteFilePathPlefka,'r');
        tempDataPlefka = fscanf(fileIDPlefka,formatSpec, sizeA);
        tempDataPlefka = tempDataPlefka';
        myPlefkaData(J,:,:) = tempDataPlefka;
        fclose(fileIDPlefka);
        
        
        %WANT IT TO BE LOWER THAN 10%
        relativeErrorOrigMu(J,:) = relativeError(myOrigData(J,:,:), muOrigErrors(J,:,:));
    end
    
%PLOT ORIGINAL MU
%             figure;
%             hold on;
%             titleName = strcat(' Orig Mu, Jamp= ', num2str(jamp), ', Temp = ', num2str(temp), ' J= ', num2str(J));
%             title(titleName);
%             for nn=1:n
%             plot(squeeze(myOrigData(1,nn,:)),'color',rand(1,3));
%             end
    
    %% Do Goodness of fit for all J and x0
    for J=1:10
        %PredictionErrors
        muLNAGoodness(J,:) = squeeze(goodnessOfFit(squeeze(myOrigData(J,:,:)), squeeze(myLNAData(J,:,:)), n));
        muPlefkaGoodness(J,:) = goodnessOfFit(squeeze(myOrigData(J,:,:)), squeeze(myPlefkaData(J,:,:)), n);
        
        muOrigTransient(J,:) = transient(squeeze(myOrigData(J,:,:)), n);
        muLNATransient(J,:) = transient(squeeze(myLNAData(J,:,:)), n);
        muPlefkaTransient(J,:) = transient(squeeze(myPlefkaData(J,:,:)), n);
    end
     %PLOT TRANSIENTS
%     figure;
%     hold on;
%     titleName = strcat('Transients Mu, Jamp= ', num2str(jamp), ', Temp = ', num2str(temp));
%     title(titleName);
%     for jj=1:10
%     plot((1:10:40001),muOrigTransient(jj,:),'color',rand(1,3));
%     set(gca,'XScale','log');
%     end
    
    
    muLNAGoodnessAveraged(T,:) = squeeze(mean(muLNAGoodness, 1));
    muPlefkaGoodnessAveraged(T,:) = squeeze(mean(muPlefkaGoodness, 1));
    
    [muLNAGoodnessTimeAv(jAmp, T), muLNAGoodnessTimeAvStErr(jAmp, T)] = averagedGoodnessOfFit(muLNAGoodnessAveraged(T,:), jAmp, T, noSteps);
    [muPlefkaGoodnessTimeAv(jAmp, T), muPlefkaGoodnessTimeAvStErr(jAmp, T)] = averagedGoodnessOfFit(muPlefkaGoodnessAveraged(T,:), jAmp, T, noSteps);

    
    %AVERAGED GOODNESS OF FIT LNA
    
%       PLOT GOODNESS OF FIT LNA
%         figure;
%         hold on;
%         titleName = strcat('Goodness of Fit LNA Mu, Jamp=', num2str(jamp), 'T=', num2str(temp));
%         plot(squeeze(muLNAGoodnessAveraged(T,:)));
%         title(titleName);
%         hold off;
%         
%       PLOT GOODNESS OF FIT PLEFKA
%         figure;
%         hold on;
%         plot(squeeze(muPlefkaGoodnessAveraged(T,:)));
%         titleName = strcat('Goodness of Fit Plefka Mu, Jamp=', num2str(jamp), 'T=', num2str(temp));
%         title(titleName);
%         hold off;
    
        %% Get the relative errors on Averaging over J
%     meanMuJ = squeeze(mean(muLNAGoodness, 1));
%     stDevMuJ = squeeze(std(muLNAGoodness, 1, 1));
%     relativeJErrorsLNA(T,:) = (stDevMuJ/sqrt(15))./meanMuJ;
%     
%     
%     
%     meanMuJ = squeeze(mean(muPlefkaGoodness, 1));
%     stDevMuJ = squeeze(std(muPlefkaGoodness, 1, 1));
%     relativeJErrorsPlefka(T,:) = stDevMuJ/sqrt(15)./meanMuJ;
    
%     figure;
%     hold on;
%     titleName = strcat('Mu Plefka Goodness Averaged, Jamp= ', num2str(jamp), ', Temp = ', num2str(temp));
%     title(titleName);
%     plot(muLNAGoodnessAveraged(T,:));
    
    %relativeJErrors(T,:) = relativeError(muLNAGoodnessAveraged(T,:), stDevMuJ);
    
    %%
    
    muOrigTransientAveraged(T,:) = squeeze(mean(muOrigTransient, 1));
    muLNATransientAveraged(T,:) = squeeze(mean(muLNATransient, 1));
    muPlefkaTransientAveraged(T,:) = squeeze(mean(muPlefkaTransient, 1));
    
    %PLOT AVERAGED TRANSIENTS
%     figure;
%     hold on;
%     titleName = strcat('Transients Mu, Jamp= ', num2str(jamp), ', Temp = ', num2str(temp));
%     title(titleName);
%     plot((1:10:40001),muOrigTransientAveraged(T,:));
% set(gca,'XScale','log');
    
  %  PLOT RELATIVE STERR on noise averaging
%     figure;
%     hold on;
%     titleName = strcat('RelativeError Mu, Jamp= ', num2str(jamp), ', Temp = ', num2str(temp));
%     title(titleName);
%     for ii=1:10
%         errorForJ = squeeze(relativeErrorOrigMu(ii,:));
%         plot(errorForJ','color',rand(1,3));
%     end

% PLOT absolute standard errors on noise
%     figure;
%     hold on;
%     titleName = strcat('StandardError Mu, Jamp= ', num2str(jamp), ', Temp = ', num2str(temp));
%     title(titleName);
%         errorForJ = squeeze(mean(squeeze(mean(muOrigErrors(:,:,:),2)),1));
%         plot(errorForJ','color',rand(1,3));


 end

 %% PLOT
 
%  clear title xlabel ylabel;
%  
% 
%  figure;
% hold on;
% titleName = strcat('Goodness of Fit LNA Mu, Jamp=', num2str(jamp));
%  for ii=1:3%tRangeLength
% plot(muLNAGoodnessAveraged(ii,:)','color',rand(1,3));
%  end
% title(titleName);
% hold off;
% 
% 
% figure;
% hold on;
% for ii=1:3%tRangeLength
% plot(muPlefkaGoodnessAveraged(ii,:)','color',rand(1,3));
% end
% titleName = strcat('Goodness of Fit Plefka Mu, Jamp=', num2str(jamp));
% title(titleName);
% hold off;
 
%     figure;
%     plot(muLNAGoodnessAveraged(T,:), 'g');
%     hold on;
%     plot(muPlefkaGoodnessAveraged(T,:));
%     title('LNA Mean goodness of fit');
%     legend('LNA','Plefka')
%     hold off;


% figure;
% hold on;
% title('Transients Original Mu');
% for ii=1:tRangeLength
% plot(muOrigTransientAveraged(ii,:)','color',rand(1,3));
% end
% hold off;
% 
% figure;
% hold on;
% title('Transients LNA Mu');
% for ii=1:tRangeLength
% plot(muLNATransientAveraged(ii,:)','color',rand(1,3));
% end
% 
% figure;
% hold on;
% title('Transients Plefka Mu');
% for ii=1:tRangeLength
% plot(muPlefkaTransientAveraged(ii,:)','color',rand(1,3));
% end
 end