function [Xu, Xv, VA, VB] = ek_sylv(A, B, u, v, k, tol, debug)
%EK_SYLV Approximate the solution of a Sylvester equation AX + XB' = U*V'.
%
% [XU,XV] = EK_SYLV(A, B, U, V, K) approximates the solution of the 
%     Sylvester equation in the factored form XU * XV'. 
%
% [XU, VA] = EK_SYLV(A, B, U, V, K, TOL, DEBUG) also returns the bases VA 
%     and VB, and the optional parameters TOL and DEBUG control the 
%     stopping criterion and the debugging during the iteration. 

if ~exist('debug', 'var')
    debug = false;
end


if ~isstruct(A)
	AA = ek_struct(A);
else
	AA = A;
end

if ~isstruct(B) 
	BB = ek_struct(B');
else
	BB = B';
end

nrmA = AA.nrm;
nrmB = BB.nrm;

% Start with the initial basis
[VA, KA, HA] = rat_krylov(AA, u, inf);
[VB, KB, HB] = rat_krylov(BB, v, inf);

% Dimension of the space
sa = size(u, 2);
sb = size(v, 2);

bsa = sa;
bsb = sb;

Cprojected = ( VA(:,1:size(u,2))' * u ) * ( v' * VB(:,1:size(v,2)) );
	
if ~exist('tol', 'var')
    tol = 1e-8;
end

it=1;
while max(sa-2*bsa, sb-2*bsb) < k
    [VA, KA, HA] = rat_krylov(AA, VA, KA, HA, [0 inf]);
    [VB, KB, HB] = rat_krylov(BB, VB, KB, HB, [0 inf]);
    
    sa = size(VA, 2);
    sb = size(VB, 2);
    
    % Compute the solution and residual of the projected Lyapunov equation
    As = HA(1:end-bsa,:) / KA(1:end-bsa,:);
    Bs = HB(1:end-bsa,:) / KB(1:end-bsb,:);
    Cs = zeros(size(As, 1), size(Bs, 1));
    
    Cs(1:size(u,2), 1:size(v,2)) = Cprojected;    
    
    [Y, res] = lyap_galerkin(As, Bs, Cs, 2*bsa, 2*bsb);

    % You might want to enable this for debugging purposes
    if debug
        fprintf('%d Residue: %e\n', it, res / norm(Y));
    end

    if res < norm(Y) * tol
        break
    end        
 it=it+1;   
end

% it

% fprintf('lyap its = %d, nrmA = %e\n', it, nrmA)
[UU,SS,VV] = svd(Y);

rk = sum(diag(SS) > SS(1,1) * tol / max(nrmA, nrmB));

Xu = VA(:,1:size(Y,1)) * UU(:,1:rk) * sqrt(SS(1:rk,1:rk));
Xv = VB(:,1:size(Y,2)) * VV(:,1:rk) * sqrt(SS(1:rk,1:rk));

end

