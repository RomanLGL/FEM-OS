A = zeros(3,5,7);
for i = 1:numel(A)
    A(i) = i;
end

B = Interp_1D(1:3,A,2);
test = zeros(size(B));
[n,m] = size(B);
for i = 1:n
    for j = 1:m
        a = 0.5*(A(1,i,j) + A(3,i,j));
        test(i,j) = (a==B(i,j));        
    end
end

C = Interp_1D(1:5,B,3);
test = zeros(size(C));
n = length(C);
for i = 1:n
    b = 0.5*(B(2,i) + B(4,i));
    test(i) = (b==C(i));
end