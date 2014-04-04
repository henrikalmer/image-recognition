function [mu, Sigma] = TrainColourModel(DirName, n, m)
%TRAINCOLOURMODEL Returns mean vector and covariance matrix for ims in Dir
%   Extracts the central pixels from each image in DirName and calculates
%   the mean vector and covariance matrix of those pixels. Choose colour
%   model RGB or HSV by setting m.

selector = [DirName, '/*.jpg'];
im_files = dir(selector);
ni = min(length(im_files), n);
addpath(DirName);

IMS = [];
for i=1:ni
    im = GrabCenterPixels(im_files(i).name, .2);
    im_data = reshape(im, [size(im,1)*size(im,2), 3]);
    if strcmp(m, 'HSV')
        im_hsv = rgb2hsv(im_data);
        im_data = zeros(size(im_hsv,1), 4);
        for i=1:size(im_data,1)
            im_data(i,1) = cos(im_hsv(i,1));
            im_data(i,2) = sin(im_hsv(i,1));
            im_data(i,3) = im_hsv(i,2);
            im_data(i,4) = im_hsv(i,3);
        end
    end
    IMS = [IMS; im_data];
end
mu = mean(IMS);
Sigma = cov(double(IMS));

end

