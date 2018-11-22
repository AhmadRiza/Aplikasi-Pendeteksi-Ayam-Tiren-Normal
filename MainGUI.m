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

% Last Modified by GUIDE v2.5 22-Nov-2018 18:03:37

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
    gray = convert2gray(image1);
    axes(handles.image_gs);
    imshow(gray);
    handles.data2 = gray;
    guidata(hObject,handles);
    
    %table
    dataVector=gray(:);
    [dataTable,dataUji] = TDistribusiFrekuensi(dataVector,6);
    set(handles.tbl_tdf, 'Data', dataTable);
    dataUji = dataUji(:);
    if(exist('jst.mat','file'))
       load('jst.mat');
    else
        msgbox('Lakukan training dulu!');
    end
    
    if(exist('jst','var'))
        
        batasBawah = 0.001;
        batasAtas = 1 - batasBawah;
        hasilUji = sim(jst, dataUji)
        % 0 1
        if(hasilUji>batasAtas)
           set(handles.txt_kesimpulan, 'String', 'Ayam Segar');
        % 1 0
        elseif (hasilUji<batasBawah)
            set(handles.txt_kesimpulan, 'String', 'Ayam Tiren');
        else
            set(handles.txt_kesimpulan, 'String', 'Tidak diketahui');
        end
        
    else
        msgbox('Lakukan training dulu!');
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
    samplingTirenJST(folder_name);
    msgbox('Folder gambar ayam tiren dipilih!');
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
    samplingSegarJST(folder_name);
    msgbox('Folder gambar ayam segar dipilih!');
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


% --- Executes on button press in btn_latih_jst.
function btn_latih_jst_Callback(hObject, eventdata, handles)
     
% hObject    handle to btn_latih_jst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if exist('sampleTirenAI.mat', 'file') && exist('sampleSegarAI.mat', 'file')&& exist('targetTirenAI.mat', 'file')&& exist('targetSegarAI.mat', 'file') 
            load('sampleTirenAI.mat');
            load('sampleSegarAI.mat');
            load('targetTirenAI.mat');
            load('targetSegarAI.mat');
    else
        msgbox('Pilih Folder Training dulu!');
    end

    %checkif train data valid
    if exist('dataLatihSegar','var') && exist('dataLatihTiren','var')&& exist('targetTiren','var')&& exist('targetSegar','var')
        
        dataLatih = [dataLatihSegar,dataLatihTiren];
        target = [targetSegar,targetTiren];
        
        jst = newff(minmax(dataLatih),[50,1],{'logsig','logsig'},'traincgp');
        init(jst);
        jst.trainParam.epochs = 100000;
        jst.trainParam.goal = 0.0000001;
        tic;
        jst = train(jst,dataLatih,target);
        msgbox(strcat('Training selesai dengan waktu ',num2str(toc),' ms'));
        
        hasil = sim(jst, dataLatih)
        save jst jst;
    end

