function D = ComputeDistanceMatrix(Fs)
%COMPUTEDISTANCEMATRIX Return the Euclidean distance between images in Fs
%   Computes the Euclidean distance between each pair of images in Fs. Fs
%   is assumed to be one cell of the matrix returned by ComputeDescriptors.

im_size = size(Fs);
n_ims = im_size(2);

D = zeros(n_ims, n_ims);
for i=1:n_ims
    f1 = Fs(:,i);
    for j=1:n_ims
        f2 = Fs(:,j);
        distance = sqrt(sum((f1 - f2).*(f1 - f2)));
        D(i,j) = distance;
    end
end

end

