classdef hss
	
	properties
		% top and bottom blocks of the matrix. 
		Bu
		Bl
		
		% Factorization of the upper triangular block as U12 * V12'
		U
		V
		
		% Factorization of the lower triangular block as U21 * V21'
		Rl
		Rr
		Wl
		Wr
		
		% Size of the matrix
		ml
		nl
		mr
		nr
		
		% Dense version of the matrix, if the size is smaller than the
		% minimum allowed block size. 
		D

		topnode
		leafnode

		hssl
		hssr
		
	end
	
	methods
		
		function obj = hss(varargin)
		%HM Create a new Hierarchical matrix. 		
			if nargin == 0
				return;
			end

			if nargin == 1
				n=size(varargin{1},1);
				obj = hss_buildA(varargin{1},hssoption('threshold'),1+ceil(log2(n/hssoption('block-size'))),1);
				return;
			end

			if nargin > 1    
				switch varargin{1}
					case 'low-rank'
						obj = hss_build_low_rank(varargin{2:end});
					case 'banded'
						obj = hss_build_band(varargin{2:end});
					otherwise
						error('Unsupported constructor mode');
				end
			end
		end
		
	end
	
	% 
	% Start of the private methods used to instantiate the HM objects
	%
	
	methods (Access = private)
	end
end