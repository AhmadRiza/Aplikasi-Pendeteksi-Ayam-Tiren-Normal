function result = nilaiMin(data)
data = data(:);
result = data(1);
n = size(data);
for i=2 : n
   if(data(i)<result)
      result = data(i); 
   end
end

return