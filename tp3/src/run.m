% clear
% clc
% main
% network.n = 2;
% network.problem = problem.approximation(network.n, functs.tanh);
% network.iterLimit = 200;
% network.trainPctg = 0.8;
% network.momentum = true;
% network.adaptive = true;
% network.beta = 0.5;
% if network.adaptive
% 	network.startEta = 1;
% else
% 	network.startEta = 0.01;
% end
% network.neuronsPerLayer = [9 6 1];
% network.train(network.n);
% save([logging.pwd,'/','network'],'network');

clc
clear
init
clc
genetic.run()