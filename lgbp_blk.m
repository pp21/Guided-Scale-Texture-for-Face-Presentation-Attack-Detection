%% Get block based local guided binary pattern (LGBP) hist of gray scale image, block with half overlap of each row and col
function lgbp_blk_rst = lgbp_blk(I, IG, lbp_r, lbp_p, mappingtype, wr, eps, mode, rowstep, colstep)

% Reference:
% [1] T. Ojala, M. Pietikainen, and T. Maenpaa,
%     "Multiresolution gray-scale and rotation invariant texture classification with local binary patterns,"
%     IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 24, no. 7, pp. 971¨C987, Jul. 2002.
% [2] K. He, J. Sun, and X. Tang,
%      "Guided image filtering,"
%     European conference on computer vision. Springer Berlin Heidelberg, 2010: 1-14.
% [3] K. He, J. Sun, and X. Tang,
%     "Guided image filtering,"
%     IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 35, no. 6, pp. 1397-1409, Jun. 2013.

% Input parameters:
%  I - input image (uint8, should be a gray-scale/single channel image)
%  IG - guidance image (uint8, should be a gray-scale/single channel image)
%  lbp_r - neighboring radius of LGBP
%  lbp_p - numbers of neighboring samples of LGBP
%  mappingtype - code mode. Possible values for MAPPINGTYPE are
%       'u2'   for uniform pattern
%       'ri'   for rotation-invariant pattern
%       'riu2' for uniform rotation-invariant pattern
%       '0' for basic pattern
%  wr - local window size of guided scale conversion
%  eps - regularization parameter of guided scale conversion
%  mode - feature mode. Possible values are
%		'h'  for histogram
%       'nh' for normalized histogram
%  rowstep - block step of each row
%  colstep - block step of each col

% Output parameters:
%  lgbp_blk_rst: local guided binary pattern (LGBP) block based feature

if mod(rowstep, 2) ~= 0 || mod( size(I,1), (rowstep/2) ) ~= 0
    error('Incompatible row step');
end

if mod(colstep, 2) ~= 0 || mod( size(I,2), (colstep/2) ) ~= 0
    error('Incompatible col step');
end

wrownum = size(I,1) / (rowstep/2) - 1;
wcolnum = size(I,2) / (colstep/2) - 1;

% Compute guided filtering image
d_i = im2double(I);
d_ig = im2double(IG);
guidedi = guidedfilter( d_ig, d_i, wr*wr, eps );

I_enhanced = (d_ig - guidedi) * 5 + guidedi;
I_enhanced = mapminmax(I_enhanced, 0, 1);
I_enhanced = im2uint8(I_enhanced);

lgbp_blk_rst = [];

for i = 1:wrownum
    for j = 1:wcolnum
        wcrows = (i-1)*(rowstep/2) + 1;
        wcrowe = (i-1)*(rowstep/2) + rowstep;
        wccols = (j-1)*(colstep/2) + 1;
        wccole = (j-1)*(colstep/2) + colstep;
        lgbp_sub = lgbp_subblk_proc( I( wcrows:wcrowe, wccols:wccole ), I_enhanced( wcrows:wcrowe, wccols:wccole ), ...
            lbp_r, lbp_p, mappingtype, mode );
        lgbp_blk_rst = [lgbp_blk_rst, lgbp_sub];
    end
end

