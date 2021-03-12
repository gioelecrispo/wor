function [C,ix,iy] = m_dtw(M) 
%    Use dynamic programming to find a min-cost path through matrix M.
%    Return state sequence in p,q
%    This version has limited slopes [2/1] .. [1/2]

[r,c] = size(M);

% costs
D = zeros(r+1, c+1);
D(1,:) = NaN;
D(:,1) = NaN;
D(1,1) = 0;
D(2:(r+1), 2:(c+1)) = M;
D2=D;
D2(isnan(D2))=99999;
% traceback
phi = zeros(r+1,c+1);

for ii = 2:r+1; 
  for jj = 2:c+1;
    % Scale the 'longer' steps to discourage skipping ahead
    kk1 = 2;
    kk2 = 1;
    dd = D2(ii,jj);
    
    if 1>=(ii-2)
        max1=1; % max(1,i-2)
    else
        max1=ii-2;
    end    
    if 1>=(jj-2)
        max2=1; % max(1,j-2)
    else
        max2=jj-2;
    end    
    
    a=D2(ii-1,jj-1)+dd; b=D2(max1,jj-1)+dd*kk1; cc=D2(ii-1,max2)+dd*kk1; d=D2(ii-1,jj)+kk2*dd; e=D2(ii,jj-1)+kk2*dd;
    if (a<=b) & (a<=cc) & (a<=d) & (a<=e)
       dmax=a;
       tb=1;
    elseif (b<a) & (b<=cc) & (b<=d) & (b<=e)
         dmax=b;
         tb=2;
    elseif (cc<a) & (cc<b) & (cc<=d) & (cc<=e)
         dmax=cc;
         tb=3;
    elseif (d<a) & (d<cc) & (d<=e) & (d<b)
         dmax=d;
         tb=4;
    elseif (e<a) & (e<cc) & (e<b) & (e<d)
         dmax=e;
         tb=5;
    else
        dmax=a;
        tb=1;
    end
    
%     [dmax, tb] = min([D(i-1, j-1)+dd, D(max(1,i-2), j-1)+dd*kk1, D(i-1, max(1,j-2))+dd*kk1, D(i-1,j)+kk2*dd, D(i,j-1)+kk2*dd]);
    D2(ii,jj) = dmax;
    phi(ii,jj) = tb;
  end
end
C=D2(2:end,2:end);
[ix,iy] = traceback(C);

ix = ix';
iy = iy';
 
 
%-------------------------------------------------------------------------
function [ix,iy] = traceback(C)
m = size(C,1);
n = size(C,2);

% pre-allocate to the maximum warping path size.
ix = zeros(m+n,1);
iy = zeros(m+n,1);

ix(1) = m;
iy(1) = n;

i = m;
j = n;
k = 1;

while i>1 || j>1
  if j == 1
    i = i-1;
  elseif i == 1
    j = j-1;
  else
    % trace back to the origin, ignoring any NaN value
    % prefer i in a tie between i and j
    cij = C(i-1,j-1);
    ci = C(i-1,j);
    cj = C(i,j-1);
    i = i - (ci<=cj | cij<=cj | cj~=cj);
    j = j - (cj<ci | cij<=ci | ci~=ci);
  end
  k = k+1;
  ix(k) = i;
  iy(k) = j;
end

ix = ix(k:-1:1);
iy = iy(k:-1:1);