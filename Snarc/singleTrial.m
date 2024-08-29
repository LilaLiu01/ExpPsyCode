function [rt acc] = singleTrial(wptr, cjMatrix, ID, imgMatrix_Fixation, cjSeries)

% prepare foldernames
picFolderName = 'PicturesR';

% prepare colors
bkgColor = [0 0 0];

% prepare the column names
Column_TrialID = 1;
Column_Digit = 2;
Column_digitType = 3;
Column_CorrectResponse = 4;


% prepare parameters
fixation_Interval = 0.5;  % 500 ms
blank_Interval_500 = 0.5;     % 200 ms
digitDuration = 0.2;
timeUpperLimit = 3;
blank_Interval_1000 = 1;

% 设置按键的准备情况
KbName('UnifyKeyNames');

% 准备好两个按键的指向
KeyPressArray = [KbName('f') KbName('j')];       %定义2个按键

% Start
% blank interval for 1000ms
Screen('FillRect', wptr,bkgColor);  %准备黑屏
Screen('Flip', wptr);        %黑屏
WaitSecs(blank_Interval_1000);    %Duration

% show the fixation  
fixation_Texture = Screen('MakeTexture',wptr, imgMatrix_Fixation);
Screen('DrawTexture', wptr, fixation_Texture);
Screen('Flip',wptr);
WaitSecs(fixation_Interval);    %Duration == 500 ms

% blank interval for 200ms
Screen('FillRect', wptr,bkgColor);  %准备黑屏
Screen('Flip', wptr);        %黑屏
WaitSecs(blank_Interval_500);    %Duration

% show the corresponding stimuli
cjItem_ID = cjMatrix(ID, Column_Digit);
imgMatrix_num = cjSeries{cjItem_ID};
num_Texture = Screen('MakeTexture',wptr, imgMatrix_num);
Screen('DrawTexture', wptr, num_Texture);
Screen('Flip',wptr);

t0 = GetSecs;   %启动计时器

while 1     %等待被试反应
    [~, t, key_Code] = KbCheck;      %监听按键
    
    % 如果按键为 f j 两个中的任意一个
    if key_Code(KbName('f')) | key_Code(KbName('j'))
        rt = t - t0;
        acc = key_Code(KeyPressArray(cjMatrix(ID, Column_CorrectResponse)));

        break;

    end

    % 如果按键为ESC
    if key_Code(KbName('ESCAPE'))  %如果按键为esc，返回值为1
        rt = 9999;    %ACC为999，进行标记，用于退出程序
        acc = 999;
        break;
    end
    
    % 如果不按键，超时了
    tt = GetSecs;   %启动计时器
    if tt-t0>timeUpperLimit
        rt = 3000;
        acc = 0;
        break;
    end
    
    
end

%在上面的while语句中 得出来的acc有三种情况
%1.正确反应             acc=1
%2.错误反应或未反应     acc=0
%3.按键“ESCAPE”       acc=999



end