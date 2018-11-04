function varargout = MainGUI(varargin)
% MAINGUI MATLAB code for MainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI

% Last Modified by GUIDE v2.5 06-Dec-2017 06:52:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI (see VARARGIN)

% Choose default command line output for MainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_openimg.
function btn_openimg_Callback(hObject, eventdata, handles)
% hObject    handle to btn_openimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name_file1,name_path1] = uigetfile( ...
    {'*.bmp;*.jpg;*.tif','Files of type (*.bmp,*.jpg,*.tif)';
    '*.bmp','File Bitmap (*.bmp)';...
    '*.jpg','File jpeg (*.jpg)';
    '*.tif','File Tif (*.tif)';
    '*.*','All Files (*.*)'},...
    'Open Image');
 
if ~isequal(name_file1,0)
    handles.data1 = imread(fullfile(name_path1,name_file1));
    guidata(hObject,handles);
    axes(handles.image_rgb);
    imshow(handles.data1);
    %grayscale
    image1 = handles.data1;
    gray = rgb2gray(image1);
    axes(handles.image_gs);
    imshow(gray);
    handles.data2 = gray;
    guidata(hObject,handles);
    
    %table
    [b ,k] = size(gray);
    dataVector=reshape(gray,b*k,1);
    [dataTable,~] = TDistribusiFrekuensi(dataVector,6);
    set(handles.tbl_tdf, 'Data', dataTable);
    
    %splitt image
    splitImage = split(gray);
    
    axes(handles.img1);
    image1 = splitImage{1,1};
    imshow(image1);
    
    axes(handles.img2);
    image2 = splitImage{1,2};
    imshow(image2);
    
    
    axes(handles.img3);
    image3 = splitImage{2,1};
    imshow(image3);
    
    
    axes(handles.img4);
    image4 = splitImage{2,2};
    imshow(image4);
    
    %end of splitting image
    
    
    %testing splitted image
    %check if user trained
    if exist('sampleT.mat', 'file') && exist('sampleF.mat', 'file')
        load('sampleT.mat');
        load('sampleF.mat');
    else
        set(handles.txt_kesimpulan, 'String', 'Lakukan training dahulu!');
    end
    
    %checkif train data valid
    if exist('fTotalF','var') && exist('fTotalT','var')
       
       %set table sample
       set(handles.tblSampleTiren, 'Data', fTotalF);
       set(handles.tblSampleSegar, 'Data', fTotalT);     
       
       %end
        
       mseTirenTotal = zeros;
       mseSegarTotal = zeros;
       tiren = 0;
       segar = 0;
       %per- split image test
       for i =1: 2
           for j =1 : 2
                curGray = splitImage{i, j}; 
                [r,c] = size(curGray);
                dataVector=reshape(curGray, r*c,1);
                [~,fr] = TDistribusiFrekuensi(dataVector,6);
                mseTir = MeanSquareE(fTotalF, fr);
                mseSeg = MeanSquareE(fTotalT, fr);
                
                %save result for table
                if i==1 && j==1
                    mseTirenTotal = mseTir;
                    mseSegarTotal = mseSeg;
                else
                    mseTirenTotal = [mseTirenTotal;mseTir];
                    mseSegarTotal = [mseSegarTotal;mseSeg];
                end
                
                %decide each image
                if mseSeg>mseTir
                   kesimpulan = 'Tiren';
                   tiren = tiren +1;
                else
                    kesimpulan = 'Segar';
                    segar = segar+1;
                end

                if i==1 && j==1
                    set(handles.txtimg1, 'String', kesimpulan);
                elseif i ==1 && j==2
                    set(handles.txtimg2, 'String', kesimpulan);
                elseif i ==2 && j==1
                    set(handles.txtimg3, 'String', kesimpulan);
                elseif i ==2 && j==2
                    set(handles.txtimg4, 'String', kesimpulan);
                end
           end
            
       end
       
       %end
       
       %estimating
       %formatting data into table
       format shortG;
       
       TableDataMse = [mseSegarTotal,mseTirenTotal];
       TableDataMse = [TableDataMse;sum(mseSegarTotal),sum(mseTirenTotal)]
       %end formatting
       
       set(handles.tableMSE, 'Data', TableDataMse);
       
       if tiren>segar
           set(handles.txt_kesimpulan, 'String', 'Ayam Tiren');
       elseif segar>tiren
           set(handles.txt_kesimpulan, 'String', 'Ayam Segar');
       else
           %sama
            if sum(mseSegarTotal)>sum(mseTirenTotal)
               set(handles.txt_kesimpulan, 'String', 'Ayam Tiren');
            else
               set(handles.txt_kesimpulan, 'String', 'Ayam Segar');
            end
       end
       
    else
        set(handles.txt_kesimpulan, 'String', 'Lakukan training dahulu!');
    end
    
else
    return;
end


% --- Executes on button press in btn_grayscale.
function btn_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to btn_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_ayam_tiren.
function btn_ayam_tiren_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ayam_tiren (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder_name = uigetdir('','Pilih Folder Gambar Ayam Tiren');
if ~isequal(folder_name,0)
    samplingF(folder_name);
    f = msgbox('Training gambar ayam tiren selesai!');
else
    return;
end


% --- Executes on button press in btn_ayam_segar.
function btn_ayam_segar_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ayam_segar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir('','Pilih Folder Gambar Ayam Segar');
if ~isequal(folder_name,0)
    samplingT(folder_name);
    f = msgbox('Training gambar ayam segar selesai!');
else
    return;
end


% --- Executes during object deletion, before destroying properties.
function tbl_tdf_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to tbl_tdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on btn_openimg and none of its controls.
function btn_openimg_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btn_openimg (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
