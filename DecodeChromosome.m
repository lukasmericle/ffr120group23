function [T1, W12, T2, W23] = DecodeChromosome(chromosome, nInputs, nHidden, nOutputs)
% parses chromosome and extracts matrices/vectors corresponding to NN
% weights/thresholds
counterLow = 1;
counterHigh = counterLow + nOutputs;
T1 = chromosome(counterLow:counterHigh-1);

counterLow = counterHigh;
counterHigh = counterLow + nHidden*nOutputs;
W12 = chromosome(counterLow:counterHigh-1);

counterLow = counterHigh;
counterHigh = counterLow + nHidden;
T2 = chromosome(counterLow:counterHigh-1);

counterLow = counterHigh;
counterHigh = counterLow + nInputs*nHidden;
W23 = chromosome(counterLow:counterHigh-1);

T1 = T1';
W12 = reshape(W12, nOutputs, nHidden);
T2 = T2';
W23 = reshape(W23, nHidden, nInputs);