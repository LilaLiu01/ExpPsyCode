% filename is:: parityExperiment_zjyo.m

% clear
clc; clear; close all;

%�������'SYNCHORIZATION FAILURE!!!'�ɽ����м���ע�͸ĳ������ѹ�ƴ˾���
Screen('Preference', 'SkipSyncTests', 2);
Screen('Preference','VisualDebugLevel',4);
Screen('Preference','SuppressAllWarnings',1);

% prepare foldernames
picsFolderName = 'PicturesR';

% prepare strCells
digitArr = 1:8; digitArr = digitArr';

imgMat_cjCells = {}; 
for p = 1:length(digitArr)
    tmpItem = digitArr(p);
    jpgFileName = sprintf('A%d.jpg',tmpItem);
    jpgPathName = sprintf('%s/%s', picsFolderName, jpgFileName);
    imgMat_cjCells{p} = imread(jpgPathName);
end
imgMat_cjCells = imgMat_cjCells';



try

% filename
jpgFileName_Instruction = 'Instruction_Start_zjyo.jpg';
jpgPathName_Instruction = sprintf('%s/%s', picsFolderName, jpgFileName_Instruction);

%
imgMat_Instruction = imread(jpgPathName_Instruction);

% prepare color for background
bkgColor = [0 0 0];


[wptr, rect] = Screen('OpenWindow', 0, bkgColor);

% �رռ��̼���
ListenChar(2);

% ����
HideCursor;

% show the instruction
Instruction(wptr, imgMat_Instruction, rect);

% �ȴ����԰���
% KbWait;

% ׼����fixation��ͼ��
fixationFileName = 'fixation.jpg';
fixationPathName = sprintf('%s/%s', picsFolderName, fixationFileName);
fixation_imgMatrix = imread(fixationPathName);

% ����̼�����
cjMatrix = generate_cjMatrix_zjyo();

% open a .txt file for store the data
txtFileName_Result = 'expParity_zjyo.txt';
fid = fopen(txtFileName_Result, 'w+');
fclose(fid);
% LOOP: index is i
for i = 1:10      %length(cjMatrix)
    [rt acc] = singleTrial(wptr, cjMatrix, i, fixation_imgMatrix, imgMat_cjCells);
    if acc == 999
         % ��ʾ���
         break;
    end
    
    tmpArr = [cjMatrix(i,:) round(rt*1000) acc];
    tmpLine = sprintf('%d\t%d\t%d\t%d\t%d\t%d', tmpArr);
    
    fid = fopen(txtFileName_Result, 'a+');
    fprintf(fid, '%s\r\n', tmpLine);
    fclose(fid);
end


% Bye bye
% filename
jpgFileName_Instruction = 'Instruction_Bye.jpg';
jpgPathName_Instruction = sprintf('%s/%s', picsFolderName, jpgFileName_Instruction);
imgMat_Instruction_Bye = imread(jpgPathName_Instruction);
Instruction(wptr, imgMat_Instruction_Bye, rect);

% ��ʾ���
ShowCursor;

% �رռ��̼���
ListenChar(0);

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