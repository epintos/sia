function funct = funct()
    funct.sigmoide.f = @tanhf;
    funct.sigmoide.df = @tanhdf;
    funct.step.f = @step;
    funct.step.df = @derivStep;
    funct.lineal.f = @lineal;
    funct.lineal.df = @derivStep;
    funct.exp.f = @expf;
    funct.exp.df = @expdf;
    funct.tanh.f = @tanhf;
    funct.tanh.df = @tanhdf;
end

function x = step(in)
	global network
	if (in < 0)
		x = network.intervals(1);
	else
		x = network.intervals(2);
	end
end

function x = derivStep(in)
	x = 1;
end

function x = tanhf(in)
	global network
	x = tanh(network.beta * in) * 1;
end

function x = tanhdf(in)
	global network
	x = network.beta * sech(in).^2 * 1;
end

function x = expf(in)
    global network
    x = (2/(1+exp((-1)*network.beta*in)) - 1);
end

function x = expdf(in)
    global network
    x = 2 * network.beta * exp(network.beta * in) / ((exp(network.beta * in) + 1)^2);
end

function x = lineal(in)

end