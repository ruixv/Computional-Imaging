function A = Creat3DArray
flag = 100
 for i=1:2
    for j=1:2
        for k=1:2
            A(i,j,k)=i+j+k+flag;
            flag = flag + 1;A
        end
    end
 end
end