function [T1, W12, T2, W23] = DecodeChromosome(chromosome, mySimParams)
% parses chromosome and extracts matrices/vectors corresponding to NN
% weights/thresholds
counterLow = 1;
counterHigh = counterLow + mySimParams.nOutputs;
T1 = chromosome(counterLow:counterHigh-1);

counterLow = counterHigh;
counterHigh = counterLow + mySimParams.nHidden*mySimParams.nOutputs;
W12 = chromosome(counterLow:counterHigh-1);

counterLow = counterHigh;
counterHigh = counterLow + mySimParams.nHidden;
T2 = chromosome(counterLow:counterHigh-1);

counterLow = counterHigh;
counterHigh = counterLow + mySimParams.nInputs*mySimParams.nHidden;
W23 = chromosome(counterLow:counterHigh-1);

T1 = T1';
W12 = reshape(W12, mySimParams.nOutputs, mySimParams.nHidden);
T2 = T2';
W23 = reshape(W23, mySimParams.nHidden, mySimParams.nInputs);