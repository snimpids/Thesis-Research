% Repeatability script for boat sequence 1.

clear;
close all;

%% First test
im = imread('img1.pgm');
im2 = imread('img5.pgm');

% Estimated homography.
H = importdata('H1to5p');

% Detect HL features in both images.
HLfeatures = harrisLaplace(im);
HLfeatures2 = harrisLaplace(im2);
% OptimalPlot(im, HLfeatures(:,2), HLfeatures(:,1), 'H', '+', 'a)')
% OptimalPlot(im2, HLfeatures2(:,2), HLfeatures2(:,1), 'H', '+', 'b)')

%% Homography

% Calculate location of features from smaller image in larger image.
feat1 = HLfeatures(:,1:2);
H(3,1:2) = 0;

tform = affine2d(H');

feat1_in_img2 = zeros(size(feat1));
N = size(feat1,1);
for i = 1:N
    [x,y] = transformPointsForward(tform,feat1(i,2),feat1(i,1));
    feat1_in_img2(i,:) = [x,y];
end

OptimalPlot(im2, feat1_in_img2(:,1), feat1_in_img2(:,2), 'H', '+', 'c)')

%% Fractional Part (Mar 21)

% Detect FHL features in both images.
FHLfeatures = fracharrislaplace(im);
FHLfeatures2 = fracharrislaplace(im2);
OptimalPlot(im, FHLfeatures(:,2), FHLfeatures(:,1), 'F', '+', 'a)')
OptimalPlot(im2, FHLfeatures2(:,2), FHLfeatures2(:,1), 'F', '+', 'b)')

%% Homography for fractional part

fracfeat1 = FHLfeatures(:,1:2);

fracfeat1_in_img2 = zeros(size(fracfeat1));
N = size(fracfeat1,1);
for i = 1:N
    [x,y] = transformPointsForward(tform,fracfeat1(i,2),fracfeat1(i,1));
    fracfeat1_in_img2(i,:) = [x,y];
end

OptimalPlot(im2, fracfeat1_in_img2(:,1), fracfeat1_in_img2(:,2), 'F', '+', 'c)')

%% Repeatability test

lowest_tol = 1;
highest_tol = 5;
tol_step = 0.5;

tols = lowest_tol:tol_step:highest_tol;
N_tol = max(size(tols));
scores = zeros(1,N_tol);
fracscores = zeros(1,N_tol);

num_matches = zeros(1,N_tol);
frac_num_matches = zeros(1,N_tol);
matched_harr = [];
matched_frac = [];

for i = 1:N_tol
    [scores(1,i),num_matches(1,i)] = repeatability(feat1_in_img2, HLfeatures2(:,1:2),tols(i));
    [fracscores(1,i),frac_num_matches(1,i)] = repeatability(fracfeat1_in_img2,FHLfeatures2(:,1:2),tols(i));
end

%% Plot the results.

figure()
plot(tols, scores, 'r--', tols, fracscores, 'b--')
xlabel('Localization error ($\varepsilon$)','Interpreter','latex','Fontsize',14)
ylabel('Repeatability (\%)','Interpreter','latex','Fontsize',14)
legend('Harris-Laplace','Fractional Harris-Laplace','Location','northwest')
grid on

%% Bar graph of the number of matches for each epsilon.
MATCHES = [num_matches',frac_num_matches'];
figure()
b = bar(tols,MATCHES);
b(1).FaceColor = 'red';
b(2).FaceColor = 'blue';
b
xlabel('Localization error ($\varepsilon$)','Interpreter','latex','Fontsize',14)
ylabel('Number of correctly matched features','Interpreter','latex','Fontsize',14)
legend('Harris-Laplace','Fractional Harris-Laplace','Location','northwest')