function ConsoleSerialPort( serial_com )
global s;
global line1;
global line2;
global line3;
global x1;
global y1;
global x2;
global y2;
global x3;
global y3;
global x4;
global y4;
global fid;
s = [];
try
    s = serial(serial_com);
catch ex
    error('cant open serial');
    disp(ex.message);
    return;
end

set(s,'BaudRate',115200, 'DataBits',8,'StopBits',1,'Parity', 'None','FlowControl','none');
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcnCount = 21;
s.BytesAvailableFcn = {@SerialPort_Callback};
fid = figure;
set(fid,'CloseRequestFcn',@figureCloseCallback);
% subplot(3,1,1);
% line1 = plot(0,0);
% subplot(3,1,2);
% % hold on;
% line2 = plot(0,0,'r');
% subplot(3,1,3);
% line3 = plot(0,0,'k');
x1 = [];
y1 = [];
x2 = [];
y2 = [];
x3 = [];
y3 = [];
x4 = [];
y4 = [];


fopen(s);

% pause;
% fclose(s);
% delete(s);
% clear s;
% clear;
% close all;

end

function SerialPort_Callback(obj,~,~)
global line1;
global line2;
global line3;
global line4;
global line5;
global line6;
global x1;
global y1;
global x2;
global y2;
global x3;
global y3;
global x4;
global y4;
try
    out = fread(obj, obj.BytesAvailable, 'uint8');
%     disp(out');
    switch out(1)
        case 0
            if isempty(x1)
                x1 = 0;
                y1 = mean(Format8To16(out(2:end-2), 9));
                subplot(3,2,1);
                line1 = plot(x1,y1);
            else
            %%
    %         x1 = [x1 x1(end)+1:x1(end)+9];
    %         y1 = [y1 Format8To16(out(2:end-2), 9)];
           %%
            x1 = [x1 length(x1)];
            y1 = [y1 mean(Format8To16(out(2:end-2), 9))];
            %%
            set(line1, 'xdata', x1, 'ydata', y1);     
            end
        case 1
            if isempty(x2)
                x2 = 0;
                y2 = mean(Format8To16(out(2:end-2), 9));
                subplot(3,2,3);
                line2 = plot(x2,y2,'r');
            else
            %%
    %         x2 = [x2 x2(end)+1:x2(end)+9];
    %         y2 = [y2 Format8To16(out(2:end-2), 9)];
            %%
            x2 = [x2 length(x2)];
            y2 = [y2 mean(Format8To16(out(2:end-2), 9))];
            set(line2, 'xdata', x2, 'ydata', y2);  
            end
            %%
    %         disp(res_co2);
        case 2
            if isempty(x3)
                x3 = 0;
                y3 = mean(Format8To16(out(2:end-2), 9));
                subplot(3,2,2);
                line4 = plot(x3,y3);
            else
            %%
    %         x3 = [x3 x3(end)+1:x3(end)+9];
    %         y3 = [y3 Format8To16(out(2:end-2), 9)];
           %%
            x3 = [x3 length(x3)];
            y3 = [y3 mean(Format8To16(out(2:end-2), 9))];
            %%
            set(line4, 'xdata', x3, 'ydata', y3);     
            end
        case 3
            if isempty(x4)
                x4 = 0;
                y4 = mean(Format8To16(out(2:end-2), 9));
                subplot(3,2,4);
                line5 = plot(x4,y4,'r');
            else
            %%
    %         x4 = [x4 x4(end)+1:x4(end)+9];
    %         y4 = [y4 Format8To16(out(2:end-2), 9)];
           %%
            x4 = [x4 length(x4)];
            y4 = [y4 mean(Format8To16(out(2:end-2), 9))];
            %%
            set(line5, 'xdata', x4, 'ydata', y4);     
            end
        otherwise
            disp('error type');
    end
    
    if length(x1) == length(x2)
        if length(x1)==1            
            subplot(3,2,5);
            line3 = plot(x1,y1-y2,'k');
        else
        set(line3, 'xdata', x1, 'ydata', y1-y2);   
        end
    end
    
    if length(x3) == length(x4)
        if length(x3)==1            
            subplot(3,2,6);
            line6 = plot(x3,y3-y4,'k');
        else
        set(line6, 'xdata', x3, 'ydata', y3-y4);   
        end
    end
    
    drawnow;
catch ex
    disp(ex.message);
end
end

function [res] = Format8To16(data, num)
res = [];
for i=0:num-1
    res = [res  bitshift(uint16(data(i*2 +2)), 8) + data(i*2 +1)];
end
end

function figureCloseCallback( obj,~,~ )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
global s;
global x1;
global y1;
global x2;
global y2;
global x3;
global y3;
global x4;
global y4;

selection = questdlg(  'Close This Figure?',...
                      'Close Request Function',...
                      'Yes','No','Yes'); 
switch selection, 
  case 'Yes',
      try
%           save('param.mat','x1','x2','y1','y2');
           save(['param' datestr(now, 'mmdd_HH_MM_SS') '.mat'], 'x1','x2','y1','y2', 'x3', 'y3', 'x4', 'y4');
      catch ex
          msgbox(ex.message);
      end
      try
          
        disp('close figure');
        fclose(s);
        delete(s);
      catch ex
          msgbox(ex.message);
      end
         delete(obj);
         clear;
  case 'No'
  return 
end
end





