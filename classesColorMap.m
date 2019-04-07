function cmap = classesColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
    255 255 255       % FUEL
    0 0 0   % NOFUEL
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end