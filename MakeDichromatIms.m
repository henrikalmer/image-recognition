function [pim, dim] = MakeDichromatIms(im)
%MAKEDICHROMATIMS Takes an image as input and outputs two images
%   One of the images is how a protan dichromat would perceive the input
%   image and the other how a deutan dichromat would.

% Read input
im = double(im);
im_size = size(im);

% Define transformation matrices
M = [17.8824 43.5161 4.11935;
     3.45565 27.1554 3.86714;
     0.0299566 0.184309 1.46709];
P = [0 2.02344 -2.52581;
     0 1 0;
     0 0 1];
D = [1 0 0;
     0.494207 0 1.24827;
     0 0 1];

% Transform original RGB
rgb = (im/255).^2.2;

% Slightly reduce color domain for protanopes and deuteranopes respectively
rgb1_p = 0.992052*rgb + 0.00397;
rgb1_d = 0.957237*rgb + 0.0213814;

% Transform the RGB representation to an LMS representation using matrix M
for i = 1:im_size(1)
    for j = 1:im_size(2)
        rgbp = rgb1_p(i,j,:);
        rgbd = rgb1_d(i,j,:);
        rgbp = rgbp(:);
        rgbd = rgbd(:);
        LMSp(i,j,:) = M*rgbp;
        LMSd(i,j,:) = M*rgbd;
    end
end

% Reduce the colour domain to the dichromat domain using matrices P and D
for i = 1:im_size(1)
    for j = 1:im_size(2)
        lmsp = LMSp(i,j,:);
        lmsd = LMSd(i,j,:);
        lmsp = lmsp(:);
        lmsd = lmsd(:);
        LMSp(i,j,:) = P*lmsp;
        LMSd(i,j,:) = D*lmsd;
    end
end

% Transform back to RGB space
for i = 1:im_size(1)
    for j = 1:im_size(2)
        lmsp = LMSp(i,j,:);
        lmsd = LMSd(i,j,:);
        lmsp = lmsp(:);
        lmsd = lmsd(:);
        RGBp(i,j,:) = inv(M)*lmsp;
        RGBd(i,j,:) = inv(M)*lmsd;
    end
end

% Invert the first transformation
pim = 255*RGBp.^(1.0/2.2);
dim = 255*RGBd.^(1.0/2.2);

montage({im/255, pim/255, dim/255}, 'Size', [1, 3]);

end