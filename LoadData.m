function [X, w, h] = LoadData(DirName, p)
%LOADDATA Loads images in dir and returns their normalized pixel data

selector = [DirName, '/*.jpg'];
im_files = dir(selector);

X = [];
ni = length(im_files);
addpath(DirName);
for i=1:ni
    im = imread(im_files(i).name);
    % convert image to grayscale
    gim = single(rgb2gray(im));
    im_size = size(gim);
    w = im_size(1); h = im_size(2);
    % grab center patch
    cim_size = [min(floor(p(1)*im_size(1)), im_size(1));
                min(floor(p(2)*im_size(2)), im_size(2))].';
    delta = floor((im_size - cim_size)/2);
    cim = circshift(gim, [-delta(1) -delta(2)]);
    cim = cim(1:cim_size(1), 1:cim_size(2), :);
    % normalize pixel data to introduce invariance in illumination effects
    mu = mean(mean(cim));
    sigma = std(std(cim));
    nim = (cim - mu) / sigma;
    X = [X reshape(nim, [size(nim,1)*size(nim,2) 1])];
end

end
