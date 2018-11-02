function X = mldivide(A, B)

if isscalar(A)
    X = hss_scalar_mul(1 ./ A, B);
    return;
end

if isa(B,'hss')
    X = hss_mldivide(A, B);
else
    if size(A, 1) <= hssoption('block-size')
        X = full(A) \ B;
        return;
    end
    %[D,U,R,BB,W,V,tr] = hss2xia(A);
    %X = hssulvsol(tr,D,U,R,BB,W,V,length(tr),B);
    % X = hss_solve(A, B);
    X = hss_ulv_solve(A,B);
end
end
