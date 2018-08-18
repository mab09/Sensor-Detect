function varargout = SensorDetect(varargin)
% SENSORDETECT MATLAB code for SensorDetect.fig
%      SENSORDETECT, by itself, creates a new SENSORDETECT or raises the existing
%      singleton*.
%
%      H = SENSORDETECT returns the handle to a new SENSORDETECT or the handle to
%      the existing singleton*.
%
%      SENSORDETECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SENSORDETECT.M with the given input arguments.
%+
%      SENSORDETECT('Property','Value',...) creates a new SENSORDETECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SensorDetect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SensorDetect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SensorDetect

% Last Modified by GUIDE v2.5 30-Jul-2016 18:28:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SensorDetect_OpeningFcn, ...
                   'gui_OutputFcn',  @SensorDetect_OutputFcn, ...
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


% --- Executes just before SensorDetect is made visible.
function SensorDetect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SensorDetect (see VARARGIN)

% Choose default command line output for SensorDetect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SensorDetect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SensorDetect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function Recieve1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Recieve1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global i k l m;
i=0;
k=0;
l=0;
m=0;

% --- Executes on button press in Detect1.
function Detect1_Callback(hObject, eventdata, handles)
% hObject    handle to Detect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outa outa1 i bA comA;
bdr=[9600 14400 19200 28800 38400 57600 115200];
x=instrhwinfo('Serial');
f=0;
COM=x.AvailableSerialPorts;
len=length(COM);
for i=1:1:len
    comA=COM{i};
    s=serial(COM{i});
    for j=1:1:7
        bA=bdr(j);
        set(s,'BaudRate',bA,'Terminator','CR');
        try
            fopen(s);
            outa=fscanf(s);
            if isvector(strfind(outa,char(13)))||isvector(strfind(outa,char(10)))
                if length(outa)<=5
                    set(handles.Recieve1,'String','Connection Established...Ready for input')
                    set(handles.com1,'String',COM{i})
                    set(handles.bd1, 'String', bA)
                    guidata(hObject, handles);
                    fprintf(s,'formatcmd');
                    f=1;
                    break;
                else
                    set(handles.Recieve1,'String',outa)
                    set(handles.com1,'String',COM{i})
                    set(handles.bd1, 'String', bA)
                    guidata(hObject, handles);
                    fprintf(s,'formatcmd');
                    f=1;
                    break;
                end
            else
                if isempty(outa)
                   fprintf(s, 'A');
                end
            end
        end
        clear b;
    end
    if f==1
        while 1
            flushinput(s);
            outa1=fscanf(s);
            if ~strcmp(outa, outa1)
                fid1=fopen('Data.txt','w');
                fprintf(fid1,'%s %s', 'Sensor1 ');
                fprintf(fid1,'%s %s\r\n', outa1);
                fprintf(s,'datacmd');
                break;
            end
        end
        fclose(fid1);
        break;
    else
         set(handles.Recieve1,'String','No Data Recieved, Check your Connection')
         if i==len
             break;
         end
    end
end
if f==0
    i=0;
end
flushinput(s);
flushoutput(s);
try
     fclose(s);
 end
        
