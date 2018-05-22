function [] = OptimalPlot(im, cols, rows, type, point, letter)

% Helper function to plot results without axes ticks or extra whitespace
% around plot.

if ~ischar(type)
   error('Error. \nInput must be a char, not a %s.',class(type))
end;

if ~ischar(point)
   error('Error. \nInput must be a char, not a %s.',class(point))
elseif (point ~= '+') && (point ~= 'o')
    point = '+';
end;

if type == 'F'
    dotmarker = 'r';
    color = 'red';
elseif type == 'H'
    dotmarker = 'g'; 
    color = 'green';
else
    dotmarker = 'b';
    color = 'blue';
end;

dotmarker = [dotmarker,point];
% figure();
figure( 'Position', [50 50 (size(im,2)) (size(im,1)+144)] );
colormap( gray(256) ); imagesc( im ); axis off; axis image; hold on;
% imshow(im); hold on;
% xlabel(letter,'Interpreter','latex');
text(.5,0,letter,...
                'horiz','center',...
                'vert','top',...
                'FontSize',48,...
                'units','normalized','Interpreter','latex')
plot( cols, rows, dotmarker, 'Marker', point, 'MarkerFaceColor', color ); 
set(gca,'visible','off');
set(gca,'position',[0 0 1 1],'units','normalized');
hold off;