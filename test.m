A = rand(3,3,3);
A_interp = squeeze((3*A(1,:,:)+A(2,:,:))./4);
B = Interp_1D(1:3,A,1.25);
A_interp==B