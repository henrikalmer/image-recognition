function Fs = ComputeDescriptors(DirName, nbins, ng)
%COMPUTEDESCRIPTORS Returns a cell array of descriptors for images in Dir.
%   The output Fs is a cell array of length 4. Each cell entry is a matrix
%   of size nf_i*n_i where n_i is the number of images in the directory and
%   nf_i is the dimension of the i:th extracted feature vecto r. Returned
%   descriptors are:
%       1. Template (fs1 of length defined by the image)
%       2. Histogram (fs2 of length nbins)
%       3. Grid histogram (fs3 of length ng*ng*nbins)
%       4. SIFT (fs4 of length 128)

selector = [DirName, '/*.png'];
im_files = dir(selector);

Fs = cell(1, 4);
ni = length(im_files);
addpath(DirName);
for i=1:ni
    im = imread(im_files(i).name);
    nim = single(rgb2gray(im));
    nim = (nim - mean(nim(:)))/ std(nim(:));
    % Calculate template descriptor
    fs1 = nim(:);
    % Calculate histogram
    fs2 = hist(nim(:), nbins);
    fs2 = fs2(:)/sum(fs2);
    % Calculate grid histogram
    fs3 = ExtractGridHistogram(im, ng, nbins);
    % Calculate SIFT
    fs4 = ExtractSiftDescriptor(im);
    
    % Add to Fs
    Fs{1} = [Fs{1}, fs1];
    Fs{2} = [Fs{2}, fs2];
    Fs{3} = [Fs{3}, fs3];
    Fs{4} = [Fs{4}, fs4];
end

end

