% initPopulation();
% juail not ended
%     evaluateIndividuals();
%     seleccionar, aparear
%     recombinar, mutar
%     reemplazar
function genetic = genetic()
    genetic.run = @run
    genetic.init = @initPopulation
    genetic.generationCount = @generationCount
    genetic.generationBest = @generationBest
    genetic.generationContent = @generationContent
    genetic.generationStructure = @generationStructure
    genetic.best = @best
end

function x = generationBest(varargin)
    global genetic
    if genetic.bestError < genetic.bestTargetError
        x = 1;
    else
        x = 0;
    end
end

function x = generationCount(varargin)
    global genetic
    if genetic.counter == -1
        genetic.counter = genetic.generations;
    end
    if genetic.counter == 0
        x = 1;
    else
        genetic.counter = genetic.counter - 1;
        x = 0;
    end
end

function x = generationContent(varargin)
    global genetic
    if genetic.contentCounter == -1
        genetic.contentCounter = genetic.contentLimit;
        genetic.lastBest = 10;
    end
    if genetic.bestError < genetic.lastBest
        genetic.lastBest = genetic.bestError;
        genetic.contentCounter = genetic.contentLimit;
    else
        genetic.contentCounter = genetic.contentCounter - 1;
    end
    
    if genetic.contentCounter == 0
        x = 1;
    else
        x = 0;
    end
end



function x = generationStructure(varargin)
    global genetic
    errors = varargin{1}{2};
    if genetic.olderrors == -1
        genetic.olderrors = zeros(length(errors),1);
        genetic.structureCounter = genetic.structureLimit;
    end
    if mean(genetic.olderrors) ~= mean(errors)
        genetic.olderrors = errors;
        genetic.structureCounter = genetic.structureLimit;
    else
        genetic.structureCounter = genetic.structureCounter - 1;
    end
    
    if genetic.structureCounter == 0
        x = 1;
    else
        x = 0;
    end
end

function x = best(varargin)
    vals = [];
    for i=1:length(varargin{1})
      val = varargin{1}{i};
      vals(i) = val(varargin);
    end
    x = max(vals)
end

function x = run()
    global networks
    global network
    global genetic
    global networkData
    global util
    global allErrors
    networks = initPopulation(genetic.networkCount, genetic.arch);
    genetic.counter = -1;
    genetic.olderrors = -1;
    genetic.contentCounter = -1;
    genetic.bestError = 10;
    theTestSets = networks(1).data.trainingSet;
    theExpected = networks(1).data.problem.expected;
    ended = 0;
    evaluations = [];
    from = network.trainSize;
    k = 1000000;
    allErrors = [];
    minErrors = [];
    maxErrors = [];
    bestNet = {};
    while(k > 0)
        evaluations = [];
        ids = [];
        for i=1:length(networks)
            result = [];
            util.setNetwork(networks(i).data);
            
            for j=1:(genetic.checkSize)
                aux = network.eval(theTestSets(j,2:3));
                result(j) = theExpected(j) - aux;
            end
            error(i) = (sum(result.^2)/length(result));
            evaluations(i) = 1/error(i);
        end
        
        if (min(error) < genetic.bestError) 
            [genetic.bestError ind] = min(error);
            genetic.best = networks(ind).data.weights;
            bestNet = networks(ind).data;
        end
        
        evaluations
        
        allErrors = [allErrors mean(error)];
        minErrors = [minErrors min(error)];
        maxErrors = [maxErrors max(error)];
        networks =  genetic.replacementMethod(networks, evaluations);
        k = k - 1;
        
        figure(1);
        ecm = semilogy(allErrors, ':b');
        hold on;
        low = semilogy(minErrors, 'g');
        high = semilogy(maxErrors, '--r');
        %legend([ecm, high, low], {'Promedio', 'Maximo', 'Minimo'});
        xlabel('Épocas');
        ylabel('Error Cuadratico Medio');
        hold off;
%         print(figure(1),'result.png', '-dpng');
        
        
        if genetic.endMethod(genetic.endMethods, error)
           break;
        end
    end
    figure(1);
    ecm = semilogy(allErrors, ':b');
    hold on;
    low = semilogy(minErrors, 'g');
    high = semilogy(maxErrors, '--r');
    %legend([ecm, high, low], {'Promedio', 'Maximo', 'Minimo'});
    xlabel('Épocas');
    ylabel('Error Cuadratico Medio');
    hold off;
    print(figure(1),'result.png', '-dpng');
    
    
    util.setNetwork(bestNet);
    
    outs = []; 
    for i=1:998; 
        outs(i) = networkData.otherExpected(i) - network.eval(networkData.otherInput(i,2:3)); 
    end
    disp('ECM G6');
    genetic.otherecm2 = sum(outs.^2)/length(outs) 
    outs = []; 
    for i=1:(998 - genetic.checkSize); 
        outs(i) = network.problem.expected(genetic.checkSize + i) - network.eval(network.testSet(genetic.checkSize + i,2:3)); 
    end
    disp('ECM Testeo');
    genetic.testecm2 = sum(outs.^2)/length(outs)
    
    weights = genetic.best;
    save('weights.txt', 'weights', '-ascii');
    
end
    
function x = initPopulation(size, neuronsPerLayer)
    networks(1:size) = struct('x',[]);
    for k=1:size
        networks(k).data = initNetwork(neuronsPerLayer);
    end
    x = networks;
end


function net = initNetwork(neuronsPerLayer)
    global problem;
    global functs;
    global util;
    global initNetwork;
    global genetic;
    global network;
    global ids;
    
    network = initNetwork;
    % Control variables
    network.delta = 0.001; 
    network.startEta = 0.01;
    network.beta = 0.5;
    network.N = 10000;

    network.intervals = [-1 1];
    network.weights = [];

    network.problem = problem.approximation(2, functs.tanh);
    network.neuronsPerLayer = neuronsPerLayer;
    
    network.testSet = [];
    network.trainingSet = [];
    network.trainPctg = 0;

    network.adaptive = true;
    network.momentum = true;

    network.iterLimit = 200;
    network.trainSize = genetic.trainSize;
    network.n = 2;
    network.id = ids + 1;
    ids = ids + 1;
    
    network = util.setNetwork(network);
        
    util.networkPrepare(2, 1);
%     
%     aux = load('weightsBackup');
%     network.weights = aux;
%     
    
    
    net = network;
end
