function r = replacement()
    r.method1 = @rmethods1;
    r.method2 = @rmethods2;
    r.method3 = @rmethods3;
end

function x = rmethods1(networks, evaluations)
    global genetic;
    global crossOverProbability;
    global ids;
    global mix_i;
    nextGeneration = networks;
    N = ceil(length(networks)/2);
    mix_i = 1;
    selection = genetic.firstSelectionMethod(evaluations, 2 * N);
    for i=1:N
       winner1 = networks(selection(2 * i - 1)).data;
       winner2 = networks(selection(2 * i)).data;     
       
       winner1.id = ids;
       winner2.id = ids + 1;
       
       ids = ids + 2;
       
       randomNr = rand;
        if(randomNr < crossOverProbability)
           [child1, child2] = genetic.crossoverMethod(winner1, winner2);
        else
            child1 = winner1;
            child2 = winner2;
        end

       nextGeneration(2 * i - 1).data = genetic.train(genetic.mutate(child1));
       if (2 * i <= length(networks))
           nextGeneration(2 * i).data = genetic.train(genetic.mutate(child2));
       end
    end
    
    x = nextGeneration;
end

function x = rmethods2(networks, evaluations)
    global genetic;
    global ids;
    global mix_i;
    
    N = (length(networks));
    mix_i = 1; % ugly
    toChange = genetic.firstSelectionMethod(evaluations, floor(genetic.method2K / 2) * 2);
    mix_i = 2;
    toStay = genetic.secondSelectionMethod(evaluations, N - floor(genetic.method2K / 2) * 2);
    resnextGeneration(1:length(toChange) + length(toStay)) = struct('x',[]);
    for i=1:length(toStay)
        resnextGeneration(i).data = networks(toStay(i)).data;
        resnextGeneration(i).data.id = ids;
        ids = ids + 1;
    end

    M = length(toStay);

    for j=1:length(toChange) / 2
        p1 = networks(toChange(ceil(rand() * genetic.method2K))).data;
        p2 = networks(toChange(ceil(rand() * genetic.method2K))).data;
        randomNr = rand;
        
        [c1, c2] = genetic.crossoverMethod(p1, p2);
        
        c1.id = ids;
        c2.id = ids + 1;
        
        ids = ids + 2;
        resnextGeneration(M + 2 * j - 1).data = genetic.train(genetic.mutate(c1));
        if (M + 2 * j <= N)
            resnextGeneration(M + 2 * j).data = genetic.train(genetic.mutate(c2));
        end
    end
    

    
    x = resnextGeneration;
end

function x = rmethods3(networks, evaluations)
    global genetic;
    global network;
    global util;
    global ids;
    global mix_i;
    selection = [];
    nextGeneration = struct('x',[]);
    N = ceil(length(networks)/2);
    for i=1:genetic.k
       mix_i = 1;
       selection = genetic.firstSelectionMethod(evaluations, 2);
       winner1 = networks(selection(1)).data;
       winner2 = networks(selection(2)).data;
       
              
       winner1.id = ids;
       winner2.id = ids + 1;
       
       ids = ids + 2;
       
       [child1 child2] = genetic.crossoverMethod(winner1, winner2);
       nextGeneration(i).data = genetic.train(genetic.mutate(child1));
    end
    nextGenerationEvaluations = [];
    error=[];
    for i=1:length(nextGeneration)
        result = [];
        util.setNetwork(nextGeneration(i).data);
        for j=1:genetic.checkSize
            aux = network.eval(network.trainingSet(j,2:3));
            result(j) = aux - network.problem.expected(j);
        end
        error(i) = sum(result.^2)/length(result);
        nextGenerationEvaluations(i) = 1/(error(i).^2);
    end
    len = length(evaluations);
    newLen = length(nextGenerationEvaluations);
    evaluations(len:len+newLen-1) = nextGenerationEvaluations(1:newLen);
    mix_i = 2;
    
    evaluations
    selection = genetic.secondSelectionMethod(evaluations, length(networks));
    
    netLen = length(networks);
    
    for i=1:length(selection)
        if (selection(i) <= netLen)
            x(i) = networks(selection(i));
        else
            x(i) = nextGeneration(selection(i) - netLen);
        end
    end
    
    x;
end