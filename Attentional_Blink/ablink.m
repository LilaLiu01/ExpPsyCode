function ablink
%----------------------------------------------------------------------
%                       Get subject Information
%----------------------------------------------------------------------
% set sub name
subject.name = input('subID: ','s');

 
%set sub handedness
subject.handedness = input('Handedness L/R [R]: ','s');
if isempty(subject.handedness)
    subject.handedness = 'R';
end

%set sub gender
subject.gender = input('Gender M/F [F]: ','s');
if isempty(subject.gender)
    subject.gender = 'F';
end
 
%set sub age
subject.age = input('Age: ');
if isempty(subject.age)
    warning('No age was input!');
end

%----------------------------------------------------------------------
%                       Define parameters
%----------------------------------------------------------------------
trail_num = 160;
numItem = 22;
pic_dur = 0.1;
bla_dur = 0,1;
%---------------------------------------------------------------------
%                       response key settings
%----------------------------------------------------------------------
KbName('UnifyKeyNames'); 
rkey1 = KbName('a');
rkey2 = KbName('c');
rkey3 = KbName('d');
rkey4 = KbName('e');
rkey5 = KbName('f');
rkey6 = KbName('g');
rkey7 = KbName('h');
rkey8 = KbName('j');
rkey9 = KbName('k');
rkey10 = KbName('l');
rkey11 = KbName('m');
rkey12 = KbName('n');
rkey13 = KbName('p');
rkey14 = KbName('q');
rkey15 = KbName('r');
rkey16 = KbName('s');
rkey17 = KbName('t');
rkey18 = KbName('u');
rkey19 = KbName('v');
rkey20 = KbName('w');
rkey21 = KbName('x');
rkey22 = KbName('y');
skey = KbName('space');
qkey = KbName('escape');
kpkey = KbName('rightarrow');
 
%----------------------------------------------------------------------
%                       Set up PTB enviorment
%----------------------------------------------------------------------
AssertOpenGL;
Screen('Preference','VisualDebugLevel',1);
Screen('Preference','SkipSyncTests',1);
Screen('Preference','TextEncodingLocale','UTF-8');
warning off;
HideCursor;
ScrNum = max(Screen('Screens'));
screenRect = Screen('Rect',ScrNum);
 
% calculating the pixels
d = 70;
sw = 36.5;
sr = screenRect(3);
pd = (pi/180)*d*sr/sw;
 
% set size and location of fix
fixRect = [0,0,0.25*pd,0.25*pd];
targetRect = [0,0,1.20*pd,1.16*pd];
quesRect = [0,0,1000,800];
fixPosn = CenterRect(fixRect,screenRect);
targetPosn = CenterRect(targetRect,screenRect);
questPosn = CenterRect(quesRect,screenRect)-[0,100,0,100];
 
% set the color
bgColor = [80 80 80];
fixColor = [47 47 47];
targetColor = [53 53 53];
disColor = [47 47 47];
 
% initial the screen
windowPtr = Screen('OpenWindow',ScrNum,bgColor);
slack = Screen('GetFlipInterval',windowPtr);
fontSize = 40;
fontName = 'Baoli SC';
Screen('TextFont',windowPtr,fontName);
Screen('TextSize',windowPtr,fontSize);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
