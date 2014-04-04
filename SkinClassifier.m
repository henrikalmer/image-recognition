function bim = SkinClassifier(im, m)
%SKINCLASSIFIER Attempts to determine skin regions of an image

if strcmp(m, 'HSV')
    [mu_skin, Sigma_skin] = TrainColourModel('Pics/George_W_Bush', 20, 0.2, 'HSV');
    [mu_other, Sigma_other] = TrainColourModel('Pics/BackgroundImages', 20, 1, 'HSV');
else
    [mu_skin, Sigma_skin] = TrainColourModel('Pics/George_W_Bush', 20, 0.2, 'RGB');
    [mu_other, Sigma_other] = TrainColourModel('Pics/BackgroundImages', 20, 1, 'RGB');
end

xs = reshape(im, [size(im,1)*size(im,2), 3]);
lvals_skin = GaussLikelihood(xs, mu_skin, Sigma_skin, m);
lvals_other = GaussLikelihood(xs, mu_other, Sigma_other, m);

likelihoods = zeros(size(lvals_skin));
for i=1:size(likelihoods,1)
    likelihoods(i) = (log(lvals_skin(i)) - log(lvals_other(i))) > 0;
end

bim = reshape(likelihoods, [size(im, 1), size(im, 2)]);

end
