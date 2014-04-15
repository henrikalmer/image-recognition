function [mu, W, D] = ComputePCABasis(X)
%COMPUTEPCABASIS Compute eigenfaces of matrix X, as generated by LoadData

W = 1;
D = 1;

mu = mean(X,2);
Xc = bsxfun(@minus,X,mu);

d = size(X,1); n = size(X,2);
if d > n
    C1 = (1/n)*Xc'*Xc;
    [v, d] = eig(C1);
    W = X * v;
else
    C = (1/n)*Xc*Xc';
    [W, d] = eig(C);
end

D = diag(d);

end

