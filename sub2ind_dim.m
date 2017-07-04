function linearInd = sub2ind_dim(S,index)

N = length(index);
switch N
    case 2
        linearInd = sub2ind(S,index(1),index(2));
    case 3
        linearInd = sub2ind(S,index(1),index(2),index(3));
    case 4
        linearInd = sub2ind(S,index(1),index(2),index(3),index(4));
    case 5
        linearInd = sub2ind(S,index(1),index(2),index(3),index(4),index(5));
    case 6
        linearInd = sub2ind(S,index(1),index(2),index(3),index(4),index(5),...
            index(6));
end
end