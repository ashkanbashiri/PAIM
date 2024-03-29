function varargout = simulator(varargin)
% SIMULATOR MATLAB code for simulator.fig
%%
%%
%      SIMULATOR, by itself, creates a new SIMULATOR or raises the existing
%      singleton*.
%
%      H = SIMULATOR returns the handle to a new SIMULATOR or the handle to
%      the existing singleton*.
%
%      SIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATOR.M with the given input arguments.
%
%      SIMULATOR('Property','Value',...) creates a new SIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulator

% Last Modified by GUIDE v2.5 02-Jan-2017 18:06:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @simulator_OpeningFcn, ...
    'gui_OutputFcn',  @simulator_OutputFcn, ...
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


% --- Executes just before simulator is made visible.
function simulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulator (see VARARGIN)

% Choose default command line output for simulator
handles.output = hObject;

% Update handles structure
handles.simTime = 500;
handles.readyColor = [1 1 1];
handles.runningColor = [104/255 151/255 187/255];
handles.finishedColor = [102/255 205/255 170/255];
handles.savingColor = [211/255 71/255 31/255];
grid on;
grid minor;
guidata(hObject, handles);
axes(handles.axes1);
%title('Platoon-Based Autonomous Intersection Management');
xlim([0 400]);
ylim([0 400]);
%grid on
%grid minor
set(handles.resetbutton,'Enable','off');
set(handles.savevideo,'Enable','off');

%axes(handles.axes1);




% UIWAIT makes simulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulator_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%clf;
handles.simTime = round(get(handles.duration,'Value'));
handles.simSpeed = round(get(handles.simulationSpeed,'Value'));
handles.spawnRate = round(get(handles.spawn,'Value'));

