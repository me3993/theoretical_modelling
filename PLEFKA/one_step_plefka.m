function [mu_new, c_ii_new] = one_step_plefka(mu,c_ii, j,dt, temp)

% calculate one timestep dt update from mu to mu_new an c_ii to c_ii_new at temperature temp
% using specified drift function


mu_new = mu + dt*(mu-mu.*mu.*mu + j*mu-3*mu.*c_ii);
c_ii_new = c_ii + 2*dt*(c_ii - 3*c_ii.*c_ii - 3*mu.*mu.*c_ii + temp);