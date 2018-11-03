function mse = MeanSquareE(sample, test)

n = size(sample,2);


total = 0;
for i = 1 : n
   total = total + (sample(i)-test(i))^2;
end

mse =  total / n;

return