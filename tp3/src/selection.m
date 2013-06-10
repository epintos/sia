function s = selection()
    s.roulette = @rouleteSelection;
    s.universal = @universalEstocasticSelection;
    s.boltzman = @boltzmanSelection;
    s.tournament = @tournamentSelection;
    s.rank = @rankSelection;
    s.elite = @eliteSelection;
    s.mix = @mixSelection;
end


% These functions select n individuals depending on the method
% They return an array of ints that represent which individual was selected
% from the evaluations array.

function selection = rouleteSelection(evaluations, n)
    selection = [];
    %suma de todos los elementos de evaluations
    suma = sum(evaluations);
    %para cada valor, ev/sum
    evaluations = evaluations./suma;
    cumSum = 0;
    %en cada lugar de evaluations queda la probabilidad acumulada de cada
    %valor
    for i=1:length(evaluations)
        cumSum = cumSum + evaluations(i);
        evaluations(i) = cumSum;
    end
    %selecciono n elementos
    for j=1:n
        randomNr = rand() * max(evaluations);
        selected = 0;
        for k=1:length(evaluations)
            if (randomNr < evaluations(k))
                evaluations(k) = -1;
                selected = k;
                break;
            end
        end
        selection(j) = selected;
    end
    
end


function selection = universalEstocasticSelection(evaluations, n)
    %suma de todos los elementos de evaluations
    suma = sum(evaluations);
    %para cada valor, ev/sum
    evaluations = evaluations./suma;
    cumSum = 0;
    %en cada lugar de evaluations queda la probabilidad acumulada de cada
    %valor
    for i=1:length(evaluations)
        cumSum = cumSum + evaluations(i);
        evaluations(i) = cumSum;
    end
    selection = [];
    %selecciono n elementos
    randomNr = unifrnd(0,1/n);
    previous = 1;
    for j=1:n
        selected = 0;
        for k=previous:length(evaluations)
            selected = k;
            if ((randomNr + (k-1)*1/n) < evaluations(k))
                previous = k;
                break;
            end
        end
        selection(j) = selected;
    end
end

%no se como calcular el valor medio temporal
function selection = boltzmanSelection(evaluations, n)
    global boltzman
    if boltzman.mean == 0
        boltzman.mean = ones(1000,1);
        boltzman.t = 1;
        boltzman.count = 0;
    end
    
    vals = [];
    for i=1:length(evaluations)
        vals(i) = exp(evaluations(i) / boltzman.t) / boltzman.mean(i);
        boltzman.mean(i) = (boltzman.count * boltzman.mean(i) + vals(i)) / (1 + boltzman.count);
    end
    
   for j=1:n
        randomNr = rand() * max(vals);
        selected = 0;
        for k=1:length(vals)
            if (randomNr < vals(k))
                vals(k) = -1;
                selected = k;
                break;
            end
        end
        selection(j) = selected;
    end
    
    boltzman.count = boltzman.count + 1;
    boltzman.t = boltzman.t * 0.9999;
end

function selection = tournamentSelection(evaluations, n) 
    for i=1:n
        a = ceil(rand() * n);
        b = ceil(rand() * n);
        randomNr = rand();
        if(randomNr < 0.75) 
            %selecciono al mas apto
            if (evaluations(a) > evaluations(b))
                selection(i) = a;
            else
                selection(i) = b;
            end
        else
            %selecciono al menos apto
            if (evaluations(a) > evaluations(b))
                selection(i) = b;
            else
                selection(i) = a;
            end     
        end
    end
end

function selection = rankSelection(evaluations, n)
    sorted = [];
    indexes = [];
    [sorted indexes] = sort(evaluations, 2, 'descend');
    probabilities = [];
    N = length(sorted);
    for i=1:length(sorted)
        probabilities(i) = (N-(i-1))/ (N*(N+1)/2);
    end
    
    cumSum = 0;
    %en cada lugar de evaluations queda la probabilidad acumulada de cada
    %valor
    for i=1:length(probabilities)
        cumSum = cumSum + probabilities(i);
        probabilities(i) = cumSum;
    end
    %selecciono n elementos
    for j=1:n
        randomNr = rand() * max(probabilities);
        selected = 0;
        for k=1:length(probabilities)
            selected = k;
            if (randomNr < probabilities(k))
                probabilities(k) = -1;
                break;
            end
        end
        selection(j) = indexes(selected);
    end
    
end

function selection = mixSelection(evaluations, n)
    % Pecados, pecados y más pecados...
    % Pero anda en matlab y octave
    % Esto se resolvería *mucho* mejor con nested functions
    % Pero octave no lo tiene
    global mix_i
    global genetic
    functs = genetic.mixes{mix_i};
    selection = [functs{1}(evaluations, genetic.mixK(mix_i)), functs{2}(evaluations, n-genetic.mixK(mix_i))];
end

function selection = eliteSelection(evaluations, n)
    sorted = [];
    indexes = [];
    [sorted indexes] = sort(evaluations, 2, 'descend');
    
    for i=1:n
        selection(i) = indexes(i);
    end
end

