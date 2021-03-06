function fs = ExtractGridHistogram(im, ng, nbins)
%EXTRACTGRIDHISTOGRAM Returns a column vector fs of size (ng*ng*nbins)1 
%   Divides an image in to a grid of subimages and calculates the histogram
%   of each grid unit. Returns a feature vector containing the concatenated
%   histograms.

im = single(rgb2gray(im));
im = (im - mean(im(:)))/ std(im(:));

xs = floor(linspace(1, size(im, 2)+1, ng+1));
ys = floor(linspace(1, size(im, 1)+1, ng+1));

fs = [];
for i=1:ng
    ii = xs(i):xs(i+1)-1;
    for j=1:ng
        jj = ys(j):ys(j+1)-1;
        % Extract image patch defined by ii and jj
        pim = im(jj, ii);
        % Compute histogram of the patch's pixel intensities
        pfs = hist(pim(:), nbins);
        % Normalize the histogram
        pfs = pfs(:)/sum(pfs);
        % Concatenate this histogram to fs
        fs = [fs; pfs];
    end
end

end