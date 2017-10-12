function showPartition(tau, T, fig)

if size(T.X, 2) ~= 2
    error('Can only show two-dimensional data')
end

% Colors to cycle through for classes
color = 'rgbcyk';

figure(fig)
clf
hold on

% Find distinct labels
label = unique(T.y);
K = length(label);

% Plot the data points
for k = 1:K
    index = T.y == label(k);
    plot(T.X(index, 1), T.X(index, 2), ...
        sprintf('.%c', color(mod(k-1, length(color)) + 1)))
end
axis equal
axis tight

% Plot the partition lines
box = [get(gca, 'XLim'); get(gca, 'YLim')]';
p = treePartition(tau, box);
if ~isempty(p)
    plot(squeeze(p(:, 1, :)), squeeze(p(:, 2, :)), 'k');
end

set(gca, 'Box', 'on')
figure(gcf)

    function p = treePartition(tau, box)
        
        if isempty(tau.d)  % Leaf
            p = [];
        else  % Internal node
            segment = box;
            segment(:, tau.d) = tau.t * [1; 1];
            leftBox = box;
            leftBox(2, tau.d) = tau.t;
            left = treePartition(tau.L, leftBox);
            rightBox = box;
            rightBox(1, tau.d) = tau.t;
            right = treePartition(tau.R, rightBox);
            p = cat(3, segment, left, right);
        end
        
    end
end