function util = util()
    util.networkPrepare = @networkPrepare;
    util.binary2vector = @binary2vector;
    util.randomInput = @generateRandomInputs;
    util.trainingSets = @generateTrainingSets;
    util.getNodeIndex = @getNodeIndex;
    util.getIndexesForLayer = @getIndexesForLayer;
end


% Initializes Weights
% Initializes Inputs
% Models the network
function networkPrepare(n)
  global util
  global network
  global logging

	if ~network.problem.indexBased
  	network.err = zeros(2^n,1);
  else
  	network.err = length(network.data) - n;
  end
    
	network.neuronCount = sum(network.neuronsPerLayer);

	% Initializes the weight only if its the first time.
	% !!! Weights are stored based on the index of each node.
	if isempty(network.weights)
    network.weights = ((2*rand(network.neuronCount,max(max(network.neuronsPerLayer)+1, n+1))-1)./1.2);
  end

	% Makes matrix containing the inputs for each layer.
	% !!! Inputs are stored based on the level of each layer.
	
    
    if ~network.problem.indexBased
    	network.inputForLayer = zeros(2^n, max(network.neuronsPerLayer)+1, length(network.neuronsPerLayer) + 1); % TODO: n+1 is not a wire parameter, it should be the maximum size of inputs for all layers
		network.inputForLayer(:,1:n+1,1) = network.inputGenerator(n);
    else
        num = ceil((length(network.data)) * network.trainPctg);
		network.inputForLayer = zeros(num, n + 1, length(network.neuronsPerLayer) + 1); % TODO: n+1 is not a wire parameter, it should be the maximum size of inputs for all layers
		network.inputForLayer(:,:,1) = network.inputGenerator(n);
	end
	for i = 2:length(network.neuronsPerLayer) + 1
		network.inputForLayer(:,1,i) = 1;
	end

	% Prepares the deltas matrix
	network.deltas = zeros(max(network.neuronsPerLayer), sum(network.neuronsPerLayer));
	network.lastDeltaWeights = zeros(network.neuronCount, max(max(network.neuronsPerLayer)+1, n+1)); 
	
	% Generates an index to know how many weights has each layer
	network.weightsPerLayer = zeros(network.neuronCount);
	for layer = 1:length(network.neuronsPerLayer)
		if (layer == 1)
			network.weightsPerLayer(layer) = 1 + n;
		else
			network.weightsPerLayer(layer) = 1 + network.neuronsPerLayer(layer - 1);
		end
	end

	% Helps to know for a given node index to which layer it belongs.
	i = 1;
	for layer = 1:length(network.neuronsPerLayer)
		for k = 1:network.neuronsPerLayer(layer)
			network.layerIndexForNeuron(i) = k;
			network.layerForNeuron(i) = layer;
            i = i + 1;
		end
    end
    
    logging.errors = zeros(1,2^n,network.neuronCount);
    logging.errorIndexes = ones(2^n,network.neuronCount);
    logging.lastError = 0;
    logging.currentError = 0;
    logging.errorRepetition = 0;
end

% Retunrs the index of the node in the layer
% i.e. if the node is the first, second, third, etc. in the layer
function index = getNodeIndex(ni)
	global network
    for layer = 1:length(network.neuronsPerLayer)
		for k = 1:network.neuronsPerLayer(layer)
			ni = ni - 1;
      if ni == 0
          index = k;
      end
		end
	end
end

function indexes = getIndexesForLayer(layer)
  global network
  if (layer == 1)
      indexes = 1;
  else
      indexes = sum(network.neuronsPerLayer(1:layer-1)) + 1;
  end
end

% Converts a number to its size in bits
function out = binary2vector(data,nBits)
	powOf2 = 2.^(0:nBits-1);
	
	if data > sum(powOf2)
	   error('not enough bits to represent the data')
	end

	out = false(1,nBits);

	ct = nBits;

	while data>0
		if data >= powOf2(ct)
			data = data-powOf2(ct);
			out(ct) = true;
		end
		ct = ct - 1;
	end
	out = fliplr(out);
end

% Generates inputs for the network
function y = generateRandomInputs(n)
	global network
	intervalDiff = abs(network.intervals(1) - network.intervals(2));
	max = 2^n;
	k = 1;
	x = zeros(max,n+1);
	for i=0:max-1
		out = binary2vector(i,n);
		x(k,1) = 1;
		x(k,2:length(out)+1) = (out - 0.5) * intervalDiff;
		k = k + 1;
	end
	y = x;
end


function x = generateTrainingSets(n)
    global network
    network.problem.originalSet = n;
    from = network.data;
    allSets = zeros(length(from) - n, n + 2);
    trainingQty = ceil(length(from)*network.trainPctg);
    

    network.problem.expected = zeros(1);
    %construimos todos los sets posibles y sus respuestas
    for i=1:length(from)-n
        %input for neuralNetwork
        allSets(i,2:n+1) = from(i:i+n-1);
        %bias
        allSets(i,1) = 1;
        %expexted result
        allSets(i, n+2) = from(i+n);
    end
    % mezclamos los sets que generamos anteriormente
    for i=1:10000
        rand1 = ceil(rand() * length(allSets));
        rand2 = ceil(rand() * length(allSets));
        aux = allSets(rand1,:);
        allSets(rand1, :) = allSets(rand2, :);
        allSets(rand2, :) = aux;
    end
    %ponemos la respuesta en network.problem.expected
    for i=1:trainingQty
        network.trainingSet(i, :) = allSets(i,1:n+1);
        network.problem.expected(i) = allSets(i, n+2);
    end
    for i=trainingQty+1:length(allSets)
        network.testSet(i, :) = allSets(i,1:n+1);
        network.problem.expected(i) = allSets(i, n+2);
    end
    
    
    x = network.trainingSet;
end
