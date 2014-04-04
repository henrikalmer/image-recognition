function [mu, Sigma] = TrainColourModel(DirName, n)
%TRAINCOLOURMODEL Returns mean vector and covariance matrix for ims in Dir
%   Extracts the central pixels from each image in DirName and calculates
%   the mean vector and covariance matrix of those pixels.

selector = [DirName, '/*.jpg'];
im_files = dir(selector);
ni = min(length(im_files), n);
addpath(DirName);

RGB = [];
for i=1:ni
    im = GrabCenterPixels(im_files(i).name, .2);
    RGB = [RGB; reshape(im, [size(im,1)*size(im,2), 3])];
end
mu = mean(RGB);
Sigma = cov(double(RGB));

end

