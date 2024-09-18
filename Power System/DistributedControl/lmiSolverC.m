function [K,H] = lmiSolverC(A,B,Lambda,strc)
n=size(B,1);
m=size(B,2);
l=n+m;
for i =1:m
    excl{i}=setdiff(1:n,strc{i});
end

cvx_begin sdp
    variable H11(n,n) symmetric
    variable H12T(m,n)
    variable H22(m,m) diagonal
    variable W(n,n) symmetric
    maximize ( trace(W) )
    subject to
        for i = 1:m
            H12T(i,excl{i})==0;
        end
        H=[H11 H12T' ; H12T H22];
        H22 >= 0;
        [H11-W H12T'; H12T H22] >= 0;
        [[A B]'*H11*[A B]-H+Lambda [A B]'*H12T';H12T*[A B] H22] >=0;
cvx_end

K = -inv(H22)*H12T;
end

