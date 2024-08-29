function ab_classic_demo(subID, subNum)
% by letitia, 2016-05-24.
% ab_classic_demo('John',1)
% Test T2's effect on T1, identify letters from digits.

%%
%----------------------------------------------------------------------
%                       Check the input
%----------------------------------------------------------------------
if nargin < 2
    error('please input the subject'' name and number.')
end

%----------------------------------------------------------------------
%       Get subject Information
%----------------------------------------------------------------------
% Set subject name
subject.name = subID;

% Set subject handedness
subject.handedness = input('Handedness L/R [R]: ','s');
if isempty(subject.handedness)
    subject.handedness = 'R';
end

% Set subject gender
subject.gender = input('Gender M/F [F]: ','s');
if isempty(subject.gender)
    subject.gender = 'F';
end

% Set subject age
subject.age = input('Age: ');
if isempty(subject.age)
    warning('No age was input!');
end

%----------------------------------------------------------------------
%       define parameters that need to be modified
%----------------------------------------------------------------------
trial_num = 160;  % Lag position (8) x trials per Lag (20) .
pic_dur = 0.1;   %  100 ms.
bla_dur = 1;

%----------------------------------------------------------------------
%       response key settings
%----------------------------------------------------------------------
KbName('UnifyKeyNames');
rkey = [KbName('a') KbName('c') KbName('d') KbName('e') KbName('f') KbName('g') KbName('h') KbName('j') KbName('k') KbName('l'),...
    KbName('m') KbName('n') KbName('p') KbName('q') KbName('r') KbName('s') KbName('t') KbName('u') KbName('v') KbName('w'),...
    KbName('x') KbName('y')];
skey = KbName('space');
qkey = KbName('escape');
ckey = KbName('rightarrow');  % continue key for the next block.

%----------------------------------------------------------------------
%       Set up PTB enviorment
%----------------------------------------------------------------------
AssertOpenGL;
Screen('Preference', 'VisualDebugLevel', 1); % make the initial screen black instead of white
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','TextEncodingLocale','UTF-8');
warning off;
HideCursor;

% set the color
bgColor = [80 80 80];    % Background color
fixColor =  [47 47 47];  % fixation color
targetColor = [53 53 53];   % target color
disColor = [47 47 47];   % distractor color

% initial the screen
ScrNum = max(Screen('Screens'));
[windowPtr, screenRect] = Screen('OpenWindow', ScrNum, bgColor);
slack = Screen('GetFlipInterval', windowPtr);
fontSize = 40;   % Size of font
fontName = 'Baoli SC';  % Font to use
Screen('TextFont', windowPtr, fontName);
Screen('TextSize', windowPtr, fontSize);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  % enable alpha blending

% calculating the pixels per degree (visual angle)
d = 70; % viewing distance：70cm
sw = 36.5; % screen width in cm ：36.5cm
sr = screenRect(3); % screen resolution (width)：1920
pd = (pi/180) * d * sr/sw;  % pixes per degree. 视角计算

% set the size and location of fixation, target picture, and instruction
fixRect = [0,0,0.25*pd,0.25*pd];  % fixiation: 0.25°.
targetRect = [0,0,1.20*pd,1.16*pd];   % target pic :1.20°*1.16°.
quesRect = [0,0,1000,800];
fixPosn = CenterRect(fixRect, screenRect); %CenterRect把矩形放到另外一个矩形的中心
targetPosn =  CenterRect(targetRect, screenRect);
questPosn =  CenterRect(quesRect, screenRect)-[0,100,0,100];

%----------------------------------------------------------------------
%       Make texutures for all images
%----------------------------------------------------------------------
rootDir = pwd;
thedir = [rootDir filesep 'testpi'];
cd(thedir);

hint = {'q1', 'q2'};
for i = 1:2
    img = sprintf('%s.png',hint{i});
    imgArray = imread(img);
    imgArray(:,:,1) = ~(squeeze(imgArray(:,:,1))/255)*fixColor(1); % replace the bg color
    imgArray(imgArray(:,:,1)==0) = bgColor(1);   % replace the word color
    imgArray(:,:,2) = imgArray(:,:,1);
    imgArray(:,:,3) = imgArray(:,:,2);
    switch i
        case 1
            imgPtr_q1 = Screen('MakeTexture', windowPtr, imgArray);
        case 2
            imgPtr_q2 = Screen('MakeTexture', windowPtr, imgArray);
    end
end

movie = 1:28;
for i = 23:28     %distractors color.
    imgArray = imread([num2str(i),'.png']);
    imgArray(:,:,1) = ~(squeeze(imgArray(:,:,1))/255)*disColor(1);
    imgArray(imgArray(:,:,1)==0) = bgColor(1);
    imgArray(:,:,2) = imgArray(:,:,1);
    imgArray(:,:,3) = imgArray(:,:,2);
    movie(i) = Screen('MakeTexture', windowPtr, imgArray);
