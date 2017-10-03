function feats = loadFeatures(keyFiles)
% LOADFEATURES loads keypoints from an ASCII file into an Nx5 array FEATS.
%
% See http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html for a
% desciption of such a keypoint file.
%
% See also: showFeatures
%
% Licence:
%   For internal use only.
%
% Author:
%   Falko Schindler (falko.schindler@uni-bonn.de)
%   Department of Photogrammetry
%   Institute of Geodesy and Geoinformation
%   University of Bonn
%   Bonn, Germany
%
% Example:
%   features = loadFeatures('lena.sfop');
%   features = loadFeatures('lena.sfop', 'lena.lowe');
%
% Copyright 2009-2011

%% initialize
feats = zeros(0, 5);
if ischar(keyFiles), keyFiles = {keyFiles}; end

%% read files
for f = 1 : numel(keyFiles)
    fid = fopen(keyFiles{f}, 'r');
    dim = fscanf(fid, '%f', 1);
    if dim ==   1, dim = 0; end
    if dim == -42, dim = 1; end
    if ~fscanf(fid, '%d', 1), return; end;
    feat = fscanf(fid, '%f', [5 + dim, inf])';
    fclose(fid);
    if ~isempty(feat), feats = [feats; feat(:, 1 : 5)]; end %#ok<AGROW>
end
