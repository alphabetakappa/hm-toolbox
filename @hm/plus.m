function H = plus(H1, H2)
%PLUS Sum of two HODLR matrices.
if isa(H1, 'hm') && isa(H2, 'hss')
	if ~check_cluster_equality(H1, H2)
    		error('H1 + H2: Cluster or dimension mismatch in H1 and H2');
    	end
    	H = hmatrix_plus(H1, hss2hm(H2));	
elseif isa(H1, 'hm') && ~isa(H2, 'hm')
	H = full(H1) + H2;
elseif ~isa(H1, 'hm') 
	H = H1 + full(H2);
else
    if ~check_cluster_equality(H1, H2)
    	error('H1 + H2: Cluster or dimension mismatch in H1 and H2');
    end
    H = hmatrix_plus(H1, H2);
    
end

end

