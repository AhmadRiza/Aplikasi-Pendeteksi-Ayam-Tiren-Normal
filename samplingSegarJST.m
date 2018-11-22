function dataLatihSegar = samplingSegarJST(folder)

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
   gray = convert2gray(RGB);
   %convert to 1 col
   dataV=gray(:);
   
   %ambil f
   [~, current_f] = TDistribusiFrekuensi(dataV,6);
   
   
   
   %simpan f ke array
   if ii==1
       f=current_f(:);
       t = 1;
   else
       f=[f,current_f(:)];
       t = [t, 1 ];
   end
   
end

dataLatihSegar = f;
targetSegar = t;
%menyimpan ke matrik
save('sampleSegarAI.mat','dataLatihSegar');
save('targetSegarAI.mat','targetSegar');
   
end