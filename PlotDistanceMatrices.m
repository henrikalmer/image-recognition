function [] = PlotDistanceMatrices(Fs)
%PLOTDISTANCEMATRICES Plots distance matrices as images.
%   The input Fs is assumed to be a cell matrix as returned by
%   ComputeDescriptors. For each cell a distance matrix is computed and
%   plotted in a figure.

D1 = ComputeDistanceMatrix(Fs{1});
D2 = ComputeDistanceMatrix(Fs{2});
D3 = ComputeDistanceMatrix(Fs{3});
D4 = ComputeDistanceMatrix(Fs{4});

figure(1);

subplot(2,2,1);
imagesc(D1);
title('Template');

subplot(2,2,2);
imagesc(D2);
title('Histogram');

subplot(2,2,3);
imagesc(D3);
title('Grid histogram');

subplot(2,2,4);
imagesc(D4);
title('SIFT');

end

