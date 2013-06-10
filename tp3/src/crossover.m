function c = crossover()
    c.getWeightsArray = @getWeightsArray;
    c.getWeightsMatrix = @getWeightsMatrix;
    c.onePointCrossover = @onePointCrossover;
    c.twoPointCrossover = @twoPointCrossover;
    c.anularCrossOver = @anularCrossOver;
    c.uniformParametrizedCrossOver = @uniformParametrizedCrossOver;
    c.mutate = @mutate;
    c.train = @train;
    c.test= @test;
end

function test()
    global crossover;
    global genetic;
    global networks;
    global mutationProbability;
    c = crossover;
    networks = genetic.init(10, [3 2 1], 10);
    
    
    % Tests mutations
    
    old = networks(1).data;
    
    mutationProbability = 1;
    oldWeights = networks(1).data.weights;
    networks(1).data = c.mutate(networks(1).data);
    newWeights = networks(1).data.weights;
    if (sum(sum(oldWeights - newWeights)) ~= 0)
       disp('Mutation OK');
    else
       disp('Mutation FAILED');
    end
    
    networks(1).data = old;
    
    % Tests single crossover
    
    old1 = networks(1).data;
    old2 = networks(2).data;
    
    o1 = networks(1).data.weights;
    o2 = networks(2).data.weights;
    [ networks(1).data, networks(2).data ] = c.onePointCrossover(networks(1).data, networks(2).data);
    n1 = networks(1).data.weights;
    n2 = networks(2).data.weights;
    
    if (min((o1(:) == n1(:))) == 0)
        if (min((o2(:) == n2(:))) == 0)
           disp('Crossover simple OK');
        else
           disp('Crossover simple FAILED');
        end
    else
       disp('Crossover simple FAILED');
    end
    
    networks(1).data = old1;
    networks(2).data = old2;
    
    
    
    % Tests two point crossover
    
    old1 = networks(1).data;
    old2 = networks(2).data;

    
    o1 = networks(1).data.weights;
    o2 = networks(2).data.weights;
    [ networks(1).data, networks(2).data ] = c.twoPointCrossover(networks(1).data, networks(2).data);
    n1 = networks(1).data.weights;
    n2 = networks(2).data.weights;
    
    if (min((o1(:) == n1(:))) == 0)
        if (min((o2(:) == n2(:))) == 0)
           disp('Crossover 2p OK');
        else
           disp('Crossover 2p FAILED');
        end
    else
       disp('Crossover 2p FAILED');
    end
    
    networks(1).data = old1;
    networks(2).data = old2;
    

    % Tests anular crossover

    old1 = networks(1).data;
    old2 = networks(2).data;    
    
    o1 = networks(1).data.weights;
    o2 = networks(2).data.weights;
    [ networks(1).data, networks(2).data ] = c.anularCrossOver(networks(1).data, networks(2).data);
    n1 = networks(1).data.weights;
    n2 = networks(2).data.weights;
    
    if (min((o1(:) == n1(:))) == 0)
        if (min((o2(:) == n2(:))) == 0)
           disp('Crossover anular OK');
        else
           disp('Crossover anular FAILED');
        end
    else
       disp('Crossover anular FAILED');
    end
    
    networks(1).data = old1;
    networks(2).data = old2;
    
    % Tests uniform crossover

    global crossOverProbability;
    
    crossOverProbability = 1;
    
    old1 = networks(1).data;
    old2 = networks(2).data;    
    
    o1 = networks(1).data.weights;
    o2 = networks(2).data.weights;
    [ networks(1).data, networks(2).data ] = c.uniformParametrizedCrossOver(networks(1).data, networks(2).data);
    n1 = networks(1).data.weights;
    n2 = networks(2).data.weights;
    
    if (min((o1(:) == n1(:))) == 0)
        if (min((o2(:) == n2(:))) == 0)
           disp('Crossover uniform OK');
        else
           disp('Crossover uniform FAILED');
        end
    else
       disp('Crossover uniform FAILED');
    end
    
    networks(1).data = old1;
    networks(2).data = old2;

    
end


%Paso de una matriz de pesos a un array.
%Deberíamos recibir la cantidad de bits de entrada.
function weightsArray = getWeightsArray(network, n)
    neuronsPerLayer = network.neuronsPerLayer;
    weights = network.weights;
    weightsArray = zeros(1,1);
    length = 1;
    len = size(network.weights);
    weightQty = 0;
    for i=1:len(1)
        layer = network.layerForNeuron(i);
        %va hasta + 1 por el peso del bias
        if (layer > 1)
            weightQty = neuronsPerLayer(layer-1)+1;
        else
            weightQty = n + 1;
        end
        weightsArray(length:length + weightQty - 1) = weights(i,1:weightQty);
        length = length + weightQty;
    end
