function n = neuralNetwork()
    n.eval = @eval;
    n.retrain = @retrain;
    n.train = @train;
end

function x = eval(in)
    global neuron
    global network
    
    n = length(in);
    
    neuronCount = sum(network.neuronsPerLayer);
    network.inputForLayer = zeros(1, n + 1, length(network.neuronsPerLayer)+1);
    network.inputForLayer(1,2:n+1,1) = in;
    network.inputForLayer(:,1,:) = 1;
    
    for layer = 1:length(network.neuronsPerLayer)
        neuron.runInput(layer, 1);
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
    network.errorRepeats = 0;
    network.tendencyDown = 0;
    network.oldWeights = zeros(length(network.weights(:,1)), length(network.weights(1,:)),1);
    oldEta = [];
    errorFixes = 1;
    weightsBeforeIteration = [];
    oldDeltaWeights = [];
    cancelAlpha = 0;
    deltaErrors = [];
    noEtaUpdateTime = 2;
    oldLastError = 0;
    network.weights;

    if (network.problem.indexBased)
        N = ceil((length(network.data) - n) * network.trainPctg);
    else
        N = 2^n;
    end

    network.eta = network.startEta;
    network.N = N;
    network.gprimas = zeros(1, N);

    while(~finished)
        weightsBeforeIteration = network.weights;
        oldDeltaWeights = network.lastDeltaWeights;
        oldOutputs = network.inputForLayer(:,2,3);
        % For every input
 
        slice = randperm(N);

        for inputIndex = slice
            logging.enabled = false;
			% Eval down-up...
			for layer = 1:length(network.neuronsPerLayer)
				neuron.runInput(layer, inputIndex);
			end
			% Prepare up-down...
			for ni = neuronCount:-1:1
				neuron.prepareDeltas(ni, inputIndex);
			end
			% Fix weights up-down...
			for ni = 1:neuronCount
				neuron.fixWeights(n, ni, inputIndex, cancelAlpha);
            end
         end
        
         
            logging.enabled = true;


            for subInputIndex = 1:N
                % Eval down-up...
                for layer = 1:length(network.neuronsPerLayer)
                    neuron.runInput(layer, subInputIndex);
                end
                neuron.prepareDeltas(neuronCount, subInputIndex);
            end
        
            oldTotalErr = totalErr;
            aux = sum(network.err.^2)./length(network.err);
            totalErr = [totalErr;aux];



            oldLastError = logging.lastError;
            logging.lastError = sum(logging.currentError);
            logging.currentError = totalErr(length(totalErr));

            
            if (network.adaptive)
            if (length(totalErr) > 1)
               deltaError = logging.currentError - logging.lastError;
               currE = logging.currentError;
               lastE = logging.lastError;
               eta = network.eta;
               if (deltaError > 0 && network.eta > 0.001)    
                    deltaEta = -0.5 * network.eta;
                    network.eta = network.eta + deltaEta;
                    eta = network.eta;
                    network.weights = weightsBeforeIteration;
                    network.errorRepeats = 0;
                    logging.errorIndexes = logging.errorIndexes - 1;
                    logging.currentError = logging.lastError;
                    logging.lastError = oldLastError;
                    network.inputForLayer(:,2,3) = oldOutputs;
                    i = i - 1;
                    totalErr = oldTotalErr;
                    network.lastDeltaWeights = oldDeltaWeights;
                    cancelAlpha = 1;

                    if (network.eta < 0.001)
                        network.eta = 0.001;
                    end
               else
                network.errorRepeats = network.errorRepeats + 1;
                if (network.errorRepeats > 3)
                    deltaEta = 0.1;
                    network.eta = network.eta + deltaEta;
                    eta = network.eta;
                    network.errorRepeats = 0;
                    % noEtaUpdateTime = 10;
                end
                cancelAlpha = 0;
               end
               
               deltaErrors = [deltaErrors deltaError];
            end
            noEtaUpdateTime = noEtaUpdateTime - 1;
        end
        
        oldEta = [oldEta network.eta];
        
        if aux < network.delta || i > 20
            finished = 1;
        end
        if (i > 1)
            network.oldWeights(:,:,i) = network.weights;
        end
        % end
        i = i + 1;
    end

    figure(1);
    plot(totalErr);
    title('Error cuadratico medio');
    print('ecm.png');


    figure(2);
    plot(oldEta);
    title('Eta');

    figure(3);
    permuted = permute(network.oldWeights, [2 3 1]);
    plot(permuted(:,:,neuronCount)');
    title('Pesos de las aristas');
    
    figure(4)
    l2 = length(network.inputForLayer(1,1,:));
    l = length(network.inputForLayer(:,2,l2));        
    scatter(1:l,network.problem.expected(1:l)'- network.inputForLayer(:,2,l2))
    title('Diferencia');

    try
        network.problem.result = network.inputForLayer(:,2,length(network.neuronsPerLayer) + 1)';
        diff = network.problem.expected - network.problem.result;
        figure(4);
        length(diff);
        scatter(1:length(diff),diff);
    catch
        
    end
end



function train(n)
	global network
	network.weights = [];
	retrain(n);
end