end
for i = 1:22     %targets color.
    imgArray = imread([num2str(i),'.png']);
    imgArray(:,:,1) = ~(squeeze(imgArray(:,:,1))/255)*targetColor(1);
    imgArray(imgArray(:,:,1)==0) = bgColor(1);
    imgArray(:,:,2) = imgArray(:,:,1);
    imgArray(:,:,3) = imgArray(:,:,2);
    movie(i) = Screen('MakeTexture', windowPtr, imgArray);
end
cd(rootDir);

%----------------------------------------------------------------------
%       Generate design matrix
%----------------------------------------------------------------------
numItem = 22;     % every trial has 22 Items.
disNum = 23:28;    %distractor (digitals): 345679.
targetNum =1:22;    %target (letters): ACDEFGHJKLMNPQRSTUVWXY
trial = NaN(trial_num,numItem)
%%% record: 1:trial number.  2:T1 position   3:T2 position(lag)  4:T1 target;  5:T2 target;   6:T1 response;   7:T2 response.
record = NaN(trial_num,7);
record(:,1) = 1:trial_num;
record(:,2) = Shuffle(mod(1:trial_num,5)'+7);
for i=1:5
    record(record(:,2)==i+6,3) = Shuffle(mod(1:trial_num/5,8)'+1);
end

%%% stimuli of visual stream in each trial.
trial = NaN(trial_num,numItem);
for i = 1:trial_num
    diss = [Shuffle(disNum),Shuffle(disNum),Shuffle(disNum),Shuffle(disNum)];
    for n = 1:(length(diss)/6-1)
        if diss(6+n) == diss(6*n+1)
            mr = diss(6+n);
            diss(6+n) = diss(6*n-1);
        end
    end
    trial(i,:) = diss(1:numItem); 
    
    targets = randperm(length(targetNum));
    
    record(i,5) = targets(1);
    trial(i,record(i,2)+record(i,3)) = targets(1);
    
    record(4) = targets(2);
    trial(i,record(i,2)) = targets(2);
end
  
%----------------------------------------------------------------------
%      show instructions and start the experiment
%----------------------------------------------------------------------
% show instructions
priorityLevel=MaxPriority(windowPtr);
Priority(priorityLevel);
instruction='Please fixate at all times!';
trigStr = 'Press SPACE key to start...';
Screen('FillRect', windowPtr, bgColor, screenRect);
DrawFormattedText(windowPtr, [instruction '\n \n' trigStr], 'center', 'center', fixColor);
Screen('Flip', windowPtr);

while KbCheck; end
while 1
    [keyIsDown,timeSecs,keyCode] = KbCheck;
    if keyIsDown && keyCode(skey)
        break;
    end
end

%%% experiment begins
for theTrial = 1:trial_num
    if ~mod(theTrial,41) && (theTrial ~= 1)
        DrawFormatText(windowPtr, ['Plz have a rest' '\n\n' 'press anywhere to continue']);
        Screen('DrawingFinished',windowPtr);
        Screen('Flip',windowPtr);
        WaitSecs(30);
        white kbCheck;
    end
    
    while 1
        [keyIsDown, ~, keyCode] = kbCheck;
        if keyIsDown && leyCode(ckey)
            break;
        end
        if keyIsDown && keyCode(ckey)
            break;
        end
        if keyIsDown && keyCode(qkey)
            disp('ESC key is pressed, quit ...');
            cd(rootDir);
            Screen('CloseAll');
            sca;
            return;
        end
        
       Screen('FillRect',windowPtr,bgColor,screenRect);
       Screen('FillOval',windowPtr,fixColor,fixPosn);
       Screen('Flip',windwPtr);
       
       % START OF THE TRIAL-- PRESSING SPACE
       while kbCheck;
       end
       while 1
           [keyIsDown,~,keyCode] = kbCheck;
           if keyIsDown && keyCode(skey)
               break;
           end
           if keyIsDown && keyCode(qkey)
               disp('ESC key is pressed, quit...');
               cd(rootDir);
               Screen('CloseAll');
               sca;
               return;
           end
           
%----------------------------------------------------------------------

%%% record the data information.
% Data.subID = subID;
% Data.subNum = subNum;
Data.record = record;
Data.trial = trial;
outfile = sprintf('S%02d_%s_ab_classic.mat', subNum, subID);
save(outfile, 'Data','pic_dur', 'screenRect','subject');

Screen('CloseAll');
sca;
warning on;


