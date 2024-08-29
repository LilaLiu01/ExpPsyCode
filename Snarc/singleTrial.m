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

% ���ð�����׼�����
KbName('UnifyKeyNames');

% ׼��������������ָ��
KeyPressArray = [KbName('f') KbName('j')];       %����2������

% Start
% blank interval for 1000ms
Screen('FillRect', wptr,bkgColor);  %׼������
Screen('Flip', wptr);        %����
WaitSecs(blank_Interval_1000);    %Duration

% show the fixation  
fixation_Texture = Screen('MakeTexture',wptr, imgMatrix_Fixation);
Screen('DrawTexture', wptr, fixation_Texture);
Screen('Flip',wptr);
WaitSecs(fixation_Interval);    %Duration == 500 ms

% blank interval for 200ms
Screen('FillRect', wptr,bkgColor);  %׼������
Screen('Flip', wptr);        %����
WaitSecs(blank_Interval_500);    %Duration

% show the corresponding stimuli
cjItem_ID = cjMatrix(ID, Column_Digit);
imgMatrix_num = cjSeries{cjItem_ID};
num_Texture = Screen('MakeTexture',wptr, imgMatrix_num);
Screen('DrawTexture', wptr, num_Texture);
Screen('Flip',wptr);

t0 = GetSecs;   %������ʱ��

while 1     %�ȴ����Է�Ӧ
    [~, t, key_Code] = KbCheck;      %��������
    
    % �������Ϊ f j �����е�����һ��
    if key_Code(KbName('f')) | key_Code(KbName('j'))
        rt = t - t0;
        acc = key_Code(KeyPressArray(cjMatrix(ID, Column_CorrectResponse)));

        break;

    end

    % �������ΪESC
    if key_Code(KbName('ESCAPE'))  %�������Ϊesc������ֵΪ1
        rt = 9999;    %ACCΪ999�����б�ǣ������˳�����
        acc = 999;
        break;
    end
    
    % �������������ʱ��
    tt = GetSecs;   %������ʱ��
    if tt-t0>timeUpperLimit
        rt = 3000;
        acc = 0;
        break;
    end
    
    
end

%�������while����� �ó�����acc���������
%1.��ȷ��Ӧ             acc=1
%2.����Ӧ��δ��Ӧ     acc=0
%3.������ESCAPE��       acc=999



end