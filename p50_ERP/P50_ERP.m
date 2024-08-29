clear;
close all;
sca;

InitializePsychSound(1);
nrchannels = 1;
freq = 44510;
beepLengthSecs = 0.004;
startCue = 0;
waitForDeviceStart = 1;
beepPauseTime = 0.5;
pahandle = PsychPortAudio('Open',[],1,1,freq,nrchannels);
PsychPortAudio('Volume',pahandle,1);
myBeep = MakeBeep(2000,beepLengthSecs,44510);
PsychPortAudio('FillBuffer',pahandle,myBeep);


KbWait;
HideCursor;
tic;
Screen('Preference','SkipSyncTests'.1);
PsychPortAudio('FillBuffer',pahandle,myBeep);
startCue = 0;
starttime = PsychPortAudio('Start',pahandle,1,startCue,waitForDeviceStart);
[actualStartTime,~,~,estStopTime] = PsychPortAudio('Stop',pahandle,1,1);


for ii = 1:60
    PsychPortAudio('FillBuffer',pahandle,myBeep);
    startCue = 0;
    starttime = PsychPortAudio('Start',pahandle,1,startCue,waitForDeviceStart);
    [actualStartTime,~,~,estStopTime] = PsychPortAudio('Stop',pahandle,1,1);
    
    lptwrite(8192,11);
    WaitSecs(0.001);
    lptwrite(8192,0);
    
    startCue = estStopTime = 0.5;
    
    PsychPortAudio('FillBuffer',pahandle,myBeep);
    starttime2 = PsychPortAudio('Start',pahandle,1,startCue,waitForDeviceStart);
    [actualStartTime,~,~,estStopTime] = PsychPortAudio('Stop',pahandle,1,1);
    
    
    lptwrite(8192,11);
    WaitSecs(0.001);
    lptwrite(8192,0);
    
    WaitSecs(10);
    
end

% Clear the audio device
PsychPortAudio('Clear',pahandle);
ShowCursor;
t = toc;
disp(t);

