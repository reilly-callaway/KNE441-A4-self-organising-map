% Dimensions of the SOM
s1=3;
s2=3;
numIter = 10000;

[extremeBanks, healthyBanks, failedBanks] = Bank_data();
data = [extremeBanks(:, 2:end-1); healthyBanks(:, 2:end-1); failedBanks(:, 2:end-1)];

limits = [max(data); min(data)];

normData = normalize(data, 'range')';   % Scale data between 0 to 1
normExtreme = normData(:, 1:size(extremeBanks, 1));
normHealthy = normData(:, 1+size(extremeBanks, 1):1+size(extremeBanks, 1)+size(healthyBanks,1));
normFailed = normData(:, end-size(failedBanks, 1):end);

net = newsom(norm_data, [s1 s2]);
net.iw{1,1} = ones(size(net.iw{1,1}));

% plotsom(net.iw{1,1},net.layers{1}.distances)

net.trainParam.showWindow = true;
net.trainParam.epochs = numIter;
net = train(net, norm_data);
plotsom(net.IW{1,1},net.layers{1}.distances);

% View which nodes each data set triggers
% plotsomhits(net, normExtreme);
% plotsomhits(net, normHealthy);
plotsomhits(net, normFailed);

% Failed banks trigger these nodes
a = sim(net, normFailed);
a = mod(find(a), s1*s2)
