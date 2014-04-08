function AlignIms
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Load the images
  ni = 8;
  ims = cell(1, ni);
  X = [];
  for i=1:ni
    fname = sprintf('warped_train_digit7_%d.png', i);
    ims{i} = single(imread(fname))/255;
    X = [X, ims{i}(:)];
  end
  wid = size(ims{1}, 2);
  hei = size(ims{1}, 1);     
  
  %% mean of the original image
  sMean = mean(X, 2);  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Initialize the parameters: mean and Sigma
  Mean = X(:, 2);
  Sigma = .1*diag(ones(1, wid*hei));   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% enumerate the set of all possible discrete translations
  t_max = 6;
  xs = -t_max:t_max;
  ys = -t_max:t_max;
  [Xs, Ys] = meshgrid(xs, ys);
  
  Hs = [Xs(:), Ys(:)];      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% The EM iterations
  n_iters = 5;
  for iter =1:n_iters
    h_posteriors = ComputePosteriors(ims, Hs, Mean, Sigma);  
    [Mean, Sigma] = UpdateParams(ims, Hs, h_posteriors);        
  end    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Align the images
  t_ims = cell(size(ims));
  for i=1:ni
    %% Find the best transformation for datapoint i
    [mh, ind] = max(h_posteriors(:, i));
    
    %% Apply the transformation to the unaligned images
    t_ims{i} = TransformImage(ims{i}, Hs(ind, 1), Hs(ind, 2)); 
  end   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% display all the images
  
  %% unaligned images
  figure(1)
  clf
  uims = cell(length(ims)+1, 1);
  for i=1:length(ims)
    uims{i} = ims{i};
  end  
  uims{end} = reshape(sMean, hei, wid);
  montage(uims, 'Size', [1, ni+1]);
  
  %% aligned images
  figure(2)
  clf
  aims = cell(length(ims)+1, 1);
  for i=1:length(t_ims)
    aims{i} = t_ims{i};
  end  
  aims{end} = reshape(Mean, hei, wid);  
  montage(aims, 'Size', [1, ni+1]);      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% write the computed images to file
% $$$   
% $$$   imwrite(reshape(sMean, hei, wid), 'warped_train_digit7_mean.png', 'png');  
% $$$   %% code to write images
% $$$   for i=1:length(t_ims)
% $$$     fname = sprintf('unwarped_train_digit7_%d.png', i+3);    
% $$$     imwrite(t_ims{i}, fname, 'png');
% $$$   end
% $$$   imwrite(reshape(Mean, hei, wid), 'unwarped_train_digit7_mean.png', 'png');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Compute the posterior for the translation for each datapoint
%% given the current estimates of the parameters
function h_posteriors = ComputePosteriors(ims, Hs, Mean, Sigma)  
    
  ni = length(ims);
  h_posteriors = zeros(size(Hs, 1), ni);  
  dd = diag(Sigma);    
  dd1 = 1./dd;
  %% note we have to cope with the fact that the variance of some
  %% dimensions is 0
  dd1(isinf(dd1)) = 0;
  inv_Sigma = diag(dd1);  
  
  for i=1:ni
    for h=1:size(Hs, 1)
      n_im = TransformImage(ims{i}, Hs(h, 1), Hs(h, 2));      
      D = n_im(:) - Mean;
      h_posteriors(h, i) = D' * inv_Sigma * D;
    end
  end
  
  %% note here how I have been careful about computing the exp
  %% because of the very small probabilities involved
  for i=1:ni
    h_posteriors(:, i) = exp(-5.*(h_posteriors(:, i) - min(h_posteriors(:,i))));
    h_sum = sum(h_posteriors(:, i));
    h_posteriors(:, i) = h_posteriors(:, i) / h_sum;
  end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Maximization step of EM
function [Mean, Sigma] = UpdateParams(ims, Hs, h_posteriors)
  
  ni = length(ims);  
  h_total = ni;
  
  %% update the value of mu
  Mean = zeros(numel(ims{1}), 1);
  for i=1:ni
    for h=1:size(Hs, 1)
      n_im = TransformImage(ims{i}, Hs(h, 1), Hs(h, 2));      
      Mean = Mean + n_im(:) * h_posteriors(h, i);
    end
  end
  Mean = Mean / h_total;
  
  %% update the value of Sigma
  dd = zeros(numel(ims{1}), 1);
  for i=1:ni
    for h=1:size(Hs, 1)
      n_im = TransformImage(ims{i}, Hs(h, 1), Hs(h, 2));      
      e = n_im(:) - Mean;
      dd = dd + h_posteriors(h, i) * (e .* e);
    end
  end
  dd = dd/h_total;
  Sigma = diag(dd);  
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function trans_im = TransformImage(im, tx, ty)  
  
  trans_im = zeros(size(im));
  for i=max(1, 1-ty):min(size(im, 1)-ty, size(im, 1))
    for j=max(1, 1-tx):min(size(im, 2)-tx, size(im, 2))
      trans_im(i+ty, j+tx) = im(i, j);
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Matlab functions exist to perform this transformation
  %% These functions can be used to apply any form of affine
  %% transformation 
  
% $$$   xform = [ 1  0  0
% $$$           0  1  0
% $$$          tx ty  1 ];
% $$$   
% $$$   tform_translate = maketform('affine',xform);
% $$$   
% $$$   trans_im = imtransform(im, tform_translate,...
% $$$                 'XData', [1 (size(im,2)+xform(3,1))],...
% $$$                 'YData', [1 (size(im,1)+xform(3,2))],...
% $$$                 'FillValues', 0);
% $$$   
% $$$   trans_im = trans_im(1:size(im, 1), 1:size(im, 2));  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
