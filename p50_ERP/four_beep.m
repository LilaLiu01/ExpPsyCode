% Clear the workspace and the screen

close all;
clearvars;

PsychDefaultSetup(2);
AssertOpenGL;

Screen('Preference','SkipSyncTests', 1);
screens = Screen('Screens');
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

[xCenter, yCenter] = RectCenter(windowRect);

Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, 36);

line1 = 'Hello and Thanks for your participation';
line2 = '\n\n\n\n In this experiment you will see a fixation cross and you will hear a "BEEP" sound at different time intervals';
line3 = '\n\n You can freely choose when you want to perform the movement AFTER the "BEEP"';
line4=  '\n\n\n\n\n\n When you are ready .... lets start';
% Draw all the text in one go
Screen('TextSize', window, 20);
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels * 0.25, white);

% Flip to the screen
Screen('Flip', window);

KbStrokeWait;

%----------------------------------------------------------------------

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% set the coordinates
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

% Draw the fixation cross
Screen('DrawLines', window, allCoords,...
    lineWidthPix, white, [xCenter yCenter], 2);

% Flip to the screen
Screen('Flip', window);

%-----------------------------------------------------------------------

% Initialize Sounddriver
InitializePsychSound(1);

% Number of channels and Frequency of the sound
nrchannels = 2;
freq = 48000;

% How many times to we wish to play the sound
repetitions = 1;

% Length of the beep
beepLengthSecs = 0.2 ;

% Length of the pause between beeps
beepPauseTime =  WaitSecs(randi([1, 5]));

% Start immediately (0 = immediately)
startCue = WaitSecs(5);

waitForDeviceStart = 1 ;

pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);

% Set the volume to half for this demo
PsychPortAudio('Volume', pahandle, 0.5);

% Make a beep which we will play back to the user
myBeep = MakeBeep(500, beepLengthSecs, freq);

% Fill the audio playback buffer with the audio data, doubled for stereo
% presentation
PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);

% Start audio playback 1
PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
WaitSecs(randi([10, 15]));

% Start audio playback 2
PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
WaitSecs(randi([10, 15]));

% Start audio playback 3
PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
WaitSecs(randi([10, 15]));

% Start audio playback 4
PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
WaitSecs(randi([10, 15]));

% Close the audio device
PsychPortAudio('Close', pahandle);
% Clear the screen
sca;