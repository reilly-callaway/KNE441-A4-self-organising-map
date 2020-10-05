function [f_percent, e_percent, h_percent] = Allocation(net, normFailed, normExtreme, normHealthy, nita, nllaa, nplta, nlltl, nllpllni, s1, s2)
% Failed banks trigger these nodes
a = sim(net, normFailed);
fail = mod(find(a), s1*s2);

% Extreme banks trigger these nodes
b = sim(net, normExtreme);
extreme = mod(find(b), s1*s2);

% Healthy banks trigger these nodes
c = sim(net, normHealthy);
healthy = mod(find(c), s1*s2);

%nueron counts - matrix size s1*s2 x 3
fail_count = hist(fail, (0:s1*s2-1));
extreme_count = hist(extreme, (0:s1*s2-1));
healthy_count = hist(healthy, (0:s1*s2-1));

counts = [fail_count' extreme_count' healthy_count'];

%allocation of input
new_data = [nita; nllaa; nplta; nlltl; nllpllni];
d=sim(net,new_data);
neuron=find(d);

denom = sum(counts(neuron,:))+realmin;
%if denom != 0
f_percent = counts(neuron,1)/denom;
e_percent = counts(neuron,2)/denom;
h_percent = counts(neuron,3)/denom;

end

