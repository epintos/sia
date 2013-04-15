function n = neuralNetwork()
    n.eval = @eval;
    n.retrain = @retrain;
    n.train = @train;
end

function x = eval(in)
    global neuron
    global network

    
    n = length(network.weights(1,:));
    
    neuronCount = sum(network.neuronsPerLayer);
    network.inputForLayer = zeros(1, n + 1, length(network.neuronsPerLayer)+1);
	network.inputForLayer(1,2:n,1) = in;
    network.inputForLayer(:,1,:) = 1;
    
    for ni = 1:neuronCount
        neuron.runInput(n, ni, 1);
    end
    
    x = network.inputForLayer(1,2,length(network.neuronsPerLayer) + 1);
end

function retrain(n) 
    global neuron
    global util
    global logging
    global network
    
	util.networkPrepare(n);

	neuronCount = sum(network.neuronsPerLayer);
    finished = 0;
    i = 1;
    totalErr = [];
    aux = 0;
    firstIteration = false;
	while(~finished)
		% For every input
		for inputIndex = 1:2^n
			% Eval down-up...
			for ni = 1:neuronCount
				neuron.runInput(n, ni, inputIndex);
			end
			% Prepare up-down...
			for ni = neuronCount:-1:1
				neuron.prepareDeltas(n, ni, inputIndex);
			end
			% Fix weights up-down...
			for ni = 1:neuronCount
				neuron.fixWeights(n, ni, inputIndex);
            end

        end

        
         if mod(i, 500) == 0
             figure(1)
            plot(logging.errors(:,:,neuronCount));
         end
        
         
         for inputIndex = 1:2^n
            % Eval down-up...
            for ni = 1:neuronCount
                neuron.runInput(n, ni, inputIndex);
            end
            % Prepare up-down...
            for ni = neuronCount:-1:1
                neuron.prepareDeltas(n, ni, inputIndex);
            end
        end
        aux = sum(network.err.^2)/length(network.err);
        totalErr = [totalErr;aux];
        figure(2)




        


        if mod(i, 25) == 1
            
%             if (~firstIteration)
%                 logging.lastError = logging.currentError;
%                 logging.currentError = sum(totalErr);
% 
%                 deltaError = logging.currentError - logging.lastError;            
%                 if (deltaError > 0.00001)    
%                    deltaEta = -0.9 * network.eta;
%                    network.eta = network.eta + deltaEta;
%                    eta = network.eta
%                 else
%                    deltaEta = 0.1;
%                    network.eta = network.eta + deltaEta;
%                    eta = network.eta
%                 end
%             else
%                firstIteration = true;
%             end
            
            plot(totalErr);
            
            if aux < network.delta
                finished = 1;
            end
        end
        i = i + 1;
    end
end



function train(n)
	global network
	network.weights = [];
	retrain(n);
end

