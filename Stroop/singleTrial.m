function [rt acc] = singleTrial(wptr, cjMatrix, ID, imgMatrix_Fixation, cjSeries, imgMat_Error)

% prepare foldernames
picFolderName = 'Pics';

% prepare colors
bkgColor = [0 0 0];

% prepare Columns
TrialID_Column = 1;
Word_Column = 2;
Color_Column = 3;
Type_Column = 4;
CorrectResponse_Column = 5;

% prepare parameters
fixation_Interval = 0.5;  % 500 ms
blank_Interval_200 = 0.2;     % 200 ms
timeInterval_showError = 1;
timeUpperLimit = 3;
blank_Interval_3000 = 3;
blank_Interval_1000 = 1;

% ���ð�����׼�����
KbName('UnifyKeyNames');

% ׼������������������
KeyPressArray = [KbName('j') KbName('k') KbName('l')];       %����3������



% ��ʼ
% ����1��
Screen('FillRect', wptr,bkgColor);  %׼������
Screen('Flip', wptr);        %����
WaitSecs(blank_Interval_1000);    %Duration

% show the fixation for 
Screen('PutImage',wptr, imgMatrix_Fixation);
Screen('Flip',wptr);
WaitSecs(fixation_Interval);    %Duration == 500 ms

% ����1��
Screen('FillRect', wptr,bkgColor);  %׼������
Screen('Flip', wptr);        %����
WaitSecs(blank_Interval_200);    %Duration

% show the cj
cjItem_ID = cjMatrix(ID, Type_Column);
imgMatrix_colorWord = cjSeries{cjItem_ID};
Screen('PutImage',wptr, imgMatrix_colorWord);
Screen('Flip',wptr);

t0 = GetSecs;   %������ʱ��

while 1     %�ȴ����Է�Ӧ
    [~, t, key_Code] = KbCheck;      %��������
    
    % �������Ϊ j k l �����е�����һ��
    if key_Code(KbName('j')) | key_Code(KbName('k')) | key_Code(KbName('l'))
        rt = t - t0;
        acc = key_Code(KeyPressArray(cjMatrix(ID, CorrectResponse_Column)));
%         if acc == 1
              break;
%         else
%               
%         end
    end

    % �������ΪESC
    if key_Code(KbName('ESCAPE'))  %�������Ϊesc������ֵΪ1
        rt = 9999;    %ACCΪ999�����б�ǣ������˳�����
        acc = 9999;
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


% ��������ˣ�����һ��������ʾ��Ϣ1s
if acc == 9999

else
    if acc
        
    else
        % ����0.2��
        Screen('PutImage',wptr, imgMat_Error);
        Screen('Flip',wptr);
        WaitSecs(timeInterval_showError);    %Duration
    end
    
end







end