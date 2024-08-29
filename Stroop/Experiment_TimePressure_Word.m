% filename is:: Experiment_TimePressure_Word.m

% clear
clc; clear; close all;

% prepare foldernames
% prepare
picsFolderName = 'Pics';

% prepare strCells
strCells_Words = {'��'; '��'; '��'};
strCells_Words_Eng = {'Green'; 'Red'; 'Blue'};
strCells_Colors = {[0 1 0]; [1 0 0]; [0 0 1]};
strCells_Colors_Eng = {'GREEN'; 'RED'; 'BLUE'};

% ��취��ȡ��Ӧ��ϵ coreItems 1-9  ==> tmpMat [word color]
% word
oriArr_word = [1 2 3]';
arr_word_9 = kron(oriArr_word, ones(3,1));

% color
oriArr_color = [1 2 3]';
arr_color_9 = [oriArr_color;oriArr_color;oriArr_color];

% combine
tmpMat_9 = [arr_word_9 arr_color_9];   % 1 -> 9

% coreItem_Arr
coreItem_Arr = 1:9;
coreItem_Arr = coreItem_Arr';

imgMat_cjCells = {}; 
for p = 1:length(coreItem_Arr)
    tmpItem = coreItem_Arr(p);
    tmpMat_word_color = tmpMat_9(tmpItem,:);
    wordID = tmpMat_word_color(1);
    colorID = tmpMat_word_color(2);
    tmpWord = strCells_Words_Eng{wordID};
    tmpColor = strCells_Colors_Eng{colorID};
    jpgFileName = sprintf('word_%s_color_%s.jpg', tmpWord, tmpColor);
    jpgPathName = sprintf('%s/%s', picsFolderName, jpgFileName);
    
    imgMat_cjCells{p} = imread(jpgPathName);
end
imgMat_cjCells = imgMat_cjCells';



try



% filename
jpgFileName_Instruction = 'Instruction_Start_Word.jpg';
jpgPathName_Instruction = sprintf('%s/%s', picsFolderName, jpgFileName_Instruction);

%
imgMat_Instruction_Word = imread(jpgPathName_Instruction);

% prepare color for background
bkgColor = [0 0 0];

% openwindow
%����
% Screen('Preference', 'SkipSyncTests', 1);
% Screen('Preference', 'ConserveVRAM', 64);


[wptr, rect] = Screen('OpenWindow', 0, bkgColor);

% �رռ��̼���
ListenChar(2);

% ����
HideCursor;

% show the instruction
Instruction(wptr, imgMat_Instruction_Word);

% �ȴ����԰���
% KbWait;

% ׼����fixation��ͼ��
fixationFileName = 'fixation.jpg';
fixationPathName = sprintf('%s/%s', picsFolderName, fixationFileName);
fixation_imgMatrix = imread(fixationPathName);

% ׼����error��ͼ��
errorFileName = 'Errorinfo.jpg';
errorPathName = sprintf('%s/%s', picsFolderName, errorFileName);
imgMatrix_Error = imread(errorPathName);

% ׼�������еĴ̼���ͼ������
% mType = cjMatrix(ID, Type_Column);
% mWord = cjMatrix(ID, Word_Column);
% mColor = cjMatrix(ID, Color_Column);
% tmpWord = strCells_Words_Eng{mWord};
% tmpColor = strCells_Colors_Eng{mColor};
% cjFileName = sprintf('word_%s_color_%s.jpg', tmpWord, tmpColor);
% cjPathName = sprintf('%s/%s', picsFolderName, cjFileName);



cjMatrix_word = generate_cjMatrix_Word();


% open a .txt file for store the data
txtFileName_Result = 'expTimePressure_data_word.txt';
fid = fopen(txtFileName_Result, 'a+');
% LOOP: index is i
for i = 1:length(cjMatrix_word)
    [rt acc] = singleTrial(wptr, cjMatrix_word, i, fixation_imgMatrix, imgMat_cjCells, imgMatrix_Error);
    if acc == 999
         % ��ʾ���
         break;
    end
    
    tmpArr = [cjMatrix_word(i,:) rt acc];
    tmpLine = sprintf('%d\t%d\t%d\t%d\t%d\t%.3f\t%d', tmpArr);
    fprintf(fid, '%s\r\n', tmpLine);
end
fclose(fid);

% Bye bye
% filename
jpgFileName_Instruction = 'Instruction_Bye.jpg';
jpgPathName_Instruction = sprintf('%s/%s', picsFolderName, jpgFileName_Instruction);
imgMat_Instruction_Bye = imread(jpgPathName_Instruction);
Instruction(wptr, imgMat_Instruction_Bye);

% ��ʾ���
ShowCursor;
 
% �رռ��̼���
ListenChar(1);

% �رմ���
Screen('CloseAll');


catch
    
    % ��ʾ���
ShowCursor;

% �رռ��̼���
ListenChar(1 );

% �رմ���
Screen('CloseAll');

% 
Priority(0);
psychrethrow(psychlasterror);

end