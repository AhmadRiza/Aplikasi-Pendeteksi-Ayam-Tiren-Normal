% membagi gambar menjadi 4 bagian
function result = split(grayImg)


s = size(grayImg);

row = s(1);
col = s(2);

a = ceil(row/2);
b =  row-a;
x = ceil(col/2);
y = col - x;

result = mat2cell(grayImg, [a b], [x y]);

return