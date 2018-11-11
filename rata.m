function result =  rata(data)

[r,c] = size(data);
sum = zeros;
for i =1 : c
    totalCol = 0;
    
    for j = 1 : r
       totalCol = totalCol+data(j,i); 
    end
    
    if i==1
        sum = totalCol;
    else
        sum = [sum, totalCol];
    end
    
end

result = sum/r;

return