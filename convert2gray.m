function gray = convert2gray(rgb)
   % row col number
  [~, ~, colorsNumber] = size(rgb);
  if colorsNumber  == 3
      
      % dapatkan tiap channelnya
      red = rgb(:, :, 1);
      green = rgb(:, :, 2);
      blue = rgb(:, :, 3);
      
      % tetapan weighted average atau luminosity berdasarkan pengliahatn manusia .
      gray = .299*double(red) + ...
                  .587*double(green) + ...
                  .114*double(blue);
      % hapus comma.
      gray = uint8(gray);
  else
      % sudah gray scale
      gray = rgb;  
  end

end