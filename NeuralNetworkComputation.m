function outputActivations = NeuralNetworkComputation(inputVectors, T1, W12, T2, W23)
% compute the neural network output of each agent according to its inputs

hiddenFields = mtimes(W23, inputVectors) - T2;
hiddenActivations = tanh(hiddenFields);
outputField = mtimes(W12, hiddenActivations) - T1;
outputActivations = tanh(outputField)';