% --- Executes during object creation, after setting all properties.
function Recieve2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Recieve2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Detect2.
function Detect2_Callback(hObject, eventdata, handles)
% hObject    handle to Detect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outb outb1 k i bB comB;
bdr=[9600 14400 19200 28800 38400 57600 115200];
x=instrhwinfo('Serial');
f=0;
COM=x.AvailableSerialPorts;
len=length(COM);
for k=1:1:len
    if k~=i
        comB=COM{k};
    d=serial(COM{k});
    for j=1:1:7
        bB=bdr(j);
        set(d,'BaudRate',bB,'Terminator','CR');
        try
            fopen(d);
            outb=fscanf(d);
            if isvector(strfind(outb,char(13)))||isvector(strfind(outb,char(10)))
                if length(outb)<=5
                    set(handles.Recieve2,'String','Connection Established...Ready for input')
                    set(handles.com2,'String',COM{k})
                    set(handles.bd2, 'String', bB)
                    guidata(hObject, handles);
                    fprintf(d,'formatcmd');
                    f=1;
                    break;
                else
                    set(handles.Recieve2,'String',outb)
                    set(handles.com2,'String',COM{k})
                    set(handles.bd2, 'String', bB)
                    guidata(hObject, handles);
                    fprintf(d,'formatcmd');
                    f=1;
                    break;
                end
            else
                if isempty(outb)
                    fprintf(d, 'A');
                end
            end
        end
        clear b;
    end
    if f==1
        while 1
            flushinput(d);
            outb1=fscanf(d);
            if ~strcmp(outb, outb1)
                fid2=fopen('Data.txt','a');
                fprintf(fid2,'%s %s', 'Sensor2 ');
                fprintf(fid2,'%s %s\r\n', outb1);
                fprintf(d,'datacmd');
                break;
            end
        end
        fclose(fid2);
        break;
    else
        set(handles.Recieve2,'String','No Data Recieved, Check your Connection')
        if k==len
             break;
        end
    end
    end
end
if f==0
    k=0;
end
flushinput(d);
flushoutput(d);
try
     fclose(d);
 end

       

% --- Executes on button press in Detect3.
function Detect3_Callback(hObject, eventdata, handles)
% hObject    handle to Detect3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outc outc1 k i l comC bC;
bdr=[9600 14400 19200 28800 38400 57600 115200];
x=instrhwinfo('Serial');
f=0;
COM=x.AvailableSerialPorts;
len=length(COM);
for l=1:1:len
    if l~=i && l~=k
        comC=COM{l};
    a=serial(COM{l});
    for j=1:1:7
        bC=bdr(j);
        set(a,'BaudRate',bC,'Terminator','CR');
        try
            fopen(a);
            outc=fscanf(a);
            if isvector(strfind(outc,char(13)))||isvector(strfind(outc,char(10)))
                if length(outc)<=5
                    set(handles.Recieve3,'String','Connection Established...Ready for input')
                    set(handles.com3,'String',COM{l})
                    set(handles.bd3, 'String', bC)
                    guidata(hObject, handles);
                    fprintf(a,'formatcmd');
                    f=1;
                    break;
                else
                    set(handles.Recieve3,'String',outc)
                    set(handles.com3,'String',COM{l})
                    set(handles.bd3, 'String', bC)
                    guidata(hObject, handles);
                    fprintf(a,'formatcmd');
                    f=1;
                    break;
                end
            else
                if isempty(outc)
                    fprintf(a, 'A');
                end
            end
        end
        clear b;
    end
    if f==1
        while 1
            flushinput(a);
            outc1=fscanf(a);
            if ~strcmp(outc, outc1)
                fid3=fopen('Data.txt','a');
                fprintf(fid3,'%s %s', ' Sensor3 ');
                fprintf(fid3,'%s %s\r\n', outc1);
                fprintf(a,'datacmd');
                break;
            end
        end
        fclose(fid3);
        break;
    else
        set(handles.Recieve3,'String','No Data Recieved, Check your Connection')
        if l==len
             break;
        end
    end
    end
end
if f==0
    l=0;
end
flushinput(a);
flushoutput(a);
try
     fclose(a);
 end



