function [f_percent, e_percent, h_percent] = A3(s1, s2, numIter, nita, nllaa, nplta, nlltl, nllpllni)

%for testing
%nita = 0.001;
%nllaa = 0.259;
%nplta = 0.212;
%nlltl = 0.777;
%nllpllni = 11.8779;

% Dimensions of the SOM
%s1=5;
%s2=5;
%numIter = 10000;

[extremeBanks, healthyBanks, failedBanks] = Bank_data();
data = [extremeBanks(:, 2:end-1); healthyBanks(:, 2:end-1); failedBanks(:, 2:end-1)];

limits = [max(data); min(data)];

normData = normalize(data, 'range')';   % Scale data between 0 to 1
normExtreme = normData(:, 1:size(extremeBanks, 1));
normHealthy = normData(:, 1+size(extremeBanks, 1):size(extremeBanks, 1)+size(healthyBanks,1));
normFailed = normData(:, end-size(failedBanks, 1)+1:end);

net = newsom(normData, [s1 s2]);
net.iw{1,1} = ones(size(net.iw{1,1}));

%plotsom(net.iw{1,1},net.layers{1}.distances)

net.trainParam.showWindow = true;
net.trainParam.epochs = numIter;
net = train(net, normData);
%plotsom(net.IW{1,1},net.layers{1}.distances);

% View which nodes each data set triggers
%plotsomhits(net, normExtreme);
%figure
%plotsomhits(net, normHealthy);
%figure
%plotsomhits(net, normFailed);

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