axes(handles.axes1);
g = 400;
contents = str2double(get(handles.platoonSize,'String'));
maxSize= contents(get(handles.platoonSize,'Value'));
set(handles.resetbutton,'Enable','on');
set(handles.savevideo,'Enable','off');
set(handles.start,'Enable','off');
set(handles.status, 'BackgroundColor',handles.runningColor);
set(handles.status, 'String','Simulation is Running');
policyNumber = get(handles.policy,'Value');
seed = 154;
if(policyNumber==1)
    [handles.F,p,var,vDelay,pDelay,tv,tvc] = AIM(seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
elseif(policyNumber==2)
    %     [handles.Fcc,p,var,vDelay,pDelay,tv,tvc] = AIM_Optimal(1,seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
    %     vDelay
    %     var
    %     cc
    [handles.F,cc,p,var,vDelay,pDelay,tv,tvc] = AIM_Optimal('pdm',2,seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
    vDelay
    var
    cc
elseif(policyNumber==3)
    %     [handles.Fcc,p,var,vDelay,pDelay,tv,tvc] = AIM_Optimal(1,seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
    %     vDelay
    %     var
    %     cc
    [handles.F,cc,p,var,vDelay,pDelay,tv,tvc] = AIM_Optimal('pvm',2,seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
    vDelay
    var
    cc
elseif(policyNumber==4)
    %     [handles.Fcc,p,var,vDelay,pDelay,tv,tvc] = AIM_Optimal(1,seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
    %     vDelay
    %     var
    %     cc
    fprintf('running the grouped policy....\n');
    [fcpv,handles.F,cc,p,var,vDelay,pDelay,tv,tvc] = AIM_Optimal2('pvm',2,seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
    %     vDelay
    %     var
    %     cc
elseif(policyNumber==5)
    
    fprintf('running the Traffic Light policy....\n');
    [fcpv,handles.F,cc,p,var,vDelay,pDelay,tv,tvc] = trafficLight('pvm',2,seed,g,maxSize,handles.spawnRate,handles.simTime,handles.simSpeed,handles);
    %     vDelay
    %     var
    %     cc
end
fprintf('The Average Delay per Vehicle is %f\n', vDelay)

guidata(hObject,handles);
set(handles.status, 'BackgroundColor',handles.finishedColor);
set(handles.status, 'String','Finished');
set(handles.start,'Enable','on');
set(handles.resetbutton,'Enable','off');
set(handles.savevideo,'Enable','on');





% --- Executes on selection change in granularity.
function granularity_Callback(hObject, eventdata, handles)
% hObject    handle to granularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns granularity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from granularity


% --- Executes during object creation, after setting all properties.
function granularity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to granularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetbutton.
function resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%axes(handles.axes1);
%error('stop requested by user');
%handles.stop=1;
%guidata(hObject,handles);
%clc;
cla;
grid on;
grid minor;
set(handles.status, 'BackgroundColor',handles.finishedColor);
set(handles.status, 'String','Ready!');
set(handles.start,'Enable','on');
set(handles.savevideo,'Enable','off');



% --- Executes on slider movement.
function duration_Callback(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.simTime = round(get(hObject,'Value'));
labelText = strcat(num2str(handles.simTime),' Sec.');
set(handles.durationlabel,'String',labelText);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over start.
function start_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in savevideo.
function savevideo_Callback(hObject, eventdata, handles)
% hObject    handle to savevideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'Enable','off');
set(handles.status, 'BackgroundColor',handles.savingColor);
set(handles.status, 'String','Saving Video');
pause(0.5);
policyNumber = get(handles.policy,'Value');
uniqueNumber = num2str(randi([0 100])*100+policyNumber);
video = VideoWriter(strcat('AIM-Demo-',uniqueNumber),'MPEG-4');
video.FrameRate = 25;
open(video);
writeVideo(video,handles.F);
close(video);
set(handles.status, 'BackgroundColor',handles.finishedColor);
set(handles.status, 'String','Video was saved to File!');
set(handles.start,'Enable','on');


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in platoonSize.
function platoonSize_Callback(hObject, eventdata, handles)
% hObject    handle to platoonSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns platoonSize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from platoonSize


% --- Executes during object creation, after setting all properties.
function platoonSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to platoonSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function simulationSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to simulationSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.simSpeed = round(get(hObject,'Value'));
labelText = strcat(num2str(handles.simSpeed),'X');
set(handles.speedlabel,'String',labelText);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function simulationSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simulationSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function spawn_Callback(hObject, eventdata, handles)
% hObject    handle to spawn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.spawnRate = round(get(hObject,'Value'));
labelText = strcat(num2str(handles.spawnRate),' Veh/H/L');
set(handles.spawnLabel,'String',labelText);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function spawn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spawn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in policy.
function policy_Callback(hObject, eventdata, handles)
% hObject    handle to policy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns policy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from policy


% --- Executes during object creation, after setting all properties.
function policy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to policy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in experiment.
function experiment_Callback(hObject, eventdata, handles)
% hObject    handle to experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.simTime = round(get(handles.duration,'Value'));
handles.simSpeed = round(get(handles.simulationSpeed,'Value'));
handles.spawnRate = round(get(handles.spawn,'Value'));
axes(handles.axes1);
g = 400;
contents = str2double(get(handles.platoonSize,'String'));
maxSize= contents(get(handles.platoonSize,'Value'));
set(handles.resetbutton,'Enable','on');
set(handles.savevideo,'Enable','off');
set(handles.start,'Enable','off');
set(handles.status, 'BackgroundColor',handles.runningColor);
set(handles.status, 'String','Simulation is Running');
policyNumber = get(handles.policy,'Value');
totalVehicles = 0;
totalVehiclesCrossed = 0;
trafficFlows = [];
counter=0;
seed = 1234;
for j = 500:100:1500
    trafficFlows = [trafficFlows j];
    counter = counter+1;
    n_exp = 1;
    for i=1:8
        seed = 1234;
        if(policyNumber==1)
            p = zeros(1,n_exp);
            v = zeros(1,n_exp);
            vDelay = zeros(1,n_exp);
            pDelay = zeros(1,n_exp);
            fprintf('Max_Platoon = %d, Traffic Level = %d\n',i,j);
            for n=1:n_exp
                seed = seed+n;
                [p(n),v(n),vDelay(n),pDelay(n),tv,tvc] = AIM(seed,g,i,j,handles.simTime,handles.simSpeed,handles);
                fprintf('Experiment #%d\n',n);
                Average_Delay_Per_Vehicle = vDelay(n)
                cla
            end
            fprintf('Max_Platoon = %d, Traffic Level = %d\n',i,j);
            v;
            vDelay;
            packets(i,counter) = mean(p);
            var(i,counter) = mean(v);
            AverageDelayPerVehicle(i,counter) = mean(vDelay)
            AverageDelayPerPlatoon(i,counter) = mean(pDelay);
        elseif(policyNumber==2)
            [p,var(i,counter),vDelay,pDelay,tv,tvc] = AIM_Optimal(g,i,j,handles.simTime,handles.simSpeed,handles);
            packets(i,counter)=p;
            AverageDelayPerVehicle(i,counter) = vDelay;
            AverageDelayPerPlatoon(i,counter) = pDelay;
        end
        %totalVehicles(i,counter) = sum(tv);
        %totalVehiclesCrossed(i,counter) = sum(tvc);
        %AverageDelayPerVehicle
        %packets
        
    end
end
figure
plot(trafficFlows,AverageDelayPerVehicle(1,:),'color','r','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,AverageDelayPerVehicle(2,:),'color','g','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,AverageDelayPerVehicle(3,:),'color','b','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,AverageDelayPerVehicle(4,:),'color','c','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,AverageDelayPerVehicle(5,:),'color','k','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,AverageDelayPerVehicle(6,:),'color','m','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,AverageDelayPerVehicle(7,:),'color','y','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,AverageDelayPerVehicle(8,:),'color',[0.545 0.27 0.074],'marker','o','lineStyle','--','lineWidth',1);
legend('Max-Platoon-Size=1','Max-Platoon-Size=2','Max-Platoon-Size=3' ...
    ,'Max-Platoon-Size=4','Max-Platoon-Size=5','Max-Platoon-Size=6' ...
    ,'Max-Platoon-Size=7','Max-Platoon-Size=8');
xlabel('Traffic Level (Vehicle/Hour/Lane)');
ylabel('Average Delay (S)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(trafficFlows,var(1,:),'color','r','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,var(2,:),'color','g','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,var(3,:),'color','b','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,var(4,:),'color','c','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,var(5,:),'color','k','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,var(6,:),'color','m','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,var(7,:),'color','y','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,var(8,:),'color',[0.545 0.27 0.074],'marker','o','lineStyle','--','lineWidth',1);
legend('Max-Platoon-Size=1','Max-Platoon-Size=2','Max-Platoon-Size=3' ...
    ,'Max-Platoon-Size=4','Max-Platoon-Size=5','Max-Platoon-Size=6' ...
    ,'Max-Platoon-Size=7','Max-Platoon-Size=8');
xlabel('Traffic Level (Vehicle/Hour/Lane)');
ylabel('Travel Delay Variance (S^2)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(trafficFlows,packets(1,:),'color','r','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,packets(2,:),'color','g','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,packets(3,:),'color','b','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,packets(4,:),'color','c','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,packets(5,:),'color','k','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,packets(6,:),'color','m','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,packets(7,:),'color','y','marker','o','lineStyle','--','lineWidth',1);
hold on
plot(trafficFlows,packets(8,:),'color',[0.545 0.27 0.074],'marker','o','lineStyle','--','lineWidth',1);
legend('Max-Platoon-Size=1','Max-Platoon-Size=2','Max-Platoon-Size=3' ...
    ,'Max-Platoon-Size=4','Max-Platoon-Size=5','Max-Platoon-Size=6' ...
    ,'Max-Platoon-Size=7','Max-Platoon-Size=8');
xlabel('Traffic Level (Vehicle/Hour/Lane)');
ylabel('# Packets Exchanged');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% congestion = totalVehicles-totalVehiclesCrossed
% plot(trafficFlows,congestion(1,:),'ro-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(2,:),'bo-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(3,:),'mo-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(4,:),'go-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(5,:),'ko-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(6,:),'co-.','lineWidth',2);
% legend('Max-Platoon-Size=1','Max-Platoon-Size=2','Max-Platoon-Size=3' ...
%     ,'Max-Platoon-Size=4','Max-Platoon-Size=5','Max-Platoon-Size=6');
% title('Average Congestion');
guidata(hObject,handles);
set(handles.status, 'BackgroundColor',handles.finishedColor);
set(handles.status, 'String','Finished');
set(handles.start,'Enable','on');
set(handles.resetbutton,'Enable','off');
set(handles.savevideo,'Enable','on');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.simTime = round(get(handles.duration,'Value'));
handles.simSpeed = round(get(handles.simulationSpeed,'Value'));
handles.spawnRate = round(get(handles.spawn,'Value'));
axes(handles.axes1);
g = 400;
contents = str2double(get(handles.platoonSize,'String'));
maxSize= contents(get(handles.platoonSize,'Value'));
set(handles.resetbutton,'Enable','on');
set(handles.savevideo,'Enable','off');
set(handles.start,'Enable','off');
set(handles.status, 'BackgroundColor',handles.runningColor);
set(handles.status, 'String','Simulation is Running');
policyNumber = get(handles.policy,'Value');
totalVehicles = 0;
totalVehiclesCrossed = 0;
trafficFlows = [];
counter=0;
seed = 154;
seed = 0;
callCounter=[];
%for kk =1:6
%   seed = 1233+kk;
F=[];
ver=2;
capacities = [];
fcpv=zeros(3,3);
expCounter = 0;
trafficFlows = [500 600 700 800];

for maxSize=1:5
    counter=0;
    for j = [500 600 700 800]%low, medium and high traffic flow
        %seed = seed + 1;
        %expCounter = expCounter+1;
        %trafficFlows = [trafficFlows j];
        counter = counter+1;
        [fcpv(expCounter+1,counter),F,callCounter(expCounter+1,counter),p,var(expCounter+1,counter),vDelay,pDelay,tv,tvc] = trafficLight('pvm',2,seed,g,maxSize,j,handles.simTime,handles.simSpeed,handles);
        %[fcpv(expCounter+1,counter),F,callCounter(expCounter+1,counter),p,var(expCounter+1,counter),vDelay,pDelay,tv,tvc] = AIM_Optimal2('pdm',2,seed,g,maxSize,j,handles.simTime,handles.simSpeed,handles);
        packets(expCounter+1,counter) = p;
        AverageDelayPerVehicle(expCounter+1,counter) = vDelay;
        AverageDelayPerPlatoon(expCounter+1,counter) = pDelay;
        fprintf("TrafficLight Lane Traffic in %d seconds = [%d,%d,%d,%d]\n",handles.simTime,tvc);
        tv_sum = sum(tv);
        tvc_sum = sum(tvc);
        capacities(expCounter+1,counter) = tvc_sum*3600/(handles.simTime);
        fprintf("Capacity = %.0fveh/h\n",capacities(expCounter+1,counter));
        fprintf("FCPV = %.0fml/v",fcpv(expCounter+1,counter));
        %fprintf("FuelConsumptionPerVehicle = %.0fml\n",fcpv(expCounter+1,counter));
        fprintf("AverageDelayPerVehicle = %.0fs\n",vDelay);
        cla
        [fcpv(expCounter+2,counter),F,callCounter(expCounter+2,counter),p,var(expCounter+2,counter),vDelay,pDelay,tv,tvc] = AIM_Optimal2('pvm',2,seed,g,maxSize,j,handles.simTime,handles.simSpeed,handles);
        packets(expCounter+2,counter)=p;
        AverageDelayPerVehicle(expCounter+2,counter) = vDelay;
        AverageDelayPerPlatoon(expCounter+2,counter) = pDelay;
        fprintf("Grouped-PVM Lane Traffic in %d seconds = [%d,%d,%d,%d]\n",handles.simTime,tvc);
        tv_sum = sum(tv);
        tvc_sum = sum(tvc);
        capacities(expCounter+2,counter) = tvc_sum*3600/handles.simTime;
        fprintf("Capacity = %.0fveh/h\n",capacities(expCounter+2,counter));
        fprintf("FCPV = %.0fml/v",fcpv(expCounter+2,counter));
        %fprintf("FuelConsumptionPerVehicle = %.0fml\n",fcpv(expCounter+2,counter));
        fprintf("AverageDelayPerVehicle = %.0fs\n",vDelay);
        
        cla
        [fcpv(expCounter+3,counter),F,callCounter(expCounter+3,counter),p,var(expCounter+3,counter),vDelay,pDelay,tv,tvc] = AIM_Optimal2('pdm',2,seed,g,maxSize,j,handles.simTime,handles.simSpeed,handles);
        packets(expCounter+3,counter)=p;
        AverageDelayPerVehicle(expCounter+3,counter) = vDelay;
        AverageDelayPerPlatoon(expCounter+3,counter) = pDelay;
        fprintf("Grouped-PDM Lane Traffic in %d seconds = [%d,%d,%d,%d]\n",handles.simTime,tvc);
        tv_sum = sum(tv);
        tvc_sum = sum(tvc);
        capacities(expCounter+3,counter) = tvc_sum*3600/handles.simTime;
        fprintf("Capacity = %.0fveh/h\n",capacities(expCounter+3,counter));
        fprintf("FCPV = %.0fml/v",fcpv(expCounter+3,counter));
        %fprintf("FuelConsumptionPerVehicle = %.0fml\n",fcpv(expCounter+3,counter));
        fprintf("AverageDelayPerVehicle = %.0fs\n",vDelay);
        
        cla
        
    end
        expCounter = expCounter+3;
end
% figure
% for plt=1:12
% plot(trafficFlows,AverageDelayPerVehicle(plt,:),'color','k','marker','d','lineStyle','-','lineWidth',1);
% hold on
% end
% % plot(trafficFlows,AverageDelayPerVehicle(2,:),'color','k','marker','o','lineStyle','-','lineWidth',1);
% % hold on
% % plot(trafficFlows,AverageDelayPerVehicle(3,:),'color','r','marker','d','lineStyle','-','lineWidth',1);
% % hold on
% % plot(trafficFlows,AverageDelayPerVehicle(4,:),'color','r','marker','o','lineStyle','-','lineWidth',1);
% % hold on
% % plot(trafficFlows,AverageDelayPerVehicle(5,:),'color','c','marker','d','lineStyle','-','lineWidth',1);
% % hold on
% % plot(trafficFlows,AverageDelayPerVehicle(6,:),'color','c','marker','o','lineStyle','-','lineWidth',1);
% % hold on
% % plot(trafficFlows,AverageDelayPerVehicle(7,:),'color','g','marker','d','lineStyle','-','lineWidth',1);
% % hold on
% % plot(trafficFlows,AverageDelayPerVehicle(8,:),'color','g','marker','o','lineStyle','-','lineWidth',1);
% 
% % legend('Policy = TL-MaxSize=1','Policy = PVM-MaxSize=1','Policy = PDM-MaxSize=1'...
% %     ,'Policy = TL-MaxSize=2','Policy = PVM-MaxSize=2','Policy = PDM-MaxSize=2'...
% %     ,'Policy = TL-MaxSize=3','Policy = PVM-MaxSize=3','Policy = PDM-MaxSize=3'...
% %     ,'Policy = TL-MaxSize=4','Policy = PVM-MaxSize=4','Policy = PDM-MaxSize=4');
% xlabel('Traffic Level (Vehicle/Hour/Lane)');
% ylabel('Average Delay (S)');
% grid minor
% 
% figure
% for plt=1:12
% plot(trafficFlows,capacities(plt,:),'color','k','marker','d','lineStyle','-','lineWidth',1);
% hold on
% end
% % plot(trafficFlows,capacities(1,:),'color','k','marker','d','lineStyle','--','lineWidth',1);
% % hold on
% % plot(trafficFlows,capacities(2,:),'color','r','marker','d','lineStyle','--','lineWidth',1);
% 
% % legend('Policy = TL-MaxSize=1','Policy = PVM-MaxSize=1','Policy = PDM-MaxSize=1'...
% %     ,'Policy = TL-MaxSize=2','Policy = PVM-MaxSize=2','Policy = PDM-MaxSize=2'...
% %     ,'Policy = TL-MaxSize=3','Policy = PVM-MaxSize=3','Policy = PDM-MaxSize=3'...
% %     ,'Policy = TL-MaxSize=4','Policy = PVM-MaxSize=4','Policy = PDM-MaxSize=4');
% xlabel('Traffic Level (Vehicle/Hour/Lane)');
% ylabel('Intersection Capacity (Vehicle/Hour)');
% grid minor
% 
% 
% % figure
% % plot(trafficFlows,fcpv(1,:),'color','k','marker','d','lineStyle','--','lineWidth',1);
% % hold on
% % plot(trafficFlows,fcpv(2,:),'color','r','marker','d','lineStyle','--','lineWidth',1);
% % 
% % legend('Policy = TL','Policy = PAIM');
% % xlabel('Traffic Level (Vehicle/Hour/Lane)');
% % ylabel('Fuel Consumption Per Vehicle (ml)');
% % grid minor

save('capacities.mat','capacities');
save('trafficFlows.mat','trafficFlows');
save('ave_delays.mat','AverageDelayPerVehicle');
save('variances.mat','var');
save('fcpv.mat','fcpv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plotting Variance
% figure
% plot(trafficFlows,var(1,:),'color','k','marker','d','lineStyle','--','lineWidth',1);
% hold on
% plot(trafficFlows,var(2,:),'color','r','marker','d','lineStyle','--','lineWidth',1);
% hold on
% plot(trafficFlows,var(3,:),'color','b','marker','d','lineStyle','--','lineWidth',1);
% legend('Policy = PVM','Policy = PDM','Policy = Grouped-PVM');
% xlabel('Traffic Level (Vehicle/Hour/Lane)');
% ylabel('Travel Delay Variance (S^2)');
% grid minor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% plot(trafficFlows,packets(1,:),'color','k','marker','d','lineStyle','--','lineWidth',1);
% hold on
% plot(trafficFlows,packets(2,:),'color','r','marker','d','lineStyle','--','lineWidth',1);
% hold on
% plot(trafficFlows,packets(3,:),'color','b','marker','d','lineStyle','--','lineWidth',1);
% legend('Policy = StopSign','Policy = Optimal','Policy = Optimal-Updating');
% xlabel('Traffic Level (Vehicle/Hour/Lane)');
% ylabel('# Packets Exchanged With the Infrastructure');
% grid minor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% congestion = totalVehicles-totalVehiclesCrossed
% plot(trafficFlows,congestion(1,:),'ro-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(2,:),'bo-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(3,:),'mo-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(4,:),'go-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(5,:),'ko-.','lineWidth',2);
% hold on
% plot(trafficFlows,congestion(6,:),'co-.','lineWidth',2);
% legend('Max-Platoon-Size=1','Max-Platoon-Size=2','Max-Platoon-Size=3' ...
%     ,'Max-Platoon-Size=4','Max-Platoon-Size=5','Max-Platoon-Size=6');
% title('Average Congestion');
guidata(hObject,handles);
set(handles.status, 'BackgroundColor',handles.finishedColor);
set(handles.status, 'String','Finished');
set(handles.start,'Enable','on');
set(handles.resetbutton,'Enable','off');
set(handles.savevideo,'Enable','on');
