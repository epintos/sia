function neuron = neuron()
	neuron.eval = @neuronEval;
	neuron.runInput = @runInput;
	neuron.prepareDeltas = @prepareDeltas;
	neuron.fixWeights = @fixWeights;
end


function x = neuronEval(in)
	global network
	result = sum(network.neuronWeights(1:length(in)) .* in);
	x = network.problem.f(result);
end

% Runs the input and stores the results for each neuron
function runInput(layer, inputIndex)
    global network
    global util
    
    if (layer == 1)
        layerFirstNodeIndex = 1;
    else
        layerFirstNodeIndex = sum(network.neuronsPerLayer(1:layer - 1)) + 1;
    end

    layerNodeCount = network.neuronsPerLayer(layer);
    
    from = layerFirstNodeIndex;
    to = layerFirstNodeIndex + layerNodeCount-1;
	
	weightnum = network.weightsPerLayer(layer);
    thisLayerWeights = network.weights(from:to,1:weightnum);
	in = network.inputForLayer(inputIndex,1:weightnum,layer);
    
    aux = thisLayerWeights * in';
	
    for i=1:length(aux)
        layerIndex = network.layerIndexForNeuron(i + layerFirstNodeIndex - 1);
        network.inputForLayer(inputIndex, layerIndex + 1, layer + 1) = network.problem.f(aux(i));
    end
end

function prepareDeltas(ni, inputIndex)
    global network
    
	network.neuronWeights = network.weights(ni, :);

	layer = network.layerForNeuron(ni);
	layerIndex = network.layerIndexForNeuron(ni);
	weightnum = network.weightsPerLayer(layer);
	in = network.inputForLayer(inputIndex,1:weightnum,layer);
	hi = sum(network.neuronWeights(1:length(in)) .* in);
	gprima = network.problem.df(hi); % Check this

	if (layer == length(network.neuronsPerLayer))
		% Step 4 on book
        in = network.inputForLayer(inputIndex,1:network.weightsPerLayer(1),1);
		result = network.inputForLayer(inputIndex,layerIndex + 1,layer + 1);
        inWithNoBias = in(2:length(in)); 
        if (~network.problem.indexBased)
		  expected = network.problem.learnF(inWithNoBias);
        else
          expected = network.problem.learnF(inputIndex);
        end
		error = (expected - result); % Check This
%         if (abs(error) < 0.0001) 
%            error = 0;
%         end
        network.err(inputIndex) = error;
    else
        nextLayerNodeCount = network.neuronsPerLayer(layer + 1);
        % gets the indexes of the nodes in the upper layer
        if (layer + 1 == 1)
            nextLayerFirstNodeIndex = 1;
        else
            nextLayerFirstNodeIndex = sum(network.neuronsPerLayer(1:layer)) + 1;
        end
        
		% Step 5 on book
        added = 0;
        for i = nextLayerFirstNodeIndex: nextLayerFirstNodeIndex+nextLayerNodeCount - 1
            %the index is +1 because of the biased input weight
            li = network.layerIndexForNeuron(i); % Index on layer for this neuron
            added = added + network.weights(i,layerIndex + 1) * network.deltas(li, layer + 1);
        end
		error = added; % Check This
        if (abs(error) < 0.0001) 
           error = 0;
        end
    end
    
    network.deltas(layerIndex, layer) = (gprima + 0.1) * error;
end



function fixWeights(n, ni, inputIndex, cancelAlpha)
    global network
 
    neuronWeights = network.weights(ni, :);
    layer = network.layerForNeuron(ni);
    niOnLayer = network.layerIndexForNeuron(ni);
 
    % Step 6 on book
    % Check this
    deltaWeight = network.eta .* network.deltas(niOnLayer, layer) .* network.inputForLayer(inputIndex, :, layer);
%     
    if (cancelAlpha == 0 && network.momentum)
        deltaWeight = network.lastDeltaWeights(ni,:) * 0.1 + deltaWeight;
    end
    
    network.lastDeltaWeights(ni,:) = deltaWeight;
    
    network.weights(ni, :) = neuronWeights + deltaWeight;
end