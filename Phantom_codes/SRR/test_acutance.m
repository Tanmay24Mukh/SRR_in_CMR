% M202_S01_SR = load("D:\CSRR\Datasets\M202\M202_S01\results\SA_1.0_LA_1.0_linear_I_0.50_C_0.25_H_0.50_X00\M202_S01_SA_1.0_LA_1.0_linear_I_0.5_C_0.25_H_0.5_X00_images_SR.mat");
I = M202_S01_SR.images_SR.pvals.gray{45,1};

I = I(20:70,50:100);

% Step 3: Calculate the gradient (first-order derivatives) in x and y directions
[Gx, Gy] = gradient(double(I));

% Step 4: Compute the acutance value
acutanceValue = mean(sqrt(Gx(:).^2 + Gy(:).^2));

% Step 5: Plot the acutance value
figure;
imshow(I);
% Step 3: Calculate the gradient (first-order derivatives) in x and y directions
[Gx, Gy] = gradient(double(I));

% Step 4: Compute the acutance value
acutanceValue = mean(sqrt(Gx(:).^2 + Gy(:).^2));

% Step 5: Plot the acutance value
figure;
imshow(I);
title(['Acutance: ' num2str(acutanceValue)]);