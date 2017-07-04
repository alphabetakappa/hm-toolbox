function H = hmgallery(name, varargin)
%HMGALLERY Generate examples of H-matrices. 
%
% H = HMGALLERY('laplacian', n) generates a n x n discretization of the
% Laplacian operator on [-1, 1] using a grid of n+1 points, assuming 
% Dirichlet boundary conditions. 

switch name
    case 'laplacian'
        if isempty(varargin)
            n = 2048;
        else
            n = varargin{1};            
        end
        
        H = hm('tridiagonal', ...
            spdiags((n - 1)^2 * ones(n,1) * [ -1 2 -1 ], -1:1, n, n));
    otherwise
        error('Unsupported example name');
end


end

