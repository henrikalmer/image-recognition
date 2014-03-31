function fs = ExtractSiftDescriptor(im)
%EXTRACTSIFTDESCRIPTOR Returns a SIFT feature vector
%   Requires the Matlab package VLFeat.

im = single(rgb2gray(im));
im = (im - mean(im(:)))/ std(im(:));

w = size(im, 1);
sc = (w-2)/ 12;
fc = [w/2; w/2; sc; 0];
[fc, fs] = vl_sift(im, 'frames', fc);
fs = double(fs(:));

end