end

function weightsMatrix = getWeightsMatrix(network, weightsArray, n)
    neuronsPerLayer = network.neuronsPerLayer;
    weightsMatrix = [];
    length = 1;
    len = size(network.weights);
    weightQty = 0;
    for i=1:len(1)
        layer = network.layerForNeuron(i);
        %va hasta + 1 por el peso del bias
        if (layer > 1)
            weigthQty = neuronsPerLayer(layer-1)+1;
        else
            weigthQty = n + 1;
        end
        network.weights(i,1:weigthQty) = weightsArray(length:length + weigthQty - 1);
        length = length + weigthQty;
    end
    weightsMatrix = network.weights;
end

function [ c1, c2 ] = onePointCrossover(network1, network2)
    weights1 = getWeightsArray(network1, network1.n);
    weights2 = getWeightsArray(network2, network2.n);
    
    swapPoint = ceil(rand() * length(weights1));
    
    for i=swapPoint:length(weights1)
        aux1 = weights1(i);
        aux2 = weights2(i);
        weights1(i) = aux2;
        weights2(i) = aux1;
    end
    network1.weights = getWeightsMatrix(network1, weights1, network1.n);
    network2.weights = getWeightsMatrix(network2, weights2, network2.n);
    c1 = network1;
    c2 = network2;
end

function [ c1, c2 ]= twoPointCrossover(network1, network2)
    weights1 = getWeightsArray(network1, network1.n);
    weights2 = getWeightsArray(network2, network2.n);
    
    swapPoint = ceil(rand() * length(weights1));
    endSwapPoint = ceil(rand() * length(weights1));
    
    aux = endSwapPoint;
    endSwapPoint = swapPoint;
    swapPoint = aux;
    
    for i=swapPoint:endSwapPoint
        aux1 = weights1(i);
        aux2 = weights2(i);
        weights1(i) = aux2;
        weights2(i) = aux1;
    end
    network1.weights = getWeightsMatrix(network1, weights1, network1.n);
    network2.weights = getWeightsMatrix(network2, weights2, network2.n);
    c1 = network1;
    c2 = network2;
end

function [ c1, c2 ] = anularCrossOver(network1, network2)
    weights1 = getWeightsArray(network1, network1.n);
    weights2 = getWeightsArray(network2, network2.n);
    
    swapPoint = ceil(rand() * length(weights1));
    endSwapPoint = ceil(rand() * length(weights1));
    finish = endSwapPoint;
    if (endSwapPoint < swapPoint) 
        finish = length(weights1);
    end
    
    for i=swapPoint:finish
        aux = weights1(i);
        weights1(i) = weights2(i);
        weights2(i) = aux;
    end
    
    if (endSwapPoint < swapPoint)
        for i=1:endSwapPoint
            aux = weights1(i);
            weights1(i) = weights2(i);
            weights2(i) = aux;
        end
    end
    
    network1.weights = getWeightsMatrix(network1, weights1, network1.n);
    network2.weights = getWeightsMatrix(network2, weights2, network2.n);
    c1 = network1;
    c2 = network2;
end

function [c1, c2] = uniformParametrizedCrossOver(network1, network2)
    global crossOverProbability;
    weights1 = getWeightsArray(network1, network1.n);
    weights2 = getWeightsArray(network2, network2.n);
    
    for i=1:length(weights1)
        randomNr = rand();
        if(rand < crossOverProbability) 
            aux = weights1(i);
            weights1(i) = weights2(i);
            weights2(i) = aux;
        end
    end
    
    network1.weights = getWeightsMatrix(network1, weights1, network1.n);
    network2.weights = getWeightsMatrix(network2, weights2, network2.n);
    c1 = network1;
    c2 = network2;
end

function child = mutate(network) 
    global mutationProbability;
    weights = getWeightsArray(network, network.n);
    high = max(weights);
    low = min(weights);
    for i=1:length(weights)
        randomNr = rand();
        factor = 1;
        if(randomNr < 0.5)
            factor = -1;
        end
        if(randomNr < mutationProbability)
            weights(i) = rand() * 20 - 10;
        end
    end
    network.weights = getWeightsMatrix(network, weights, network.n);
    child = network;
end

function child = train(net)
    global trainProbability;
    global util;
    global network;
    global genetic;
    global iterationsN;
    randN = rand();
    if randN < trainProbability;
        disp('train');
        util.setNetwork(net);
        iterationsN = genetic.iterations;
        network.retrain(2);
        trainProbability = trainProbability * 0.5;
        child = network;
    else
        child = net;
    end
end
