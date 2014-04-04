function lvals = GaussLikelihood(xs, mu, Sigma, m)
%GAUSSLIKELIHOOD Calculates likelyhood that vector xs belongs to mu+Sigma
%   xs contains RGB pixel data. mu and Sigma are the mean vector and
%   covariance matrix describing the probability that a pixel belongs to a
%   certain class, given its RGB data. Returns an array of pixel by pixel
%   likelyhoods. Choose colour model RGB or HSV by setting m.

if strcmp(m, 'HSV')
    xs_hsv = rgb2hsv(xs);
    xs = zeros(size(xs_hsv,1), 4);
    for i=1:size(xs,1)
        xs(i,1) = cos(xs_hsv(i,1));
        xs(i,2) = sin(xs_hsv(i,1));
        xs(i,3) = xs_hsv(i,2);
        xs(i,4) = xs_hsv(i,3);
    end
end

lvals = mvnpdf(double(xs), mu, Sigma);

end
