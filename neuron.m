function neuron = neuron()
	neuron.eval = @neuronEval;
	neuron.runInput = @runInput;
	neuron.prepareDeltas = @prepareDeltas;
	neuron.fixWeights = @fixWeights;
end


function x = neuronEval(in)
	global neuronWeights
	global func
    dbstop if error
	result = sum(neuronWeights(1:length(in)) .* in);
	x = func(result);
end

% Runs the input and stores the results for each neuron
function runInput(n, ni, inputIndex)
	global weights
	global neuronWeights
	global inputForLayer
	global layerForNeuron
	global layerIndexForNeuron
	global weightsPerLayer

	layer = layerForNeuron(ni);
	layerIndex = layerIndexForNeuron(ni);
	neuronWeights = weights(ni, :);
	weightnum = weightsPerLayer(layer);
	in = inputForLayer(inputIndex,1:weightnum,layer);
	

	% Step 3 on book
	% Pushes the evaluation to the next neurone
	inputForLayer(inputIndex, layerIndex + 1, layer + 1) = neuronEval(in);

	% should = toCompute(inWithNoBias);
	% err = abs(result-should);
	% if err > delta
	% 	valid = 0;
	% else
	% 	valid = 1;
	% end
end

function prepareDeltas(n, ni, inputIndex)
    global funcs
    global util

	global weights
	global neuronWeights
	global inputForLayer
	global toCompute
	global layerIndexForNeuron
	global layerForNeuron
	global neuronsPerLayer
	global deltas
	global weightsPerLayer

	neuronWeights = weights(ni, :);

	layer = layerForNeuron(ni);
	layerIndex = layerIndexForNeuron(ni);
	weightnum = weightsPerLayer(layer);
	in = inputForLayer(inputIndex,1:weightnum,layer);
	hi = sum(neuronWeights(1:length(in)) .* in);
	gprima = funcs.derivsigmoide(hi); % Check this

	if (layer == length(neuronsPerLayer))
		% Step 4 on book
		should = inputForLayer(inputIndex,layerIndex + 1,layer + 1);
        inWithNoBias = in(2:length(in)); % TODO: Take this, it's unsafe!
		expected = toCompute(inWithNoBias);
		err = (expected - should); % Check This
		% if (err < delta)
		% 	err = 0;
		% end
        err
    else
        nextLayerNodeCount = neuronsPerLayer(layer + 1)
        % gets the indexes of the nodes in the upper layer
        nextLayerFirstNodeIndex = util.getIndexesForLayer(layer+1);
        
		% Step 5 on book
        added = 0;
        for i=nextLayerFirstNodeIndex:nextLayerNodeCount
            %the index is +1 because of the biased input weight
            added = nextLayersWeights(i,index+1)*deltas(i-1);
        end
		err = added; % Check This
        
	end
	deltas(ni) = gprima .* err;
end

function fixWeights(n, ni, inputIndex)
	global eta
	global weights
	global neuronWeights
	global inputForLayer
	global deltas
	global layerIndexForNeuron
	global layerForNeuron
	global neuronsPerLayer
	global weightsPerLayer

	neuronWeights = weights(ni, :);
	layer = layerForNeuron(ni);
	layerIndex = layerIndexForNeuron(ni);

	if (layer == length(neuronsPerLayer))
		if (layer == 1)
			deltaWeight = eta .* deltas(layerIndex, layer) .* inputForLayer(inputIndex, :, layer);
			weights(ni, :) = neuronWeights + deltaWeight;
		end
		return
	end

	% Step 6 on book

	% Check this
	weightnum = weightsPerLayer(layer);
	deltaWeight = eta .* deltas(layerIndex, layer) .* inputForLayer(inputIndex, 1:weightnum, layer);
	weights(ni, :) = neuronWeights + deltaWeight;
end