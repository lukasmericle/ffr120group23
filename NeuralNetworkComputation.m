function turningAngles = NeuralNetworkComputation(inputVectors, T1, W12, T2, W23)
turningAngles = zeros(1, size(inputVectors, 1));
for i = 1:size(inputVectors, 1)
    hiddenFields = mtimes(W23, inputVectors(i,:)') - T2;
    hiddenActivations = tanh(hiddenFields);
    outputField = mtimes(W12, hiddenActivations) - T1;
    outputActivation = tanh(outputField);
    turningAngles(i) = outputActivation;
end