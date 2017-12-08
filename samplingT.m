function fTotalT = samplingT(folder)

% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.

directories = strcat(folder,'/*.jpg');
imagefiles = dir(directories);      
nfiles = length(imagefiles);    % Number of files found

f = zeros;
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentfilename = strcat(folder,'/',currentfilename);
   %read current image
   RGB = imread(currentfilename);
   gray = rgb2gray(RGB);
   [b, k] = size(gray);
   dataV=reshape(gray,b*k,1);
   
   %ambil f
   [~, current_f] = TDistribusiFrekuensi(dataV,6);
   
   %simpan f ke array
   if ii==1
       f=current_f;
   else
       f=[f;current_f];
   end
   
end
%jika cuma satu
if size(f,1)==1
    fTotalT = f;
else
    fTotalT = mean(f);
end


%menyimpan ke matrik
save('sampleT.mat','fTotalT');
   

end