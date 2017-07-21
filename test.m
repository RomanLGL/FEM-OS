A = zeros(3,5,7);
for i=1:numel(A)
    A(i) = i;
end
B = zeros(1,numel(A));
parfor i=1:numel(B)
    B(i) = i;
end
C = reshape(B,size(A));
tst = C==A;
sum(tst(:))