function c_ii_new = one_step_c_ii(c_ii,j,mu, temp, n, dt)

c_ii_new = zeros(n,1);

%c_ii_new = c_ii + 2*dt*( c_ii-3*c_ii.*mu.*mu +sum(j()*c_ii) +temp )
for n1=1:n
   c_ii_new(n1) = c_ii(n1) + 2*dt*(c_ii(n1)*(1-3*(mu(n1))^2 ) + c_ii(n1)*(sum(j(n1,:))) + temp);
end