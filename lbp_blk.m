%% Get block based local binary pattern (LBP) hist of gray scale image, with half overlap of each row and col
function lbp_blk = lbp_blk(I, lbp_r, lbp_p, mappingtype, mode, rowstep, colstep)

% Reference:
% [1] T. Ojala, M. Pietikainen, and T. Maenpaa,
%     "Multiresolution gray-scale and rotation invariant texture classification with local binary patterns,"
%     IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 24, no. 7, pp. 971¨C987, Jul. 2002.

% Input parameters:
%  I - input image (uint8, should be a gray-scale/single channel image)
%  lbp_r - neighboring radius of LBP
%  lbp_p - numbers of neighboring samples of LBP
%  mappingtype - LBP code mode. Possible values for MAPPINGTYPE are
%       'u2'   for uniform LBP
%       'ri'   for rotation-invariant LBP
%       'riu2' for uniform rotation-invariant LBP
%       '0' for basic LBP
%  mode - 'h'  for histogram
%         'nh' for normalized histogram
%  rowstep - block step of each row
%  colstep - block step of each col

% Output parameters:
%  lbp_blk: local binary pattern (LBP) block based feature

if mod(rowstep, 2) ~= 0 || mod( size(I,1), (rowstep/2) ) ~= 0
    error('Incompatible row step');
end

if mod(colstep, 2) ~= 0 || mod( size(I,2), (colstep/2) ) ~= 0
    error('Incompatible col step');
end

% mapping type
if strcmp(mappingtype, '0') == 0
    mapping = getmapping(lbp_p, mappingtype);
    if(isstruct(mapping) && mapping.samples ~= lbp_p)
        error('Incompatible mapping');
    end
else
    mapping = 0;
end

wrownum = size(I,1) / (rowstep/2) - 1;
wcolnum = size(I,2) / (colstep/2) - 1;

lbp_blk = [];

for i = 1:wrownum
    for j = 1:wcolnum
        wcrows = (i-1)*(rowstep/2) + 1;
        wcrowe = (i-1)*(rowstep/2) + rowstep;
        wccols = (j-1)*(colstep/2) + 1;
        wccole = (j-1)*(colstep/2) + colstep;
        lbphist = lbp(I( wcrows:wcrowe, wccols:wccole ), lbp_r, lbp_p, mapping, mode);
        lbp_blk = [lbp_blk, lbphist];
    end
end

