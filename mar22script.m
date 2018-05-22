% Repeatability script for jpg compressed image sequence.
clear;
close all;

%% First test
im = imread('testimg1.pgm');
im2 = imread('testimg2.pgm');

% Detect HL features in both images.
HLfeatures = harrisLaplace(im);
HLfeatures2 = harrisLaplace(im2);
OptimalPlot(im, HLfeatures(:,2), HLfeatures(:,1), 'H', '+', 'a)')
OptimalPlot(im2, HLfeatures2(:,2), HLfeatures2(:,1), 'H', '+', 'b)')

%% Fractional Part (Mar 21)

% Detect FHL features in both images.
FHLfeatures = fracharrislaplace(im);
FHLfeatures2 = fracharrislaplace(im2);
OptimalPlot(im, FHLfeatures(:,2), FHLfeatures(:,1), 'F', '+', 'a)')
OptimalPlot(im2, FHLfeatures2(:,2), FHLfeatures2(:,1), 'F', '+', 'b)')

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

for i = 1:N_tol
    [scores(1,i),num_matches(1,i)] = repeatability(HLfeatures(:,1:2), HLfeatures2(:,1:2),tols(i));
    [fracscores(1,i),frac_num_matches(1,i)] = repeatability(FHLfeatures(:,1:2),FHLfeatures2(:,1:2),tols(i));
end

%% Plot the results.

figure()
plot(tols, scores, 'r--', tols, fracscores, 'b--')
xlabel('Localization error ($\varepsilon$)','Interpreter','latex','Fontsize',14)
ylabel('Repeatability (\%)','Interpreter','latex','Fontsize',14)
legend('Harris-Laplace','Fractional Harris-Laplace')
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