function dv = DeltaPhi(inputVectors, T1, W12, T2, W23, maxTurningAngle)
% computes turn according to NN and updates velocities

nnOutputs = NeuralNetworkComputation(inputVectors, T1, W12, T2, W23);
dv = nnOutputs*maxTurningAngle;