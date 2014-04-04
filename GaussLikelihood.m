function lvals = GaussLikelihood(xs, mu, Sigma)
%GAUSSLIKELIHOOD Calculates likelyhood that vector xs belongs to mu+Sigma
%   xs contains RGB pixel data. mu and Sigma are the mean vector and
%   covariance matrix describing the probability that a pixel belongs to a
%   certain class, given its RGB data. Returns an array of pixel by pixel
%   likelyhoods.

lvals = mvnpdf(double(xs), mu, Sigma);

end
