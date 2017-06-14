%% Sub-block local guided binary pattern (LGBP) processing
function lgbprst = lgbp_subblk_proc(I, I_GE, lbp_r, lbp_p, mappingtype, mode)

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
%  mappingtype - LBP code mode. Possible values for MAPPINGTYPE are
%       'u2'   for uniform pattern
%       'ri'   for rotation-invariant pattern
%       'riu2' for uniform rotation-invariant pattern
%       '0' for basic pattern
%  mode - feature mode. Possible values are
%		'h'  for histogram
%       'nh' for normalized histogram

% Output parameters:
%  lgbprst: local guided binary pattern (LGBP) hist feature in local block

d_image = double(I);
d_IGE = double(I_GE);

% sample point initialization
spoints = zeros(lbp_p, 2);

% Angle step.
a = 2*pi/lbp_p;

for i = 1:lbp_p
    spoints(i,1) = -lbp_r*sin((i-1)*a);
    spoints(i,2) = lbp_r*cos((i-1)*a);
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

% Determine the dimensions of the input image.
[ysize, xsize] = size(I);
miny = min(spoints(:,1));
maxy = max(spoints(:,1));
minx = min(spoints(:,2));
maxx = max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
origy=1-floor(min(miny,0));
origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the lbp_r of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
    error('Too small input image. Should be at least (2*lbp_r+1) x (2*lbp_r+1)');
end
% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% Fill the center pixel matrix C.
C = I(origy:origy+dy,origx:origx+dx);
d_C = double(C);

C_gs = I_GE(origy:origy+dy,origx:origx+dx);
d_C_gs = double(C_gs);

bins = 2^lbp_p;

% Initialize the result matrix with zeros.
lgbprst=zeros(dy+1,dx+1);

% Compute the LBP code image

for i = 1:lbp_p
    y = spoints(i,1)+origy;
    x = spoints(i,2)+origx;
    % Calculate floors, ceils and rounds for the x and y.
    fy = floor(y); cy = ceil(y); ry = round(y);
    fx = floor(x); cx = ceil(x); rx = round(x);
    % Check if interpolation is needed.
    if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
        % Interpolation is not needed, use original datatypes
        if mod(lbp_p, 2) == 0
            N = I_GE(ry:ry+dy,rx:rx+dx);
            D = N >= C_gs;
        else
            N = I(ry:ry+dy,rx:rx+dx);
            D = N >= C;
        end
    else
        % Interpolation needed, use double type images
        ty = y - fy;
        tx = x - fx;
        
        % Calculate the interpolation weights.
        w1 = roundn((1 - tx) * (1 - ty),-6);
        w2 = roundn(tx * (1 - ty),-6);
        w3 = roundn((1 - tx) * ty,-6) ;
        % w4 = roundn(tx * ty,-6) ;
        w4 = roundn(1 - w1 - w2 - w3, -6);
        
        % Compute interpolated pixel values
        if mod(lbp_p, 2) == 0
            N = w1*d_IGE(fy:fy+dy,fx:fx+dx) + w2*d_IGE(fy:fy+dy,cx:cx+dx) + ...
                w3*d_IGE(cy:cy+dy,fx:fx+dx) + w4*d_IGE(cy:cy+dy,cx:cx+dx);
            N = roundn(N,-4);
            D = N >= d_C_gs;
        else
            N = w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
                w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx);
            N = roundn(N,-4);
            D = N >= d_C;
        end        
    end
    % Update the result matrix.
    v = 2^(i-1);
    lgbprst = lgbprst + v*D;
end

%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(lgbprst,1)
        for j = 1:size(lgbprst,2)
            lgbprst(i,j) = mapping.table(lgbprst(i,j)+1);
        end
    end
end

if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    lgbprst=hist(lgbprst(:),0:(bins-1));
    if (strcmp(mode,'nh'))
        lgbprst=lgbprst/sum(lgbprst);
    end
else
    %Otherwise return a matrix of unsigned integers
    if ((bins-1)<=intmax('uint8'))
        lgbprst=uint8(lgbprst);
    elseif ((bins-1)<=intmax('uint16'))
        lgbprst=uint16(lgbprst);
    else
        lgbprst=uint32(lgbprst);
    end
end

end

function x = roundn(x, n)

% error(nargchk(2, 2, nargin, 'struct'))
validateattributes(x, {'single', 'double'}, {}, 'ROUNDN', 'X')
validateattributes(n, ...
    {'numeric'}, {'scalar', 'real', 'integer'}, 'ROUNDN', 'N')

if n < 0
    p = 10 ^ -n;
    x = round(p * x) / p;
elseif n > 0
    p = 10 ^ n;
    x = p * round(x / p);
else
    x = round(x);
end

end



