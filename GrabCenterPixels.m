function cim = GrabCenterPixels(im_fname, p)
%GRABCENTERPIXELS Grabs the centre rectangular region from the image
%   p is used to define a percentage of the pixels from the center of the
%   image to be returned.

im = imread(im_fname);
im_size = size(im);

% extract center region
cim_size = [min(floor(p*im_size(1)), im_size(1));
            min(floor(p*im_size(2))*3, im_size(2));
            3].';
delta = floor((im_size - cim_size)/2);
cim = circshift(im, [-delta(1) -delta(2)]);
cim = cim(1:cim_size(1), 1:cim_size(2), :);

end
