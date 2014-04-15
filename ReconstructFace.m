function rim = ReconstructFace(im, mu, W, w, h, N)
%RECONSTRUCTFACE Summary of this function goes here

% convert to grayscale and cast as double precision
if size(im, 3) > 3
    pim = double(rgb2gray(im));
else
    pim = double(im);
end
im_size = size(pim);
pim = imresize(pim, [w h]);

% normalize
im_mean = mean(pim(:));
im_std = std(pim(:));
nim = (pim(:) - im_mean) / im_std;

% project normalized image on top of eigenfaces and reconstruct im
% get eigenface
Fs = W(:,1:N);
% project im on eigenfaces
cs = Fs' * (nim - mu);
% reconstruct image
hat_x = mu + Fs * cs;
% undo normalization
hat_im = im_std * reshape(hat_x, w, h) + im_mean;

% reshape and resize
rim = imresize(hat_im, im_size);

end
