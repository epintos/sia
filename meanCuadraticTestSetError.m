global network;
result = [];
total = length(network.testSet(:,2:network.n+1)) - length(network.trainingSet(:,2:network.n+1))
from = 1000-total-network.n;
for i=from+1:1000-network.n
    aux = network.eval(network.testSet(i,2:network.n+1))*3.8;
    result(i-from) = aux - network.problem.expected(i)*3.8;
end
disp('M�ximo error..');
max(abs(result))
disp('M�nimo error...');
min(abs(result))
disp('Error cuadr�tico medio...');
sum(result.^2)/length(result)
disp('Cantidad de puntos con error por debajo de 0.1...');
length(find(abs(result') <= 0.1))
disp('Cantidad de puntos con error por debajo de 0.2...');
length(find(abs(result') <= 0.2))
disp('Cantidad de puntos con error por debajo de 0.3...');
length(find(abs(result') <= 0.3))
disp('Cantidad de puntos con error por debajo de 0.4...');
length(find(abs(result') <= 0.4))