% --- Executes on button press in Detect4.
function Detect4_Callback(hObject, eventdata, handles)
% hObject    handle to Detect4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outd outd1 k i l m comD bD;
bdr=[9600 14400 19200 28800 38400 57600 115200];
x=instrhwinfo('Serial');
f=0;
COM=x.AvailableSerialPorts;
len=length(COM);
for m=1:1:len
    if m~=i && m~=l && m~=k
        comD=COM{m};
    w=serial(COM{m});
    for j=1:1:7
        bD=bdr(j);
        set(w,'BaudRate',bD,'Terminator','CR');
        try
            fopen(w);
            outd=fscanf(w);
            if isvector(strfind(outd,char(13)))||isvector(strfind(outd,char(10)))
                if length(outd)<=5
                    set(handles.Recieve4,'String','Connection Established...Ready for input')
                    set(handles.com4,'String',COM{m})
                    set(handles.bd4, 'String', bD)
                    guidata(hObject, handles);
                    fprintf(w,'formatcmd');
                    f=1;
                    break;
                else
                    set(handles.Recieve4,'String',outd)
                    set(handles.com4,'String',COM{m})
                    set(handles.bd4, 'String', bD)
                    guidata(hObject, handles);
                    fprintf(w,'formatcmd');
                    f=1;
                    break;
                end
            else
                if isempty(outd)
                    fprintf(w, 'A');
                end
            end
        end
        clear b;
    end
    if f==1
       while 1
            flushinput(w);
            outd1=fscanf(w);
            if ~strcmp(outd, outd1)
                fid4=fopen('Data.txt','a');
                fprintf(fid4,'%s %s', 'Sensor4 ');
                fprintf(fid4,'%s %s\r\n', outd1);
                fprintf(w,'datacmd')
                break;
            end
        end
        fclose(fid4);
        break;
    else
        set(handles.Recieve4,'String','No Data Recieved, Check your Connection')
        if m==len
             break;
        end
    end
    end
end
if f==0
    m=0;
end
flushinput(w);
flushoutput(w);
try
     fclose(w);
 end


% --- Executes on button press in DetectAll.
function DetectAll_Callback(hObject, eventdata, handles)
% hObject    handle to DetectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outa outa1 outa2 outb outb1 outb2 outc outc1 outc2 outd outd1 outd2 comA bA comB bB comC bC comD bD;
Detect1_Callback(handles.Detect1, eventdata,handles);
Detect2_Callback(handles.Detect2, eventdata,handles);
Detect3_Callback(handles.Detect3, eventdata,handles);
Detect4_Callback(handles.Detect4, eventdata,handles);
s=serial(comA);
set(s,'BaudRate',bA,'Terminator','CR');
fopen(s);
 while(1)
     flushinput(s);
     outa2=fscanf(s);
     if ~strcmp(outa1, outa2) && ~strcmp(outa, outa2)
         fi1=fopen('Data.txt','a');
         fprintf(fi1,'%s %s', 'Sensor1 ');
         fprintf(fi1,'%s %s\r\n', outa2);
         fprintf(s,'data recieved');
         break;
     end
 end
 fclose(fi1);
 try
     fclose(s);
 end
 d=serial(comB);
set(d,'BaudRate',bB,'Terminator','CR');
fopen(d);
  while(1)
     flushinput(d);
     outb2=fscanf(d);
     if ~strcmp(outb1, outb2) && ~strcmp(outb, outb2)
         fi2=fopen('Data.txt','a');
         fprintf(fi2,'%s %s', 'Sensor2 ');
         fprintf(fi2,'%s %s\r\n', outb2);
         fprintf(d,'data recieved');
         break;
     end
 end
 fclose(fi2);
 try
     fclose(d);
 end
  a=serial(comC);
set(a,'BaudRate',bC,'Terminator','CR');
fopen(a);
  while(1)
     flushinput(a);
     outc2=fscanf(a);
     if ~strcmp(outc1, outc2) && ~strcmp(outc, outc2)
         fi3=fopen('Data.txt','a');
         fprintf(fi3,'%s %s', 'Sensor3 ');
         fprintf(fi3,'%s %s\r\n', outc2);
         fprintf(a,'data ecieved');
         break;
     end
 end
 fclose(fi3);
 try
     fclose(a);
 end
 w=serial(comD);
set(w,'BaudRate',bD,'Terminator','CR');
fopen(w);
  while(1)
     flushinput(w);
     outd2=fscanf(w);
     if ~strcmp(outd1, outd2) && ~strcmp(outd, outd2)
         fi4=fopen('Data.txt','a');
         fprintf(fi4,'%s %s', 'Sensor4 ');
         fprintf(fi4,'%s %s\r\n', outd2);
         fprintf(w,'data recieved');
         break;
     end
 end
 fclose(fi4);
 try
     fclose(w);
 end
