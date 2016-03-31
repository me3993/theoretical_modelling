function [averagedGoodnessOfFit, averagedGoodnessOfFitError] = averagedGoodnessOfFit(goodnessOfFit, jAmp, T, noSteps)
%averages goodnessOfFit over the equilibrated time and its standard error

T_range = [0.001, 0.010, 0.1, 1, 5];
J_Amp_range = [0.01, 0.1, 0.5, 1,10];

Transients = [50, 60, 1530, 100, 40; 50, 60, 0, 120, 40; 460, 0, 0, 170, 40; 500, 0, 0, 0, 70; 50, 50, 70, 0, 0];

eq_time = Transients(jAmp,T);

if eq_time==0
    averagedGoodnessOfFit = 0;
    averagedGoodnessOfFitError = 0;
else
    squeezedGoodness = squeeze(goodnessOfFit(eq_time:noSteps));
    
    averagedGoodnessOfFit = mean(squeezedGoodness);
    averagedGoodnessOfFitError = sqrt(var(squeezedGoodness)/(noSteps - eq_time));
end
end

