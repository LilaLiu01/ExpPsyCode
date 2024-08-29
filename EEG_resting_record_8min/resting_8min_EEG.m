%% 采集8minEEG数据
% 程序1：睁眼1min+闭眼1min，4 times
% 程序2：闭眼1min+睁眼1min，4 times


clc;
clear;
lptwrite(8192,0); % 清空窗口

subinfo = GetSubInfo;
id = str2double(subinfo{1});
if mod(id,2) == 1
    for i = 1:4
        [y,Fs] = audioread('./open.mp3');
        sound(y,Fs);
        WaitSecs(5); % 提示音播放5s后再打marker
        marker = 10+i;
        lptwrite(8192,0);
        disp('open'); % 等待，记录1minEEG数据
        WaitSecs(60);
        lptwrite(8192,111);
        WaitSecs(0.001);
        lptwrite(8192,0);
        WaitSecs(3);
        
        
        [y,Fs] = audioread('./close.mp3');
        sound(y,Fs);
        WaitSecs(5);
        % 标记闭眼开始的marker“121”
        marker = 20+i;
        lptwrite(8192,marker);
        WaitSecs(0.001);
        lptwrite(8192,0);
        % 等待，记录1min的EEG数据
        WaitSecs(60);
        % 标记闭眼结束的marker“112”
        lptwrite(8192,112);
        WaitSecs(0.001);
        lptwrite(8192,0);
        WaitSecs(3);
    end
    
else
    for i = 1:4
        [y,Fs] = audioread('./close.mp3');
        sound(y,Fs);
        WaitSecs(5);
        % 标记闭眼开始的marker“121”
        marker = 20+i;
        lptwrite(8192,marker);
        WaitSecs(0.001);
        lptwrite(8192,0);
        % 等待，记录1min的EEG数据
        WaitSecs(60);
        % 标记闭眼结束的marker“112”
        lptwrite(8192,112);
        WaitSecs(0.001);
        lptwrite(8192,0);
        WaitSecs(3);
        
        % 加载提示音（睁眼）
        [y,Fs] = audioread('./open.mp3');
        sound(y,Fs);
        WaitSecs(5); % 提示音播放5s后再打marker
        marker1 = 10+i;
        % 标记第一次睁眼开始的marker
        lptwrite(8192,marker1);
         WaitSecs(0.001);
        lptwrite(8192,0);
        disp('open');
        % 等待，记录1min的EEG数据
        WaitSecs(60);
        % 标记睁眼结束的marker“111”
        lptwrite(8192,111);
        WaitSecs(0.001);
        lptwrite(8192,0);
        WaitSecs(3);
    end
end

[y1,Fs1] = audioread('Iwang.wav');
sound(y1,Fs1);
disp('end');


        
       
