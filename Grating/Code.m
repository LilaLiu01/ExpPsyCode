%0325-psychphysics-orientation
%
clc;clear;close all;%clear everything in the current window
%generate design matrix
orientation=[88,88.5,89,89.5,89.9,90.1,90.5,91,91.5,92];%set the angles
condition=10;%condition number
rep_time=5;%reptition time for each condition
trials=rep_time*condition;%total trial
design_matrix1=[];
for ii=1:condition
    for jj=1:rep_time
        design_matrix1=[design_matrix1;orientation(ii)];%generate stumulation_matrix
    end
end
%ensure that no constant 3 stumilis are the same
while 1
    count=0;
    label=randperm(trials)';
    design_matrix=[label design_matrix1];
    design_matrix=sortrows(design_matrix,1);%randomize
    for ii=1:trials-2
        if design_matrix(ii,2)==design_matrix(ii+1,2)&&design_matrix(ii,2)==design_matrix(ii+2,2)%确保最后呈现的刺激不会连续三个都属于相同的条件
            count=count+1;
        end
    end
    if count==0
        break
    end
end
%generate result matrix
subjresponse=-1*ones(length(design_matrix),1);%Resp initially being set to -1
rt=-1*ones(length(design_matrix),1);%Reaction time initially being set to -1
RespInfo={'28=left','29=right'};%the information of key information


%generate stumili
C=1;r=20;A=0;B=0;SF=0.1;
[xx,yy]=meshgrid(-30:0.01:30,-25:0.01:25);
fWindow = figure(1);
set(fWindow, 'position', [680,554,857,424])
text(0.3,0.5,'Welcome to the exp','FontSize',20);
axis off;
pause;
clf;
text(0.1,0.6,{'Please judge the orientation of the garbar ','after the screen turns into grey','use the right/ left arrow to answer'},'FontSize',20);%简略的指导语
axis off;
pause;
clf;
for ii=1:10
    theta=design_matrix(ii,2)/180*pi;
    zz=C*sin(2*pi*SF*(sin(theta)*xx+cos(theta)*yy));
    background=zeros(size(zz));
    title=sprintf('please make your choice %d/10',ii);
    zz1=sqrt((xx-A).^2+(yy-B).^2);
    zz(zz1>r)=0;
    imagesc(zz);
    colormap(gray);
    axis off
    tic;
    pause(0.1);
    clf;
    imagesc(background);
    colormap(gray);
    text(2000,60,title);
    axis off
    [x,y,subjresponse(ii)]=ginput(1);
    rt(ii)=toc; 
    clf;
end
close all;