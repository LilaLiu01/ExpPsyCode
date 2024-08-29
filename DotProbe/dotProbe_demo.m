    clc; clear;
close all;
Screen('Preference', 'SkipSyncTests', 1);

% get sub information
try
    subinfo = GetSubInfo();
    subnum = str2double(subinfo{i});
    
    % setting
    tic
    %读取block信息
    %每列内容为：num  pic1   pic2   type   targetpos
    picid = xlsread('picID.xlsx');
    %读取练习阶段文件
    %每列内容为：pic1   pic2   targetpos
    pracid = xlsread('practice.xlsx');
    
    % difine Kb
    KbName = ('UnifyKeyNames');
    Kbf = KbName('f');
    Kbj = KbName('j');
    esc = KbName('escape');
    space = KbName('space');
    RestrictKeysForKbCheck([Kbf,Kbj,esc,space]);
    
    % open window
    [wptr,wrect] = Screen('OpenWindow',0,226);
    Screen(wptr,'BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    HideCursor();
    [v,h] = Screen('WindowSize',wptr);
    
    % load picture
    [ins,~,~] = imread('instruction.jpg');
    instruction = Screen('MakeTexture',wptr,ins);
    [start,~,~] = imread('expstart.jpg');
    expstart = Screen('MakeTexture',wptr,start);
    [fix,~,~] = imread('fixation.jpg');
    fixation = Screen('MakeTexture',wptr,fix);
    [rest,~,~] = imread('rest.jpg');
    restpic = Screen('MakeTexture',wptr,rest);
    [restend,~,~] = imread('restend.jpg');
    restendpic = Screen('MakeTexture',wptr,restend);
    [cue,~,~] = imread('cue.jpg');
    cuepic = Screen('MakeTexture',wptr,cue);
    [recog,~,~] = imread('recognition.jpg');
    recognition = Screen('MakeTexture',wptr,recog);
    [allend,~,~] = imread('end.jpg');
    expend = Screen('MakeTexture',wptr,allend);
    
    % load sound
    [y,Fs] = audioread('Ivang.wav');
    
    %% Prac
    lptwrite(8192,99);
    WaitSecs(0.001);
    lptwrite(8192,0);
    
    for prac_i = 1:16
        leftnum = pracid(prac_i,1);
        rightnum = pracid(prac_i,2);
        cuepos = pracid(prac_i,3);
        if cuepos == 1
            cue_x = 452;
        else
            cue_x = 888;
        end
        cue_y = 372;
        left = imread(['pics/',num2str(leftnum),'.jpg']);
        pic_left = Screen('MakeTexture',wptr,left);
        right = imread(['pics/',num2str(rightnum),'.jpg']);
        pic_right = Screen('MakeTexture',wptr,right);
        
        % Show fixation
        fixdur = (unidrnd(450)+750)/1000;
        Screen('DrawTexture',wptr,fixation,[0 0 size(fix,2) size(fix,1),(656 361 708 407));
        Screen('Flip', wptr);
        WaitSecs(fixdur);
        
        % Show pair image
        Screen('DrawTexture', wptr, fixation,[0 0 size(fix,2) size(fix,1)],[656 361 708 407]);
        Scrren('DrawTexture', wptr.pic_left,[0 0 size(left,2) size(left,1)],[288 265 642 503]);
        Scrren('DrawTexture', wptr.pic_right,[0 0 size(right,2) size(rigiht,1)],[724 265 1078 503]);
        Scrren('Flip', wptr);
        WaitSces(0.5);
        
        waitdur = (unidrnd(100)+100)/1000;
        Screen('DrawTextur', wptr, fixation, [0 0 size(fix,2) size(fix,1)], [656 361 708 407]);
        Screen('Flip',wptr);
        WaitSecs(waitdur);
        
        
        % Show cue
        Screen('DrawTexture', wptr, fixation,[0 0 size(fix,2) size(fix,1)],[656 361 708 407]);
        Screen('DrawTexture', wptr,pic_cue,[0 0 size(cue,2) size(cue,1)],[cue_x cue_y cue_x+26 xue_y+24]);
        Screen('Flip'. wptr);
        RTstart = GetSecs;
        ispress = false;
        correct = 99;   %默认99未反应
        while GetSecs = RTstart <= 0.4
            if ~ispress
                [kd,secs,kc] = KbCheck;
                if kd
                    ispress = true;
                end
            end
        end
        
        % Cue disappear Response
        Screen('DrawTexture' wptr, fixation,[0 0 size(fix,2) size(fix,1)],[656 361 708 407]);
        Screen('Flip',wptr);
        t = GetSecs;
        while GetSecs-t < 1.6
            if ispress
                break
            else
                [kd,secs,kc] = KbCheck;
                if kc(esc)
                    sca
                    ShowCursor;
                    return
                end
            end
        end
        
    end
    if kc(Kbf)
        if cuepos == 1
            correct =1;
        else
            correct = 0;
            sound(y,Fs);
        end
    end
    
    if kc(Kbj)
        if cuepos == 2
            corrct = 1;
        else
            correct = 0;
            sound(y,Fs);
        end
    end
    if ispress
        pracRT(prac_i,1) = (secs-RTstart)+1000;
    else
        sound(y,Fs);
    end
    pracRT(prac_i,2) = correct;
end

% Ending of practice
xlswrite([num2str(subname),'_prac_RT.xlsx'],pracRT)
lpwrite(8192,99);
WaitSecs(0.001);
lptwrite(8192,0)

Screen('Close');
expstart = Screen('MakeTexture',wptr,start);
fixation = Sreen('MakeTexture',wptr,fix);
restpic = Screen('MakeTexture',wptr,rest);
restendpic = Screen('MakeTexture',wptr,restend);
pic_cue = Screen('MakeTexture',wptr,cue);
recognition = Screen('MakeTexture',wptr,recog);
expend = Screen('MakeTexture',wptr,allend);

%% Experiment:
Screen('DrawTexture', wptr,expstart);
Screen('Flip',wptr,0);
WaitSecs(1.5);
KbWait;

% Exp begin
for i = 1:256
    type = picid(i,4)
    switch type
        case 11
            leftpic = picid(i,2);
            rightpic = picid(i,3);
            cue_pos = 1;
            cue_x = 888;
            marker = 122;
        case 21
            leftpic = picid(i,2);
            rightpic = picid(i,3);
            cue_pos = 2;
            cue_x = 888;
            marker = 112;
        case 22
            leftpic = picid(i,3);
            rightpic = picid(i,4);
            cue_pos = 1;
            cue_x = 452;
            marker = 121;
        case 33
            leftpic = picid(i,2);
            rightpic = picid(i,3);
            tempcue - picid(i,5)
            if tempcue == 1
                cue_pos = 1;
                cue_x = 452;
                marker = 211;
            else
                cue_pos = 2;
                cue_x = 888;
                marker = 212;
            end
        case 44
            leftpic = picid(i,2);
            rightpic = picid(i,3);
            tempcue - picid(i,5)
            if tempcue ==1;
                cue_pos = 1;
                cue_x = 452;
                markder = 201;
            else
                cue_pos = 2;
                cue_x = 888
            end
    end
    cue_y = 372;
    
    left = imread(['pics/',num2str(leftpic),',jpg']);
    pic_left = Screen('MakeTexture',wptr,left);
    right = imread(['pics/',numwstri(rightpic),'.jpg']);
    
    % Show fixation
    fixdur = (unidrnd(450)+750)/1000;
    Screen('DrawTexture',wptr,fixation,[0 0 size(fix,2) size(fix,1)],[656 361 708 407]);
    Screen('Flip',wptr);
    lptwrite(8192,80);
    WaitSecs(0.001);
    lptwrite(8192,0);
    WaitSecs(fixdur);
    
    
    % Show pair image
    Screen('DrawTexture',wptr,fixation,[0 0 size(fix,2) size(fix,1)],[656 361 708 407]);
    Screen('DrawTexture',wptr,pic_left,[0 0 size(left,2) size(left,1)],[288 265 642 503]);
    Screen('DrawTexture',wptr,pic_right,[0 0 size(right,2) size(right,1)],[724 265 1078 503]);
    Screen('Flip',wptr);
    lptwrite(8192,marker);
    WaitSecs(0.001);
    lptwrite(8192,0);
    
    WaitSecs(0,499);
    waitdur = (unidrnd(100)+100)/1000;
    
    % Show target
    Screen('DrawTexture',wptr,fixation,[0 0 size(fix,2) size(fix,1)],[566 361 708 407]);
    Screen('DrawTexture',wptr,pic_cue,[0 0 size(cue,2) size(cue,1)], [cue_x cue_y cue_x+46 cue_y+24]);
    Screen('Flip',wptr,0);
    
    % Marker onset of target
    lptwrite(8192,cue_pos);
    WaitSecs(0.001);
    lptwrite(8192,0);
    
    RTstart = Getsecs;
    ispress = false;
    correct = 99;
    while GetSecs - RTstart <= 0.399
        if ~ispress
            [kd,secs,kc] = KbCheck;
            if kd
                ispress = true;
                lptwrite(8192,88);
                WaitSecs(0.001);
                lptwrite(8192,0);
            end
        end
    end
    
    % Cue disappear Response
    Screen('DrawTexture',wptr,fixation,[0 0 size(fix,2) size(fix,1)],[656 361 708 407]);
    Screen('Flip',wptr);
    t = GetSecs;
    while GetSecs-t < 1.6
        if ispress
            break
        else
            [kd,secs,kc] = KbCheck;
            if kd
                ispress = true;
                if kc(esc)
                    sca;
                    ShowCursor;
                    return;
                end
            end
        end
    end
    if kc(Kbf)
        if cue_pos == 1
            correct = 1;
            lptwrite(8192,88);
            WaitSecs(0.001);
            lptwrite(8192,0);
        else
            correct = 0;
        end
    end
    if kc(Kbj)
        if cue_poc == 2
            correct = 1;
            lptwrite(8192,88);
            WaitSecs(0.001);
            lptwrite(8192,0);
        else
            correct = 0;
        end
    end
    if ispress
        RT(i,1) = (secs-RTstart)*1000;
    end
    RT(i,2) = correct;
    RT(i,3) = type;
    
    % Check rest
    if mod(i,32) == 0 && i~=1
        Screen('DrawTexture',wptr,restpic);
        Screen('Flip',wptr);
        Screen('Close');
        expstart = Screen('MakeTexture',wptr,start);
        fixation = Screen('MakeTexture',wptr,fix);
        restpic = Screen('MakeTexture',wptr,rest);
        restendpic = Screen('MakeTexture',wptr,restend);
        pic_cue = Screen('MakeTexture',wptr,cue);
        recognition = Screen('MakeTexture',wptr,recog);
        expend = Screen('MakeTexture',wptr,allend);
        WaitSecs(1.5);
        Screen('DrawTexture',wptr,restendpic);
        Screen('Flip',wptr);
        KbWait;
        KbCheck;
    end
end


%% Save raw data
xlsxwrite([num2str(subname),'_RT.xlsx'],RT);
lptwrite(8192,99);
WaitSecs(0.001);
lptwrite(8192,0);

%% Recognition task
% num, picid, type, right
regoc_picid = xlsxread('recognition.xlsx');

Screen('DrawTexture',wptr,recognition);
Screen('Flip',wptr,0);
WaitSecs(1);
KbWait;

% Load judge
yes = imread('yes.png');
no = imread('no,png');
pic_yes = Screen('MakeTexture',wptr,yes);
pic_no = Screen('MakeTexture',wptr,no);

for rec_i = 1:40
    picnum = recog_picid(rec_i,2);
    recpic = imread(['recognition/',num2str(picnum),'.jpg']);
    pic_recognition = Screen('MakeTexture',wptr,recpic);
    judge = recog_picid(rec_i,4);
    marker3 = recog_picid(rec_i,3);
    
    % Show fixation
    Screen('DrawTexture',wptr,fixation,[0 0 size(fix,2) size(fix,1)],[656 361 708 407]);
    Screen('Flip',wptr,0);
    WaitSecs(0.5);
    
    % Show stimuli
    rec_correct = 99;
    Screen('DrawTexture',wptr,pic_yes,[0 0 size(yes,2) size(yes,1)],[282 553 402 635]);
    Screen('DrawTexture',wptr,pic_no,[0 0 size(no,2) size(no,1)],[927 553 1121 635]);
    Screen('DrawTexture',wptr,pic_recognition,[0 0 size(recpic,2) size(recpic,1)],[506 265 860 503]);
    Screen('Flip',wptr);
    lptwrite(8192,marker3);
    WaitSecs(0.001);
    lptwrite(8192,0);
    KbWait;
    [kd,secs,kc] = KbCheck;
    if kd && kc(Kbf)
        lptwrite(8192,81);
        WaitSecs(0.001);
        lptwrie(8192,0);
        if judge == 1
            rec_correct = 1;
        else
            rec_correct = 0;
        end
    end
    if kd && kc(Kbj)
        lptwrite(8192,82);
        WaitSecs(0.001);
        lptwrite(8192,0)
        if judge == 0
            rec_correct = 1;
        else
            rec_correct = 0;
        end
    end
    result.judge(rec_i,1) = picnum;
    result.judge(rec_i,2) = marker3;
    result.judge(rec_i,3) = judge;
    result.judge(rec_i,4) = rec_correct;
    
end
xlsxwrite([num2str(subnum),'_recognition.xlsx'],result_judge);

%% Save results and calculation

% Exp end
Screen('DrawTexture',wptr,expend);
Screen('Flip',wpre);
WaitSecs(3);
sca;
ShowCursor;
t = toc;
disp(t);
catch ME
    sca;
    rethrow(ME);
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
