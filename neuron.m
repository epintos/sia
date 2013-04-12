function neuron = neuron()
	neuron.eval = @neuronEval;
	neuron.runInput = @runInput;
	neuron.prepareDeltas = @prepareDeltas;
	neuron.fixWeights = @fixWeights;
end


function x = neuronEval(in)
	global neuronWeights
	global func
	result = sum(neuronWeights .* in);
	x = func(result);
end

% Runs the input and stores the results for each neuron
function runInput(n, ni, inputIndex)
	global weights
	global neuronWeights
	global inputForLayer
	global layerForNeuron
	global layerIndexForNeuron

	layer = layerForNeuron(ni);
	layerIndex = layerIndexForNeuron(ni);
	neuronWeights = weights(ni, :);
	in = inputForLayer(inputIndex,:,layer);
	

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

	global weights
	global neuronWeights
	global inputForLayer
	global toCompute
	global layerIndexForNeuron
	global layerForNeuron
	global neuronsPerLayer
	global deltas

	neuronWeights = weights(ni, :);

	layer = layerForNeuron(ni);
	layerIndex = layerIndexForNeuron(ni);
	in = inputForLayer(inputIndex,:,layer);
	hi = sum(neuronWeights .* in);
	gprima = 1; funcs.derivsigmoide(hi); % Check this

	if (layer == length(neuronsPerLayer))
		% Step 4 on book
		should = inputForLayer(inputIndex,layerIndex + 1,layer + 1);
        inWithNoBias = in(2:n+1); % TODO: Take this, it's unsafe!
		expected = toCompute(inWithNoBias);
		err = (expected - should); % Check This
		% if (err < delta)
		% 	err = 0;
		% end
	else
		% Step 5 on book
		err = sum(neuronWeights .* deltas(:, layer + 1)'); % Check This
	end
	deltas(1, layer) = -1;
	deltas(layerIndex + 1, layer) = gprima .* err;
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

	neuronWeights = weights(ni, :);
	layer = layerForNeuron(ni);
	layerIndex = layerIndexForNeuron(ni);

	if (layer == length(neuronsPerLayer))
		if (layer == 1)
			deltaWeight = eta .* deltas(layerIndex + 1, layer) .* inputForLayer(inputIndex, :, layer);
			weights(ni, :) = neuronWeights + deltaWeight;
		end
		return
	end

	% Step 6 on book

	% Check this
	deltaWeight = eta .* deltas(layerIndex, layer) .* inputForLayer(inputIndex, :, layer);
	weights(ni, :) = neuronWeights + deltaWeight;
end